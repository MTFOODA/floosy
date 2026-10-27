import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../../domain/entities/transaction_model.dart';
import '../../domain/entities/user_model.dart';

/// A lightweight bank identity used for sender/text matching without
/// depending on database-generated ids (the DB assigns real uuids).
class KnownBank {
  final String code;
  final String name;
  final String nameAr;

  /// Additional legitimate sender/body spellings used by real bank SMS.
  /// These are aliases only; [name] remains the persisted display identity.
  final List<String> aliases;
  const KnownBank({
    required this.code,
    required this.name,
    required this.nameAr,
    this.aliases = const [],
  });
}

/// Static catalog of Egyptian banks used for offline sender/body detection.
/// The remote catalog (from Supabase) is preferred when available; this list
/// guarantees detection works even before the first sync.
class BankCatalog {
  static const List<KnownBank> banks = [
    KnownBank(
        code: 'CIB',
        name: 'Commercial International Bank',
        nameAr: 'البنك التجاري الدولي'),
    KnownBank(
        code: 'NBE',
        name: 'National Bank of Egypt',
        nameAr: 'البنك الأهلي المصري'),
    KnownBank(code: 'MISR', name: 'Banque Misr', nameAr: 'بنك مصر'),
    KnownBank(code: 'QNB', name: 'QNB Egypt', nameAr: 'بنك قطر الوطني مصر'),
    KnownBank(
        code: 'ALEX',
        name: 'AlexBank',
        nameAr: 'بنك الإسكندرية',
        aliases: [
          'bank of alexandria',
          'alex bank',
          'alexbank',
          'ab magnifica',
          'ab private',
          '4988'
        ]),
    KnownBank(code: 'HSBC', name: 'HSBC Egypt', nameAr: 'بنك HSBC مصر'),
    KnownBank(
        code: 'ADIB',
        name: 'Abu Dhabi Islamic Bank',
        nameAr: 'مصرف أبوظبي الإسلامي'),
    KnownBank(
        code: 'ENBD', name: 'Emirates NBD', nameAr: 'بنك الإمارات دبي الوطني'),
    KnownBank(code: 'FAB', name: 'FAB Egypt', nameAr: 'البنك الأول بأبو ظبي'),
    KnownBank(
        code: 'AAIB',
        name: 'Arab African International Bank',
        nameAr: 'العربي الأفريقي الدولي'),
    KnownBank(code: 'FAISAL', name: 'Faisal Bank', nameAr: 'بنك فيصل'),
  ];

  /// Best-effort match against the static catalog.
  static KnownBank? match(String? sender, String body) {
    final text = '${sender ?? ''} $body'.toLowerCase();
    final senderLower = (sender ?? '').toLowerCase();
    for (final bank in banks) {
      if (_matches(text, bank, senderLower)) return bank;
    }
    return null;
  }

  static bool _matches(String text, KnownBank bank, String senderLower) {
    final lowerCode = bank.code.toLowerCase();
    final lowerName = bank.name.toLowerCase();
    final lowerNameAr = bank.nameAr.toLowerCase();
    // Direct substring match over sender + body.
    if (text.contains(lowerCode) ||
        text.contains(lowerName) ||
        text.contains(lowerNameAr) ||
        bank.aliases.any((alias) => RegExp(r'^\d+$').hasMatch(alias)
            ? senderLower == alias
            : text.contains(alias.toLowerCase()))) {
      return true;
    }
    // Sender-only token match: catches senders like "FAISAL BANK" whose
    // name token is not an exact catalog substring. This is applied ONLY
    // to the sender field — never to the body — so arbitrary message words
    // (e.g. "bank" in "Other bank message") cannot create false positives.
    if (senderLower.isNotEmpty) {
      final tokens = senderLower
          .replaceAll(RegExp(r'[^a-z0-9\u0600-\u06FF]'), ' ')
          .trim()
          .split(RegExp(r'\s+'));
      for (final token in tokens) {
        if (token.length < 3) continue;
        // Skip generic English stop words unless the token matches the
        // bank code directly. Generic words like "bank", "of", "the" etc.
        // match against ALL banks that have those words in their English
        // name, defeating the purpose of bank-specific recognition.
        const stopWords = {
          'bank',
          'of',
          'the',
          'and',
          'international',
          'national',
          'commercial',
          'banking',
          'egypt',
        };
        if (stopWords.contains(token) &&
            token != lowerCode &&
            !token.contains(lowerCode) &&
            !lowerCode.contains(token)) {
          continue;
        }
        if (lowerName.contains(token) || token.contains(lowerCode)) {
          return true;
        }
      }
    }
    return false;
  }
}

/// Result of parsing a bank SMS.
class ParsedSms {
  /// Static bank id resolved from the remote catalog (null → Unknown bank).
  final String? bankId;
  final String? bankName;

  /// Straight transaction type; null when the parser cannot decide.
  final TransactionType? type;

  final int? amountMinor;
  final String currency;
  final String? merchant;
  final String? cardLast4;

  /// Transfer method/channel for received transfers — e.g. `IPN`, `تحويل`,
  /// `حوالة` — null for card purchases and other patterns.
  final String? transferMethod;

  /// Account identifier tail that appears as "رقم …" in the message. For IPN
  /// received transfers this is the account last 4 (e.g. `6101`); null
  /// otherwise.
  final String? accountLast4;

  /// Source/channel for mobile–internet banking messages — the text between
  /// "/" and "في حسابك" (e.g. `الموبايل والانترنت البنكي`). Null otherwise.
  final String? sourceChannel;
  final DateTime? transactionDate;

  /// Confidence in [0,1]. Values below 0.6 should be reviewed by the user.
  final double confidence;

  /// Deterministic fingerprint used for duplicate prevention.
  final String fingerprint;

  /// True when the user should review/classify the SMS manually.
  final bool needsReview;

  /// Sanitized prefix preview (never the full raw message).
  final String preview;

  const ParsedSms({
    this.bankId,
    this.bankName,
    this.type,
    this.amountMinor,
    this.currency = 'EGP',
    this.merchant,
    this.cardLast4,
    this.transferMethod,
    this.accountLast4,
    this.sourceChannel,
    this.transactionDate,
    required this.confidence,
    required this.fingerprint,
    required this.needsReview,
    required this.preview,
  });

  bool get hasBank => bankId != null;
}

/// Confidence-based SMS parser supporting Arabic and English patterns.
class SMSParser {
  SMSParser._();

  // ── Public API ─────────────────────────────────────────────────────────────

  /// Sender/domain pre-filter (requirement #2).
  ///
  /// The SMS sender/domain MUST be recognized as a bank or wallet sender
  /// before the message is even considered for parsing. This prevents random
  /// senders (telecom, delivery, ads, OTP, social media) from entering the
  /// financial pipeline at all.
  ///
  /// Uses the BankCatalog and remote bank data for recognition. A sender is
  /// recognized when it matches a known bank code, name, or Arabic name.
  static bool isSupportedSender(String? sender,
      {List<Bank> knownBanks = const [], String? body}) {
    return isRecognizedBankOrWalletSender(
        sender: sender, knownBanks: knownBanks, body: body);
  }

  /// Message-date gate (requirement: NO date cutoff).
  ///
  /// The previous implementation rejected every message older than
  /// **September 1, 2026** (`DateTime(2026, 9, 1)`). That hard cutoff has been
  /// removed completely: it silently discarded legitimate historical
  /// bank/wallet SMS and forced the whole pipeline to assume that only
  /// messages after that instant existed.
  ///
  /// The gate now only rejects a *missing* date (the parser must never guess
  /// when a message happened). Any real inbox timestamp — however old — is
  /// eligible, so the FIRST scan can ingest the complete available history of
  /// bank/wallet messages. Subsequent scans are limited by the persistent scan
  /// cursor plus the processed-SMS ledger, never by a date constant.
  static bool isWithinSupportedDate(DateTime? messageDate) {
    return messageDate != null;
  }

  /// Sender/domain recognition (requirement #3).
  ///
  /// Replaces the overly restrictive literal keyword filter
  /// (bank|بنك|wallet|walet) with a recognition check based on the
  /// BankCatalog and remote bank data.
  ///
  /// A sender is recognized when it matches a known bank code, name,
  /// or Arabic name from either the static catalog or the remote banks
  /// list. This allows senders like "FAISAL BANK", "CIB", "IPN",
  /// "Vodafone Cash", "InstaPay" etc. to be recognized even without
  /// the literal word "bank" or "wallet".
  ///
  /// Unrelated senders (telecom, delivery, ads, OTP, social media)
  /// are rejected BEFORE any financial parsing happens.
  static bool isRecognizedBankOrWalletSender({
    String? sender,
    List<Bank> knownBanks = const [],
    String? body,
  }) {
    if (sender == null || sender.trim().isEmpty) return false;
    final senderLower = sender.toLowerCase().trim();

    // 1. Check against remote bank catalog first (has real bank data).
    for (final bank in knownBanks) {
      if (_senderMatchesBank(senderLower, bank)) {
        return true;
      }
    }

    // 2. Fall back to static BankCatalog (works offline).
    final staticMatch = BankCatalog.match(sender, '');
    if (staticMatch != null) return true;

    // 2b. BODY-BASED BANK RECOGNITION (conservative): a message whose SENDER
    // is uninformative (a numeric short code, EM short sender, or a foreign
    // aggregator) but whose TEXT carries a full bank name is still a
    // legitimate bank SMS — e.g. real-world Bank of Alexandria messages whose
    // body contains "AlexBank"/"Bank of Alexandria"/"بنك الإسكندرية".
    //
    // Rules that keep the gate strong:
    //   * sender must look non-bank (no catalog hit above; numeric/short or
    //     unknown alphanumeric), never a rejected advertisement sender;
    //   * the body must contain the FULL bank name (or Arabic name) — never a
    //     bare short code, so a stray "alex"/"cib" substring in an ad can not
    //     open the gate.
    final probe = (body ?? '').trim();
    if (probe.isNotEmpty) {
      final senderLooksNonBank =
          RegExp(r'^[\d\s+\-()]*$').hasMatch(sender) || senderLower.length <= 5;
      if (senderLooksNonBank) {
        for (final bank in knownBanks) {
          if (_bodyCarriesBankName(probe, bank)) return true;
        }
        final staticBodyMatch = _bodyStaticBankName(probe);
        if (staticBodyMatch != null) return true;
      }
    }

    // 3. Check for well-known wallet/transfer identifiers that may not
    //    be in the bank catalog but are financial services.
    final financialSenderPatterns = [
      'instapay',
      'ipn',
      'vodafone cash',
      'vodafonecash',
      'vodafonec',
      'orange cash',
      'orangecash',
      'etisalat cash',
      'etisalatcash',
      'we pay',
      'wepay',
      'mobile wallet',
    ];
    for (final pattern in financialSenderPatterns) {
      if (senderLower.contains(pattern)) return true;
    }

    return false;
  }

  /// True when [body] carries the FULL bank name (English or Arabic) of
  /// [bank] — used only for the conservative body-based recognition path.
  /// Bare short codes are deliberately NOT matched here: a stray "alex" or
  /// "cib" inside an advertisement must never open the financial pipeline.
  static bool _bodyCarriesBankName(String body, Bank bank) {
    final text = body.toLowerCase();
    final name = bank.name.trim().toLowerCase();
    if (name.length >= 6 && text.contains(name)) return true;
    final nameAr = (bank.nameAr ?? '').trim().toLowerCase();
    if (nameAr.length >= 4 && text.contains(nameAr)) return true;
    return false;
  }

  /// Static-catalog variant of [_bodyCarriesBankName] (offline fallback).
  static String? _bodyStaticBankName(String body) {
    final text = body.toLowerCase();
    for (final bank in BankCatalog.banks) {
      final name = bank.name.toLowerCase();
      if (name.length >= 6 && text.contains(name)) return bank.name;
      final nameAr = bank.nameAr.toLowerCase();
      if (nameAr.length >= 4 && text.contains(nameAr)) return bank.name;
      if (bank.aliases.any((alias) =>
          !RegExp(r'^\d+$').hasMatch(alias) &&
          text.contains(alias.toLowerCase()))) {
        return bank.name;
      }
    }
    return null;
  }

  static bool _senderMatchesBank(String senderLower, Bank bank) {
    final code = (bank.code ?? '').toLowerCase();
    final name = bank.name.toLowerCase();
    final nameAr = (bank.nameAr ?? '').toLowerCase();

    // Direct code match (e.g., "CIB", "NBE", "FAISAL").
    if (code.isNotEmpty && senderLower.contains(code)) return true;
    // Bank name token in sender (e.g., "Faisal Bank" contains "faisal").
    if (name.isNotEmpty) {
      final tokens = senderLower
          .replaceAll(RegExp(r'[^a-z0-9]'), ' ')
          .trim()
          .split(RegExp(r'\s+'));
      for (final token in tokens) {
        if (token.length < 3) continue;
        if (name.contains(token) || token.contains(name)) return true;
      }
    }
    // Arabic name match.
    if (nameAr.isNotEmpty && senderLower.contains(nameAr)) return true;
    // Code contained in sender (e.g., sender "FAISALBANK" contains "faisal").
    if (code.isNotEmpty && code.length >= 3 && senderLower.contains(code)) {
      return true;
    }
    return false;
  }

  // ── Public API ─────────────────────────────────────────────────────────────

  /// Parse a bank SMS into a structured transaction.
  ///
  /// [knownBanks] are the remote bank records (with real ids); the static
  /// [BankCatalog] is used as a fallback.
  static Future<ParsedSms> parse({
    required String smsContent,
    String? sender,
    List<Bank> knownBanks = const [],
  }) async {
    final normalizedBody = _normalizeDigits(smsContent);
    final fingerprint = fingerprintOf(normalizedBody);

    final amount = extractAmount(normalizedBody);
    final currency = detectCurrency(normalizedBody);
    final bank = detectBank(
        sender: sender, body: normalizedBody, knownBanks: knownBanks);
    final classification = classify(normalizedBody);

    final type = classification.type;
    var confidence = 0.48;
    if (amount != null) confidence += 0.12;
    if (type != null) confidence += 0.24;
    if (classification.directionScore != 0) confidence += 0.08;
    if (bank != null) confidence += 0.1;
    confidence = confidence.clamp(0.0, 0.98);

    final needsReview = type == null || confidence < 0.60;
    final merchant = _extractMerchant(normalizedBody);
    final cardLast4 = _extractCardLast4(normalizedBody);
    final transferMethod = _extractTransferMethod(normalizedBody);
    final accountLast4 = _extractAccountLast4(normalizedBody);
    final sourceChannel = type == TransactionType.transfer_in
        ? _extractSourceChannel(normalizedBody)
        : null;

    return ParsedSms(
      bankId: bank?.id,
      bankName: bank?.name ?? _staticBankName(normalizedBody),
      type: type,
      amountMinor: amount,
      currency: currency,
      merchant: merchant,
      cardLast4: cardLast4,
      transferMethod: transferMethod,
      accountLast4: accountLast4,
      sourceChannel: sourceChannel,
      transactionDate: extractTransactionDate(normalizedBody),
      confidence: confidence,
      fingerprint: fingerprint,
      needsReview: needsReview,
      preview: _preview(smsContent),
    );
  }

  /// Deterministic fingerprint. Drops the "available balance" trailer so the
  /// same transaction keeps the same fingerprint regardless of balance drift.
  static String fingerprintOf(String smsContent) {
    final normalized = _normalizeDigits(smsContent)
        .toLowerCase()
        .replaceAll(
            RegExp(
                r'(?:available balance|balance|الرصيد المتاح|الرصيد)'
                r'\s*:?\s*(?:egp|ج\.م|le)?\s*[\d.,]+\s*(?:egp|ج\.م|le)?',
                caseSensitive: false),
            '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(RegExp(r'[^\w\s\u0600-\u06FF]'), '')
        .trim();
    return sha256.convert(utf8.encode(normalized)).toString();
  }

  // ── Bank detection ─────────────────────────────────────────────────────────

  /// Detect the bank from sender + SMS text.
  /// Returns null when the bank cannot be confidently identified
  /// (the caller then shows "Unknown" and lets the user assign it).
  static Bank? detectBank({
    String? sender,
    required String body,
    List<Bank> knownBanks = const [],
  }) {
    final text = '${sender ?? ''} $body'.toLowerCase();

    Bank? best;
    var bestScore = 0;
    for (final bank in knownBanks) {
      var score = 0;
      final code = (bank.code ?? '').toLowerCase();
      final name = bank.name.toLowerCase();
      final nameAr = (bank.nameAr ?? '').toLowerCase();
      if (code.isNotEmpty && text.contains(code)) score += 3;
      if (name.isNotEmpty && text.contains(name)) score += 2;
      if (nameAr.isNotEmpty && text.contains(nameAr)) score += 2;
      if (sender != null) {
        final senderClean =
            sender.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
        if (code.isNotEmpty && senderClean.contains(code)) score += 4;
        if (code.isNotEmpty && code.contains(senderClean)) score += 4;
      }
      if (score > bestScore) {
        bestScore = score;
        best = bank;
      }
    }

    if (bestScore >= 2) return best;

    // Static catalog fallback (returns a Bank with an empty id; the caller
    // resolves the real id or treats it as a manual-assignment case).
    final staticMatch = BankCatalog.match(sender, body);
    return staticMatch == null
        ? null
        : Bank(
            id: '',
            name: staticMatch.name,
            nameAr: staticMatch.nameAr,
            code: staticMatch.code);
  }

  /// Convenience method kept for compatibility.
  static bool matchesBankPattern(String sms, Bank bank) {
    final detected = detectBank(sender: null, body: sms, knownBanks: [bank]);
    return detected != null;
  }

  // ── Amount extraction ──────────────────────────────────────────────────────

  /// Extract the primary amount in minor units (piasters for EGP).
  /// Returns null when no currency-bound amount is found.
  ///
  /// Handles attached Arabic prefixes like "بمبلغ10.00 جم" by inserting a
  /// word break between Arabic letters and digits before matching, and
  /// integrates [extractWholeAmount] as a last-resort fallback for messages
  /// that quote an integer amount without any currency token.
  static int? extractAmount(String sms) {
    final s = _insertDigitBoundaries(_transactionText(sms));

    final patterns = [
      // Egyptian shorthand "جم" (jum = pounds) — e.g. "بمبلغ10.00 جم".
      // Must be checked BEFORE ج.م/جنيه/le so the bare جم branch wins.
      RegExp(r'([\d][\d.,]*)\s*جم(?![\w\u0600-\u06FF])', caseSensitive: false),
      RegExp(r'جم\s*([\d][\d.,]*)', caseSensitive: false),
      // "EGP 500.00" / "ج.م 500" / "LE 500" after currency symbol.
      RegExp(r'(?:egp|ج\.م|جنيه|le|e\s?£)\s*([\d][\d.,]*)',
          caseSensitive: false),
      // "500.00 EGP" / "500 ج.م" before currency symbol.
      RegExp(r'([\d][\d.,]*)\s*(?:egp|ج\.م|جنيه|le|e\s?£)',
          caseSensitive: false),
      // "amount: 500" / "المبلغ 500" / "بمبلغ 500" (attached or spaced).
      RegExp(r'(?:amount|المبلغ|بمبلغ|total|الإجمالي)\s*:?\s*([\d][\d.,]*)',
          caseSensitive: false),
      // Foreign-currency amounts: "$25.50" / "USD 100" / "25.50 EUR".
      RegExp(r'\$\s*([\d][\d.,]*)', caseSensitive: false),
      RegExp(r'€\s*([\d][\d.,]*)', caseSensitive: false),
      RegExp(r'£\s*([\d][\d.,]*)', caseSensitive: false),
      RegExp(r'(?:usd|eur|gbp|sar|aed|kwd|jod)\s*([\d][\d.,]*)',
          caseSensitive: false),
      RegExp(r'([\d][\d.,]*)\s*(?:usd|eur|gbp|sar|aed|kwd|jod)',
          caseSensitive: false),
    ];

    for (final pattern in patterns) {
      for (final match in pattern.allMatches(s)) {
        final value = _parseNumber(match.group(1));
        if (value != null) {
          final cleaned = match.group(1)!.replaceAll(',', '');
          final parts = cleaned.split('.');
          final majorDigits = _stripLeadingZeros(parts[0]);
          final hasDecimal = parts.length == 2 && parts[1].isNotEmpty;
          final major = int.tryParse(majorDigits) ?? 0;
          final decimals = hasDecimal ? '${parts[1]}00'.substring(0, 2) : '00';
          final minor = double.tryParse('$major.$decimals');
          // A currency-BOUND amount is trusted even when it is exactly zero:
          // "تم خصم USD 0.00" is a real, fully-parsed authorisation hold, and
          // rejecting it as "no amount" threw the message into needs_review and
          // dropped the card Last 4 and currency it had already detected.
          // `null` still means "not an amount at all" and keeps the >0 rule.
          if (minor != null && (minor > 0 || _isBoundZero(cleaned, parts))) {
            return (minor * 100).round();
          }
        }
      }
    }
    // Fallback for plain integer amounts with no currency token.
    return extractWholeAmount(sms);
  }

  /// True when [parts] describes a literal `0`, `0.0`, `0.00`, `00` … token that
  /// the calling pattern already bound to a currency/label, as opposed to an
  /// arbitrary number the pattern happened to capture.
  static bool _isBoundZero(String cleaned, List<String> parts) {
    if (parts.length > 2) return false;
    if (parts.length == 2 && parts[1].isNotEmpty) {
      // Only an all-zero fraction (0.00 / 0.0) is a bound zero. Anything else
      // (0.50) is already > 0 and must be unaffected by this rule.
      if (parts[1].replaceAll('0', '').isNotEmpty) return false;
    }
    // Every DIGIT of the captured token is a zero; separators like `.` are
    // ignored so "0.00" is recognised as a bound zero and "0.50" is not.
    final digits = cleaned.replaceAll(RegExp(r'[^0-9]'), '');
    return digits.isNotEmpty && digits.replaceAll('0', '').isEmpty;
  }

  /// Whole-EGP fallback for messages that quote an integer amount.
  static int? extractWholeAmount(String sms) {
    final s = _transactionText(sms);
    final match = RegExp(
            r'(?:amount|بمبلغ|مبلغ|بقيمة|خصم|إضافة|اضافة)\s*:?\s*(\d+(?:[.,]\d+)*)',
            caseSensitive: false)
        .firstMatch(s);
    if (match == null) return null;
    final value = _parseNumber(match.group(1));
    if (value == null || value <= 0) return null;
    return (value * 100).round();
  }

  /// Detect the transaction currency from the SMS text.
  ///
  /// Scans for explicit currency codes/symbols first (EGP, USD, EUR, GBP,
  /// SAR, AED, KWD, JOD, LE, ج.م, $, €, £). Falls back to a bank-specific
  /// heuristic: Gulf banks (ENBD, FAB, ADIB) typically transact in AED,
  /// otherwise defaults to EGP.
  static String detectCurrency(String sms) {
    final s = _transactionText(sms).toLowerCase();

    // Explicit currency code/symbol. Order matters — check longer/more
    // specific tokens before shorter ones.
    if (_currMatch(s, ['usd'])) return 'USD';
    if (_currMatch(s, ['eur'])) return 'EUR';
    if (_currMatch(s, ['gbp'])) return 'GBP';
    if (_currMatch(s, ['kwd'])) return 'KWD';
    if (_currMatch(s, ['jod'])) return 'JOD';
    if (_currMatch(s, ['sar'])) return 'SAR';
    if (_currMatch(s, ['aed'])) return 'AED';
    if (_currMatch(s, ['egp', 'ج.م', 'جنيه', 'جم', 'le', '£', r'e\s?£'])) {
      return 'EGP';
    }
    if (s.contains(r'$')) return 'USD';
    if (s.contains('€')) return 'EUR';

    return 'EGP';
  }

  static bool _currMatch(String text, List<String> tokens) {
    for (final token in tokens) {
      if (text.contains(token)) return true;
    }
    return false;
  }

  // ── Classification ─────────────────────────────────────────────────────────

  static ClassificationResult classify(String sms) {
    final s = _normalizeDigits(sms).toLowerCase();

    // Notifications about failed attempts and OTPs never move money.
    if (RegExp(
            r'\botp\b|one[ -]time|verification code|رمز التحقق|كود التحقق|لم تتم|غير ناجح|مرفوض|\bdeclined\b|\bfailed\b|\bunsuccessful\b',
            caseSensitive: false)
        .hasMatch(s)) {
      return const ClassificationResult(null, 0);
    }

    // The IPN received-transfer pattern uses "الى" (bare alif) in the wild;
    // normalize it to "إلى" so every downstream "to your account" check also
    // matches the hamza-less variant (same goes for "الى" → "إلى").
    var d = _detectDirection(_normalizeHamza(s));

    // ── Pattern guards (extensions) — MUST run before the generic keyword
    // scoring so the new card-purchase / mobile-banking / IPN-received
    // formats never fall through to the wrong bucket. ──────────────────────

    // Mobile / internet-banking amount ADDED TO the user's account
    // ("تم اضافة/إضافة مبلغ … جم / الموبايل والانترنت البنكي في حسابك") —
    // money IN → transfer_in → My Balance. Checked BEFORE the deduction
    // guard; the two share the channel token but the direction comes from
    // "اضافة … في حسابك" (in) vs "خصم … من حسابك" (out) and can never both
    // match the same message.
    if (_isMobileBankingIncoming(s)) {
      return const ClassificationResult(TransactionType.transfer_in, 1);
    }

    // Pattern 2: mobile / internet-banking deduction ("خصم مبلغ … الموبايل
    // والانترنت البنكي من حسابك") — money OUT → purchase → Deducted.
    if (_isMobileBankingDeduction(s)) {
      return const ClassificationResult(TransactionType.purchase, -1);
    }

    // Pattern 1: card purchase ("تمت عملية بمبلغ… EGP ببطاقة… عند Merchant")
    // — money OUT → purchase → Deducted.
    if (_isCardPurchasePattern(s)) {
      return const ClassificationResult(TransactionType.purchase, -1);
    }

    // Pattern 3: IPN received transfer ("تم إضافة تحويل IPN إلى/الى حسابكم
    // رقم … بمبلغ …") — money IN → transfer_in → My Balance.
    if (_isIpnReceivedTransfer(s)) {
      return const ClassificationResult(TransactionType.transfer_in, 1);
    }

    // ── Existing generic scoring (unchanged) ────────────────────────────────
    var atmScore = 0;
    for (final k in _atmKeywords) {
      if (s.contains(k)) atmScore++;
    }
    var purchaseScore = 0;
    for (final k in _purchaseKeywords) {
      if (s.contains(k)) purchaseScore++;
    }
    var instaPayScore = 0;
    for (final k in _instaPayKeywords) {
      if (s.contains(k)) instaPayScore++;
    }
    var walletScore = 0;
    for (final k in _walletKeywords) {
      if (s.contains(k)) walletScore++;
    }
    var transferScore = 0;
    for (final k in _transferKeywords) {
      if (s.contains(k)) transferScore++;
    }
    var incomeScore = 0;
    for (final k in _incomeKeywords) {
      if (s.contains(k)) incomeScore++;
    }
    var refundScore = 0;
    for (final k in _refundKeywords) {
      if (s.contains(k)) refundScore++;
    }
    var depositScore = 0;
    for (final k in _depositKeywords) {
      if (s.contains(k)) depositScore++;
    }

    final direction = d;

    // An ATM can accept deposits as well as dispense cash.
    if (depositScore >= 1 &&
        !RegExp(r'withdraw|سحب', caseSensitive: false).hasMatch(s)) {
      return const ClassificationResult(TransactionType.income, 1);
    }
    // ATM takes priority — strongly identifiable.
    if (atmScore >= 1) {
      return ClassificationResult(TransactionType.atm_withdrawal, direction);
    }

    // Refunds are credit-backs.
    if (refundScore >= 1) {
      return ClassificationResult(TransactionType.refund, direction);
    }

    // Wallet & InstaPay & transfers are money movements.
    final isMoneyMovement =
        instaPayScore > 0 || walletScore > 0 || transferScore > 0;
    if (isMoneyMovement) {
      if (direction > 0) {
        return ClassificationResult(TransactionType.transfer_in, direction);
      }
      if (direction < 0) {
        return ClassificationResult(TransactionType.transfer_out, direction);
      }
      // A provider name alone cannot prove which way money moved.
      return ClassificationResult(null, direction);
    }

    // Deposit (requirement #2) — money coming in. Maps to income.
    if (depositScore >= 1) {
      return const ClassificationResult(TransactionType.income, 1);
    }

    // Salary / income.
    if (incomeScore >= 1) {
      return const ClassificationResult(TransactionType.income, 1);
    }

    // Purchases / POS debits.
    if (purchaseScore >= 1) {
      return const ClassificationResult(TransactionType.purchase, -1);
    }

    if (RegExp(r'تم\s*(?:إضافة|اضافة|إضافه|اضافه)|added to|credited to',
            caseSensitive: false)
        .hasMatch(s)) {
      return const ClassificationResult(TransactionType.income, 1);
    }
    if (s.contains('خصم')) {
      return const ClassificationResult(TransactionType.purchase, -1);
    }

    return ClassificationResult(null, direction);
  }

  static int _detectDirection(String lowerSms) {
    var incomingScore = 0;
    for (final k in _incomingKeywords) {
      if (lowerSms.contains(k)) incomingScore++;
    }
    var outgoingScore = 0;
    for (final k in _outgoingKeywords) {
      if (lowerSms.contains(k)) outgoingScore++;
    }

    // Context-aware tie-break for the ambiguous "تحويل" (transfer) keyword.
    // Arabic word order places the amount between verb and recipient:
    //   "تم تحويل [المبلغ] إلى [الشخص/الحساب]" — so we cannot rely on
    //   contiguous substrings. Semantics:
    //   - "تحويل إلى حسابكم" (TO YOUR account)            → INCOMING
    //   - "تحويل من حسابكم" (FROM your account)           → OUTGOING
    //   - "تحويل [المبلغ] إلى [شخص آخر]" (to a third party) → OUTGOING
    final hasTransfer = lowerSms.contains('تحويل');

    // TO the user's own account → money IN.
    if (hasTransfer &&
        (lowerSms.contains('إلى حسابكم') ||
            lowerSms.contains('إلى حسابك') ||
            lowerSms.contains('لحسابكم'))) {
      incomingScore += 2;
    }

    // FROM the user's own account → money OUT.
    if (hasTransfer &&
        (lowerSms.contains('من حسابكم') || lowerSms.contains('من حسابك'))) {
      outgoingScore += 2;
    }

    // "تم تحويل [amount] إلى [someone]" — recipient is NOT the user's
    // account → money OUT. The "إلى" appears AFTER the amount, hence the
    // plain contains() check (account-targeted case already handled above).
    if (hasTransfer &&
        lowerSms.contains('إلى') &&
        !lowerSms.contains('حسابكم') &&
        !lowerSms.contains('حسابك')) {
      outgoingScore += 2;
    }

    // Short form "تحويل لـ[someone]" → money OUT. Excludes the false
    // positive "تحويل لحظي" (INSTANT transfer — an InstaPay incoming
    // marker), because `لحظي` (instant) starts with the letter ل.
    if (hasTransfer &&
        RegExp(r'تحويل ل(?!حظي)').hasMatch(lowerSms) &&
        !lowerSms.contains('حسابكم') &&
        !lowerSms.contains('حسابك')) {
      outgoingScore += 2;
    }

    if (incomingScore > outgoingScore) return 1;
    if (outgoingScore > incomingScore) return -1;
    return 0;
  }

  // ── New-pattern guards (extensions, never rewrite existing rules) ──────────

  /// Normalize the hamza-less "الى" to "إلى" so Arabic-direction checks treat
  /// "الى حسابكم" exactly like "إلى حسابكم". The IPN received-transfer pattern
  /// is commonly written with the bare-alif form.
  static String _normalizeHamza(String s) => s.replaceAll('الى', 'إلى');

  /// Pattern 1 — card purchase:
  ///   "تمت عملية بمبلغ1200.00 EGPببطاقة6202** في12/09/26-15:40 عند MERCHANT"
  /// Distinguishing marks: a card token ("بطاقة") AND a merchant marker
  /// ("عند"). Amount/card/merchant are extracted by the existing extractors.
  static bool _isCardPurchasePattern(String s) =>
      s.contains('بطاقة') && s.contains('عند');

  /// Mobile / internet-banking amount ADDED TO the user's account:
  ///   "تم اضافة/إضافة مبلغ 200.00 جم / الموبايل والانترنت البنكي في حسابك , يوم …"
  /// The complete semantic structure is money IN ("في حسابك" = into your
  /// account) and is checked BOTH – specifically so a message like the
  /// deduction twin ("… من حسابك") can never match. Only messages that add
  /// an amount into the user's account match; a lone "المبلغ" or channel
  /// token never does.
  static bool _isMobileBankingIncoming(String s) {
    final m = RegExp(
      r'تم\s*[إا]ضافة\s*مبلغ[^/]*جم\s*/\s*الموبايل\s*و?\s*الانترنت\s*البنكي\s*في\s*حسابك',
      caseSensitive: false,
    );
    return m.hasMatch(s.replaceAll(RegExp(r'\s+'), ' ').trim());
  }

  /// Pattern 2 — mobile / internet-banking channel deduction:
  ///   "تم خصم مبلغ 1614.14 جم / الموبايل والانترنت البنكي من حسابك , يوم …"
  /// Requires BOTH the deduction signal and the mobile-banking channel so a
  /// plain "خصم" anywhere never retriggers.
  static bool _isMobileBankingDeduction(String s) {
    final hasDeduction = s.contains('خصم');
    final hasChannel = s.contains('الموبايل') ||
        s.contains('الانترنت البنكي') ||
        s.contains('المحمول والانترنت');
    return hasDeduction && hasChannel;
  }

  /// Pattern 3 — IPN received transfer:
  ///   "تم إضافة تحويل IPN إلى/الى حسابكم رقم {ACCOUNT} بمبلغ {AMOUNT}"
  /// The transfer is being ADDED TO the user's account → money IN.
  /// `الى` vs `إلى` handled by [_normalizeHamza]. Whitespace between words is
  /// collapsed so "رقم 6101" / "رقم6101" / "بمبلغ 240" / "بمبلغ240" all match.
  static bool _isIpnReceivedTransfer(String s) {
    final t =
        RegExp(r'\s+').hasMatch(s) ? s.replaceAll(RegExp(r'\s+'), ' ') : s;
    return RegExp(
      r'تم\s+إضافة\s+تحويل\s+ipn'
      r'\s*(?:إلى|الي)?\s*حسابكم\s*رقم[^\d]{0,3}\d{1,16}',
      caseSensitive: false,
    ).hasMatch(t);
  }

  /// Extract the transfer method/channel word for a received-transfer SMS.
  /// For the IPN message this yields `IPN`; falls back to the generic
  /// "تحويل"/"حوالة" tokens when no explicit channel name is present.
  static String? _extractTransferMethod(String s) {
    final t = _normalizeHamza(s);
    final direct = RegExp(r'تحويل\s+(ipn|انستا باي|انستاباي|لحظي|فوري)',
            caseSensitive: false)
        .firstMatch(t);
    if (direct != null) return direct.group(1);
    for (final method in ['IPN', 'تحويل', 'حوالة']) {
      if (t.contains(method)) return method;
    }
    return null;
  }

  /// Extract the source/channel between "/" and "في حسابك" for mobile–internet
  /// banking messages (e.g. `الموبايل والانترنت البنكي`). Trimmed and cleaned
  /// of surrounding punctuation; no date/time or marker words included.
  static String? _extractSourceChannel(String s) {
    final t = s.replaceAll(RegExp(r'\s+'), ' ');
    final m = RegExp(r'/\s*(.+?)\s*في\s*حسابك').firstMatch(t);
    if (m == null) return null;
    final raw = m.group(1)!.trim();
    if (raw.isEmpty) return null;
    // Drop any trailing punctuation (",", ".", "،", "؛") left before "في".
    final cleaned = raw.replaceFirst(RegExp(r'[\s,.,،؛]+$'), '').trim();
    return cleaned.isEmpty ? null : cleaned;
  }

  /// Extract the account tail that appears after "رقم" (e.g. `6101`). Returns
  /// the last 4 digits of the identified number — never a fabricated value.
  static String? _extractAccountLast4(String s) {
    final t = _normalizeHamza(s);
    final m = RegExp(
            r'(?:حسابك(?:م)?\s*(?:رقم)?|account\s*(?:number|no\.?|ending(?: in)?)?)\s*[:#]?\s*(\d{4,16})(?!\d)',
            caseSensitive: false)
        .firstMatch(t);
    if (m == null) return null;
    final digits = m.group(1)!.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return null;
    return digits.length <= 4 ? digits : digits.substring(digits.length - 4);
  }

  // ── Keyword tables (Arabic + English) ──────────────────────────────────────

  static const _atmKeywords = [
    'atm',
    'cash withdrawal',
    'withdrawal',
    'withdrawn',
    'cash machine',
    'cash out',
    'سحب',
    'ماكينة',
    'صراف',
    'سحبت',
  ];

  static const _purchaseKeywords = [
    'purchase',
    'pos',
    'debit',
    'merchant',
    'paid at',
    'shop',
    'charge',
    'online purchase',
    'online payment',
    'ecommerce',
    'e-commerce',
    'internet purchase',
    'internet payment',
    'web purchase',
    'shop purchase',
    'شراء',
    'مشتريات',
    'عمليات شراء',
    'شراء اونلاين',
    'شراء عبر الإنترنت',
    'عملية شراء إلكترونية',
    'استهلاك',
  ];

  static const _depositKeywords = [
    'deposit',
    'cash deposit',
    'deposited',
    'إيداع',
    'تم إيداع',
    'وديعة',
  ];

  static const _instaPayKeywords = [
    'instapay',
    'ipn',
    'instant transfer',
    'insta pay',
    'انستا باي',
    'تحويل لحظي',
    'انستاباي',
    'فوري',
  ];

  static const _walletKeywords = [
    'wallet',
    'vodafone cash',
    'orange cash',
    'etisalat cash',
    'we pay',
    'mobile wallet',
    'محفظة',
    'فودافون كاش',
    'اورنج كاش',
    'اتصالات كاش',
    'وي باي',
  ];

  static const _transferKeywords = [
    'transfer',
    'transferred',
    'transferring',
    'sent money',
    'hawaala',
    'تحويل',
    'حوالة',
    'تم تحويل',
    'مبالغ محولة',
  ];

  static const _incomingKeywords = [
    'credited',
    'received',
    'receive',
    'money received',
    'transfer from',
    'incoming',
    'deposited',
    'you got',
    'in favour',
    'استقبل',
    'استلمت',
    'تم استلام',
    'تم إضافة',
    'تم اضافة',
    'استلام',
    'وارد',
    'دائن',
    'وديعة',
    'تم الاستلام',
    'حوالة واردة',
    'دخل حسابكم',
    'دخول',
    'وارد حسابكم',
    'استلام تحويل',
    'وصل',
  ];

  static const _outgoingKeywords = [
    'debited',
    'sent',
    'transfer to',
    'transfer out',
    'paid out',
    'purchase of',
    'تم تحويل من',
    'تم التحويل من',
    'تحويل إلى',
    'خصم',
    'صادر',
    'مدين',
    'أرسلت',
    'ارسلت',
    'قمت بتحويل',
    'حوالة صادرة',
    'من حسابكم',
    'خصم من',
    'سحب من',
  ];

  static const _incomeKeywords = [
    'salary',
    'wage',
    'payroll',
    'bonus',
    'راتب',
    'مرتب',
    'اجر',
    'مكافأة',
  ];

  static const _refundKeywords = [
    'refund',
    'returned',
    'cash back',
    'reversal',
    'استرداد',
    'ارجاع',
    'مرتجع',
    'استرجاع',
  ];

  // ── Helpers ────────────────────────────────────────────────────────────────

  /// The balance is a separate quantity, never the transaction amount.
  static String _transactionText(String sms) => _normalizeDigits(sms)
      .split(
        RegExp(
            r'رصيدك|الرصيد|المتاح\s*(?:الان|الآن)|available\s*(?:balance|credit)|\bbalance\b',
            caseSensitive: false),
      )
      .first;

  /// A bank account token is distinct from a card number. Preserve masks:
  /// `0000*****000` exposes three trailing digits, never invent a fourth.
  static String? accountToken(String sms) {
    final s = _normalizeDigits(sms).replaceAll(RegExp(r'\s+'), ' ');
    final match = RegExp(
            r'(?:حسابك(?:م)?\s*(?:رقم)?|(?:من|إلى|الى)\s+ح\s*|account\s*(?:number|no\.?|ending(?: in)?)?)\s*[:#]?\s*([\d*Xx]{4,24})(?!\d)',
            caseSensitive: false)
        .firstMatch(s);
    return match?.group(1)?.toUpperCase();
  }

  static DateTime? extractTransactionDate(String sms) {
    final s = _normalizeDigits(sms);
    final match = RegExp(
            r'(\d{1,2})[/\.](\d{1,2})[/\.](\d{2,4})\s*(?:-|في|فى|الساعة)?\s*(\d{1,2}):(\d{2})(?::(\d{2}))?\s*(AM|PM)?',
            caseSensitive: false)
        .firstMatch(s);
    if (match == null) return null;
    var day = int.parse(match[1]!);
    var month = int.parse(match[2]!);
    // Egyptian day/month unless impossible, as in the bank's 10/13/26.
    if (month > 12 && day <= 12) {
      final swap = day;
      day = month;
      month = swap;
    }
    var year = int.parse(match[3]!);
    if (year < 100) year += 2000;
    var hour = int.parse(match[4]!);
    final minute = int.parse(match[5]!);
    final second = int.parse(match[6] ?? '0');
    final period = match[7]?.toUpperCase();
    if (period != null) {
      if (hour < 1 || hour > 12) return null;
      hour = hour % 12 + (period == 'PM' ? 12 : 0);
    }
    if (hour > 23 || minute > 59 || second > 59) return null;
    final result = DateTime(year, month, day, hour, minute, second);
    return result.year == year && result.month == month && result.day == day
        ? result
        : null;
  }

  /// Insert a space between Arabic-script letters and ASCII digits so
  /// attached forms like "بمبلغ10.00" tokenize as "بمبلغ 10.00".
  static String _insertDigitBoundaries(String input) {
    var out = input.replaceAllMapped(
        RegExp(r'([\u0600-\u06FF])(?=\d)'), (m) => '${m.group(1)} ');
    out = out.replaceAllMapped(
        RegExp(r'(\d)(?=[\u0600-\u06FF])'), (m) => '${m.group(1)} ');
    return out;
  }

  static double? _parseNumber(String? raw) {
    if (raw == null) return null;
    final trimmed = raw.replaceAll(' ', '').replaceAll(',', '');
    return double.tryParse(trimmed);
  }

  static String _normalizeDigits(String input) {
    const arabicIndic = {
      '٠': '0',
      '١': '1',
      '٢': '2',
      '٣': '3',
      '٤': '4',
      '٥': '5',
      '٦': '6',
      '٧': '7',
      '٨': '8',
      '٩': '9',
    };
    final sb = StringBuffer();
    for (final rune in input.runes) {
      final c = String.fromCharCode(rune);
      sb.write(arabicIndic[c] ?? c);
    }
    return sb.toString();
  }

  static String _stripLeadingZeros(String value) {
    final stripped = value.replaceFirst(RegExp(r'^0+'), '');
    return stripped.isEmpty ? '0' : stripped;
  }

  static String? _extractCardLast4(String s) {
    // Egyptian bank SMS expose the card's LAST FOUR digits in EITHER mask
    // layout, and both are genuine last-four values:
    //
    //     **6303   /   ****1234   /   XX4321        (mask leads the digits)
    //     بطاقة6202**   /   بطاقة 6202**            (digits lead the mask)
    //
    // The trailing `**` is a formatting/alignment artifact of how this bank
    // renders the card, NOT a statement that the visible digits are the card's
    // first four. There is no rule in this format that makes `NNNN**` a prefix.
    // Both layouts therefore yield the same thing: the card's last four.
    //
    // The real protection against misreading a number is the CARD LABEL: only a
    // four-digit run that a `بطاقة` / `card` label introduces is taken, and the
    // account/reference/OTP negative lookaheads below keep those out. A long
    // card number such as `4111111111111111` is additionally excluded by the
    // `(?!\d)` lookahead, which refuses to match inside a longer digit run.
    final maskPatterns = [
      RegExp(r'(?<!\d)\*{2,}\s*(\d{4})(?!\d)'),
      RegExp(r'(?<![A-Z0-9])[X]{2,}\s*(\d{4})(?!\d)', caseSensitive: false),
    ];
    for (final pattern in maskPatterns) {
      final match = pattern.firstMatch(s);
      // A leading mask means the digits the bank chose to reveal, which is
      // exactly a last 4.
      if (match != null) return match.group(1);
    }

    // Label-led forms are safe to accept only when the text between the card
    // label and the four digits cannot be an account/reference/OTP label.
    final labeledPatterns = [
      RegExp(
          r'card\s*(?:(?:ending(?:\s+in)?|number|no\.?|#)\s*)?'
          r'[:\-]?\s*(\d{4})(?!\d)',
          caseSensitive: false),
      RegExp(r'card\s+(?:reference|ref\.?)\s*[:\-]?\s*(\d{4})(?!\d)',
          caseSensitive: false),
      RegExp(r'(?:رقم\s+)?(?:بطاقة|بطاقه)\s*'
          r'(?:(?:رقم(?!\s*مرجعي)|تنتهي\s*(?:بـ|ب|في)?)\s*)?'
          r'[:\-]?\s*(\d{4})(?!\d)'),
      RegExp(r'(?:رقم\s+)?(?:بطاقة|بطاقه)'
          r'(?![^\d\n]{0,24}(?:رقم\s*مرجعي|رقم\s*المرجع|مرجع|حساب|'
          r'رقم\s*(?:العملية|عملية)|otp|كود))'
          r'[^\d\n]{0,24}?(\d{4})(?!\d)'),
    ];
    for (final pattern in labeledPatterns) {
      final match = pattern.firstMatch(s);
      if (match == null) continue;
      // A trailing mask after the digits (`بطاقة6202**`) is a formatting
      // artifact of this bank's card rendering, NOT a statement that these are
      // the card's first four. The digits a `بطاقة` label introduces ARE the
      // card's last four in both mask layouts, so the value is returned either
      // way and the maximum reliable information is preserved.
      return match.group(1);
    }
    return null;
  }

  static String? _extractMerchant(String s) {
    final patterns = [
      RegExp(
          r"(?:debit\s+at|paid at|at|from|merchant)\s+"
          r"([a-z0-9&.\- ]{2,40})",
          caseSensitive: false),
      RegExp(
          r"purchase\s+of\s+[\d.,]+\s*(?:egp|ج\.م)?\s+(?:at|from)\s+"
          r"([a-z0-9&.\- ]{2,40})",
          caseSensitive: false),
      RegExp(r'(?:عند|من|في|متجر|محل)\s+([^\d]{2,40})'),
      RegExp(r"goods\s*:\s*([a-z0-9&.\- ]{2,40})", caseSensitive: false),
    ];
    for (final pattern in patterns) {
      final match = pattern.firstMatch(s);
      if (match != null) {
        final merchant = match.group(1)?.trim();
        if (merchant != null && merchant.isNotEmpty && merchant.length >= 2) {
          // Skip account/reference labels that should not be merchants.
          final lowerMerchant = merchant.toLowerCase();
          if (RegExp(
                  r'(?:حساب|account|رقم|reference|ref|رقم\s+مرجعي|رقم\s+الحساب)'
                  r'|^[a-z0-9]{1,3}$')
              .hasMatch(lowerMerchant)) {
            continue;
          }
          final cleaned = merchant
              .split(
                  RegExp(r'\s+(?:on|with|using|egp|ج\.م|amount|\d|ref|مرجع)\b'))
              .first
              .trim();
          if (cleaned.isNotEmpty && cleaned.length < 60) return cleaned;
        }
      }
    }
    return null;
  }

  static String? _staticBankName(String body) {
    final staticMatch = BankCatalog.match(null, body);
    return staticMatch?.name;
  }

  static String _preview(String smsContent) {
    final compact = smsContent.replaceAll(RegExp(r'\s+'), ' ').trim();
    return compact.length <= 120 ? compact : compact.substring(0, 120);
  }
}

class ClassificationResult {
  final TransactionType? type;
  final int directionScore; // -1 outgoing, +1 incoming, 0 unknown
  const ClassificationResult(this.type, this.directionScore);
}

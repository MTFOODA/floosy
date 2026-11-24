/// Offline bank identities. Database UUIDs are deliberately kept out of this
/// directory: only the server can assign a bank's foreign key.
class KnownBank {
  final String code;
  final String name;
  final String nameAr;
  final String domain;
  final List<String> aliases;
  final bool isWallet;
  const KnownBank({
    required this.code,
    required this.name,
    required this.nameAr,
    required this.domain,
    this.aliases = const [],
    this.isWallet = false,
  });
  String get logoAsset => 'assets/banks/${code.toLowerCase()}.png';
}

class BankCatalog {
  static const banks = <KnownBank>[
    KnownBank(
      code: 'CIB',
      name: 'Commercial International Bank',
      nameAr: 'البنك التجاري الدولي',
      domain: 'cibeg.com',
      aliases: ['Commercial International Bank (CIB)'],
    ),
    KnownBank(
      code: 'NBE',
      name: 'National Bank of Egypt',
      nameAr: 'البنك الأهلي المصري',
      domain: 'nbe.com.eg',
      aliases: ['البنك الاهلي المصري', 'Al Ahly Bank'],
    ),
    KnownBank(
      code: 'MISR',
      name: 'Banque Misr',
      nameAr: 'بنك مصر',
      domain: 'banquemisr.com',
      aliases: ['BM', 'Bank Misr'],
    ),
    KnownBank(
      code: 'QNB',
      name: 'QNB Egypt',
      nameAr: 'بنك قطر الوطني مصر',
      domain: 'qnb.com.eg',
      aliases: ['QNB Alahli', 'QNB Al Ahli', 'QNB ALAHLI Bank', 'كيو ان بي'],
    ),
    KnownBank(
      code: 'ALEX',
      name: 'ALEXBANK',
      nameAr: 'بنك الإسكندرية',
      domain: 'alexbank.com',
      aliases: [
        'ALEX2',
        'Bank of Alexandria',
        'Alex Bank',
        'AB Magnifica',
        'AB Private',
        '4988',
        'بنك الاسكندرية',
      ],
    ),
    KnownBank(
      code: 'HSBC',
      name: 'HSBC Egypt',
      nameAr: 'بنك HSBC مصر',
      domain: 'hsbc.com.eg',
    ),
    KnownBank(
      code: 'ADIB',
      name: 'Abu Dhabi Islamic Bank',
      nameAr: 'مصرف أبوظبي الإسلامي',
      domain: 'adib.eg',
      aliases: ['ADIB Egypt', 'مصرف ابو ظبي الاسلامي'],
    ),
    KnownBank(
      code: 'ENBD',
      name: 'Emirates NBD',
      nameAr: 'بنك الإمارات دبي الوطني',
      domain: 'emiratesnbd.com.eg',
      aliases: ['EmiratesNBD', 'بنك الامارات دبي الوطني'],
    ),
    KnownBank(
      code: 'FAB',
      name: 'FAB Egypt',
      nameAr: 'البنك الأول بأبو ظبي',
      domain: 'fabmisr.com.eg',
      aliases: [
        'FABMISR',
        'FAB Misr',
        'First Abu Dhabi Bank',
        'Bank Audi',
        'بنك أبوظبي الأول مصر',
      ],
    ),
    KnownBank(
      code: 'AAIB',
      name: 'Arab African International Bank',
      nameAr: 'البنك العربي الأفريقي الدولي',
      domain: 'aaib.com',
      aliases: ['العربي الأفريقي الدولي', 'العربي الافريقي الدولي'],
    ),
    KnownBank(
      code: 'FAISAL',
      name: 'Faisal Islamic Bank of Egypt',
      nameAr: 'بنك فيصل الإسلامي المصري',
      domain: 'faisalbank.com.eg',
      aliases: [
        'Faisal Bank',
        'بنك فيصل',
        'Faisal Islamic Bank of Egypt',
        'FIBE',
        'بنك فيصل الإسلامي المصري',
      ],
    ),
    KnownBank(
      code: 'BDC',
      name: 'Banque du Caire',
      nameAr: 'بنك القاهرة',
      domain: 'bdc.com.eg',
      aliases: ['Bank du Caire'],
    ),
    KnownBank(
      code: 'CAE',
      name: 'Credit Agricole Egypt',
      nameAr: 'كريدي أجريكول مصر',
      domain: 'ca-egypt.com',
      aliases: ['Credit Agricole', 'Crédit Agricole', 'CA Egypt'],
    ),
    KnownBank(
      code: 'ADCB',
      name: 'Abu Dhabi Commercial Bank',
      nameAr: 'بنك أبوظبي التجاري',
      domain: 'adcb.com.eg',
      aliases: ['ADCB Egypt', 'Union National Bank Egypt'],
    ),
    KnownBank(
      code: 'ABK',
      name: 'Al Ahli Bank of Kuwait Egypt',
      nameAr: 'البنك الأهلي الكويتي مصر',
      domain: 'abkegypt.com',
      aliases: ['ABK Egypt', 'Al Ahli Bank of Kuwait', 'Piraeus Bank Egypt'],
    ),
    KnownBank(
      code: 'NBK',
      name: 'National Bank of Kuwait Egypt',
      nameAr: 'بنك الكويت الوطني مصر',
      domain: 'nbk.com',
      aliases: ['NBK Egypt', 'National Bank of Kuwait'],
    ),
    KnownBank(
      code: 'KFH',
      name: 'Kuwait Finance House Egypt',
      nameAr: 'بيت التمويل الكويتي مصر',
      domain: 'eg.kfh.com',
      aliases: [
        'KFH Egypt',
        'Kuwait Finance House',
        'Ahli United Bank',
        'AUB',
        'البنك الأهلي المتحد',
      ],
    ),
    KnownBank(
      code: 'EGBANK',
      name: 'EG Bank',
      nameAr: 'البنك المصري الخليجي',
      domain: 'eg-bank.com',
      aliases: ['Egyptian Gulf Bank', 'EG Bank Egypt'],
    ),
    KnownBank(
      code: 'EBANK',
      name: 'Export Development Bank of Egypt',
      nameAr: 'البنك المصري لتنمية الصادرات',
      domain: 'ebank.com.eg',
      aliases: ['EBE', 'Egyptian Export Development Bank'],
    ),
    KnownBank(
      code: 'HDB',
      name: 'Housing and Development Bank',
      nameAr: 'بنك التعمير والإسكان',
      domain: 'hdb-egy.com',
      aliases: ['HD Bank', 'بنك التعمير والاسكان'],
    ),
    KnownBank(
      code: 'SAIB',
      name: 'SAIB Bank',
      nameAr: 'بنك saib',
      domain: 'saib.com.eg',
      aliases: [
        'Societe Arabe Internationale de Banque',
        'بنك الشركة المصرفية العربية الدولية',
      ],
    ),
    KnownBank(
      code: 'SCB',
      name: 'Suez Canal Bank',
      nameAr: 'بنك قناة السويس',
      domain: 'scbank.com.eg',
      aliases: ['SCBank'],
    ),
    KnownBank(
      code: 'ABC',
      name: 'Bank ABC Egypt',
      nameAr: 'بنك ABC مصر',
      domain: 'bank-abc.com',
      aliases: [
        'Bank ABC',
        'Arab Banking Corporation',
        'Blom Bank Egypt',
        'BLOM',
      ],
    ),
    KnownBank(
      code: 'ARAB',
      name: 'Arab Bank',
      nameAr: 'البنك العربي',
      domain: 'arabbank.com.eg',
      aliases: ['Arab Bank Egypt', 'ARABBANK'],
    ),
    KnownBank(
      code: 'AIB',
      name: 'Arab International Bank',
      nameAr: 'المصرف العربي الدولي',
      domain: 'aib.com.eg',
      aliases: ['المصرف العربى الدولى'],
    ),
    KnownBank(
      code: 'NXT',
      name: 'Bank NXT',
      nameAr: 'بنك نكست',
      domain: 'banknxteg.com',
      aliases: [
        'BANKNXT',
        'Arab Investment Bank',
        'aiBANK',
        'بنك الاستثمار العربي',
      ],
    ),
    KnownBank(
      code: 'MIDBANK',
      name: 'MIDBANK',
      nameAr: 'ميد بنك',
      domain: 'midbank.com.eg',
      aliases: ['Misr Iran Development Bank'],
    ),
    KnownBank(
      code: 'EALB',
      name: 'Egyptian Arab Land Bank',
      nameAr: 'البنك العقاري المصري العربي',
      domain: 'eal-bank.com',
      aliases: ['البنك العقارى المصرى العربى'],
    ),
    KnownBank(
      code: 'ABE',
      name: 'Agricultural Bank of Egypt',
      nameAr: 'البنك الزراعي المصري',
      domain: 'abe.com.eg',
      aliases: ['البنك الزراعى المصرى'],
    ),
    KnownBank(
      code: 'IDB',
      name: 'Industrial Development Bank',
      nameAr: 'بنك التنمية الصناعية',
      domain: 'idb.com.eg',
      aliases: ['Industrial Development Bank of Egypt'],
    ),
    KnownBank(
      code: 'UB',
      name: 'The United Bank',
      nameAr: 'المصرف المتحد',
      domain: 'theubeg.com',
      aliases: ['United Bank of Egypt', 'The United Bank of Egypt'],
    ),
    KnownBank(
      code: 'ALBARAKA',
      name: 'Al Baraka Bank Egypt',
      nameAr: 'بنك البركة مصر',
      domain: 'albaraka.com.eg',
      aliases: ['Al Baraka Bank', 'Albaraka Bank', 'بنك البركة'],
    ),
    KnownBank(
      code: 'ATTIJARI',
      name: 'Attijariwafa Bank Egypt',
      nameAr: 'التجاري وفا بنك مصر',
      domain: 'attijariwafabank.com.eg',
      aliases: ['Attijariwafa', 'Barclays Egypt', 'التجاري وفا بنك'],
    ),
    KnownBank(
      code: 'MASHREQ',
      name: 'Mashreq Bank Egypt',
      nameAr: 'بنك المشرق مصر',
      domain: 'mashreq.com',
      aliases: ['Mashreq Bank', 'Mashreq', 'المشرق'],
    ),
    KnownBank(
      code: 'CITI',
      name: 'Citibank Egypt',
      nameAr: 'سيتي بنك مصر',
      domain: 'citibank.com',
      aliases: ['Citibank', 'Citi Egypt'],
    ),
    KnownBank(
      code: 'SC',
      name: 'Standard Chartered Egypt',
      nameAr: 'ستاندرد تشارترد مصر',
      domain: 'sc.com',
      aliases: ['Standard Chartered', 'SCB Egypt'],
    ),
    KnownBank(
      code: 'ONEBANK',
      name: 'onebank',
      nameAr: 'وان بنك',
      domain: 'onebank.eg',
    ),
    KnownBank(
      code: 'NASSER',
      name: 'Nasser Social Bank',
      nameAr: 'بنك ناصر الاجتماعي',
      domain: 'nsb.gov.eg',
      aliases: ['NSB', 'بنك ناصر الإجتماعي'],
    ),
  ];

  static const wallets = <KnownBank>[
    KnownBank(
      code: 'INSTAPAY',
      name: 'InstaPay',
      nameAr: 'إنستاباي',
      domain: 'instapay.eg',
      aliases: ['IPN'],
      isWallet: true,
    ),
    KnownBank(
      code: 'VODAFONECASH',
      name: 'Vodafone Cash',
      nameAr: 'فودافون كاش',
      domain: 'web.vodafone.com.eg',
      aliases: ['VodafoneC'],
      isWallet: true,
    ),
    KnownBank(
      code: 'ORANGECASH',
      name: 'Orange Cash',
      nameAr: 'أورنج كاش',
      domain: 'orange.eg',
      isWallet: true,
    ),
    KnownBank(
      code: 'ETISALATCASH',
      name: 'e& Cash',
      nameAr: 'إي آند كاش',
      domain: 'etisalat.eg',
      aliases: ['Etisalat Cash', 'eandcash', 'اتصالات كاش'],
      isWallet: true,
    ),
    KnownBank(
      code: 'WEPAY',
      name: 'WE Pay',
      nameAr: 'وي باي',
      domain: 'te.eg',
      isWallet: true,
    ),
  ];

  static Iterable<KnownBank> get all => [...banks, ...wallets];
  static String normalize(String value) =>
      value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9\u0600-\u06ff]'), '');

  /// Presentation only: preserve raw sender/merchant text and stable identities.
  static String displayName(String? identity, {bool arabic = false}) {
    final bank = byIdentity(identity);
    if (bank == null) return identity?.trim() ?? '';
    return arabic ? bank.nameAr : bank.name;
  }

  static KnownBank? byIdentity(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final key = normalize(value);
    for (final bank in all) {
      if ([
        bank.code,
        bank.name,
        bank.nameAr,
        ...bank.aliases,
      ].any((name) => normalize(name) == key)) {
        return bank;
      }
    }
    return null;
  }

  /// Prefer the sender over references to other banks in a transfer body.
  /// Match complete identities, never generic words such as "bank"/"Egypt".
  static KnownBank? match(String? sender, String body) {
    final direct = byIdentity(sender);
    if (direct != null) return direct;
    final senderKey = normalize(sender ?? '');
    for (final bank in all) {
      for (final identity in [bank.code, bank.name, ...bank.aliases]) {
        final key = normalize(identity);
        if (RegExp(r'^\d+$').hasMatch(key)) continue;
        if (senderKey == '${key}bank' ||
            senderKey == '${key}alerts' ||
            senderKey == '${key}egypt' ||
            senderKey == '${key}eg') {
          return bank;
        }
      }
    }
    final text = body.toLowerCase();
    for (final bank in all) {
      for (final identity in [bank.name, bank.nameAr, ...bank.aliases]) {
        if (identity.length < 5 || RegExp(r'^\d+$').hasMatch(identity)) {
          continue;
        }
        if (RegExp(
          '(^|[^a-z0-9\\u0600-\\u06ff])${RegExp.escape(identity.toLowerCase())}(\$|[^a-z0-9\\u0600-\\u06ff])',
        ).hasMatch(text)) {
          return bank;
        }
      }
    }
    return null;
  }
}

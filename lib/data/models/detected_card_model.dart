import 'package:flutter/material.dart';

/// A bank card recognized from SMS transaction messages.
///
/// Only the last four digits are ever stored — the full PAN is never
/// reconstructed or persisted (see requirement #14 — data safety).
class DetectedCard {
  final String id;
  final String userId;

  /// Last four digits of the card, as detected from an SMS.
  final String last4;

  /// Human-readable bank name detected from the SMS (may be null).
  final String? bankName;

  /// Number of parsed transactions linked to this card.
  final int transactionCount;

  /// Persisted per-card appearance settings. Each card stores its own
  /// customization so changing one never affects another (requirement #11).
  final CardAppearance appearance;

  /// Whether this card is configured as a credit card.
  /// When true, the card has a credit limit and supports repayment logic.
  final bool isCreditCard;

  /// Credit limit in minor units (e.g. piasters for EGP).
  /// Only meaningful when [isCreditCard] is true.
  /// Represents the maximum available credit for this card.
  final int creditLimitMinor;

  /// Current available balance for credit cards (starts at credit limit,
  /// decreases with purchases, increases with repayments).
  /// For debit cards, this is managed through the transaction ledger.
  final int currentBalanceMinor;

  /// Whether this credit card can be used for cash withdrawal (Pocket Cash).
  /// Only meaningful when [isCreditCard] is true.
  /// Default is false — most credit cards should not be used for cash withdrawal.
  final bool cashWithdrawalEnabled;

  final DateTime createdAt;
  final DateTime updatedAt;

  DetectedCard({
    required this.id,
    required this.userId,
    required this.last4,
    this.bankName,
    this.transactionCount = 0,
    this.appearance = const CardAppearance(),
    this.isCreditCard = false,
    this.creditLimitMinor = 0,
    this.currentBalanceMinor = 0,
    this.cashWithdrawalEnabled = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory DetectedCard.fromJson(Map<String, dynamic> json) => DetectedCard(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        last4: json['last4'] as String,
        bankName: json['bank_name'] as String?,
        transactionCount: json['transaction_count'] as int? ?? 0,
        appearance: CardAppearance.fromJson(
            Map<String, dynamic>.from(json['appearance'] as Map? ?? {})),
        isCreditCard: json['is_credit_card'] as bool? ?? false,
        creditLimitMinor: json['credit_limit_minor'] as int? ?? 0,
        currentBalanceMinor: json['current_balance_minor'] as int? ?? 0,
        cashWithdrawalEnabled: json['cash_withdrawal_enabled'] as bool? ?? false,
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'] as String)
            : null,
        updatedAt: json['updated_at'] != null
            ? DateTime.parse(json['updated_at'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'last4': last4,
        'bank_name': bankName,
        'transaction_count': transactionCount,
        'appearance': appearance.toJson(),
        'is_credit_card': isCreditCard,
        'credit_limit_minor': creditLimitMinor,
        'current_balance_minor': currentBalanceMinor,
        'cash_withdrawal_enabled': cashWithdrawalEnabled,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };

  DetectedCard copyWith({
    String? id,
    String? userId,
    String? last4,
    String? bankName,
    int? transactionCount,
    CardAppearance? appearance,
    bool? isCreditCard,
    int? creditLimitMinor,
    int? currentBalanceMinor,
    bool? cashWithdrawalEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      DetectedCard(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        last4: last4 ?? this.last4,
        bankName: bankName ?? this.bankName,
        transactionCount: transactionCount ?? this.transactionCount,
        appearance: appearance ?? this.appearance,
        isCreditCard: isCreditCard ?? this.isCreditCard,
        creditLimitMinor:
            creditLimitMinor ?? this.creditLimitMinor,
        currentBalanceMinor:
            currentBalanceMinor ?? this.currentBalanceMinor,
        cashWithdrawalEnabled:
            cashWithdrawalEnabled ?? this.cashWithdrawalEnabled,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}

/// Configuration for a credit card.
/// Stores credit limit, current balance, and cash withdrawal settings.
class CreditCardConfig {
  final String cardId;
  final bool isCreditCard;
  final int creditLimitMinor;
  final int currentBalanceMinor;
  final bool cashWithdrawalEnabled;
  final DateTime? updatedAt;

  const CreditCardConfig({
    required this.cardId,
    required this.isCreditCard,
    required this.creditLimitMinor,
    required this.currentBalanceMinor,
    required this.cashWithdrawalEnabled,
    this.updatedAt,
  });

  CreditCardConfig copyWith({
    String? cardId,
    bool? isCreditCard,
    int? creditLimitMinor,
    int? currentBalanceMinor,
    bool? cashWithdrawalEnabled,
    DateTime? updatedAt,
  }) =>
      CreditCardConfig(
        cardId: cardId ?? this.cardId,
        isCreditCard: isCreditCard ?? this.isCreditCard,
        creditLimitMinor: creditLimitMinor ?? this.creditLimitMinor,
        currentBalanceMinor: currentBalanceMinor ?? this.currentBalanceMinor,
        cashWithdrawalEnabled:
            cashWithdrawalEnabled ?? this.cashWithdrawalEnabled,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}

/// Result from the credit card configuration dialog.
class CreditCardConfigResult {
  final bool isCreditCard;
  final int creditLimitMinor;
  final int currentBalanceMinor;
  final bool cashWithdrawalEnabled;

  const CreditCardConfigResult({
    required this.isCreditCard,
    required this.creditLimitMinor,
    required this.currentBalanceMinor,
    required this.cashWithdrawalEnabled,
  });
}

/// Exceptions for card operations.
class CardOperationException implements Exception {
  final String message;
  const CardOperationException(this.message);

  @override
  String toString() => 'CardOperationException: $message';
}

class CreditLimitExceededException implements Exception {
  final String message;
  const CreditLimitExceededException(this.message);

  @override
  String toString() => 'CreditLimitExceededException: $message';
}

class InsufficientCreditException implements Exception {
  final String message;
  const InsufficientCreditException(this.message);

  @override
  String toString() => 'InsufficientCreditException: $message';
}
/// Per-card appearance preset selected by the user (requirement #11).
/// Also stores per-card eye visibility (balance display toggle).
class CardAppearance {
  /// Preset index into [CardPresets.presets]. Each preset has a unique
  /// gradient + pattern so cards are visually distinguishable by default.
  final int presetIndex;

  /// Optional user-chosen color override (stored as ARGB int). When null the
  /// preset gradient is used.
  final int? colorA;
  final int? colorB;

  /// Whether the card's balance is visible (eye icon state).
  /// Per-card independent visibility (requirement #11).
  final bool eyeVisible;

  const CardAppearance({
    this.presetIndex = 0,
    this.colorA,
    this.colorB,
    this.eyeVisible = true,
  });

  factory CardAppearance.fromJson(Map<String, dynamic> json) => CardAppearance(
        presetIndex: json['preset_index'] as int? ?? 0,
        colorA: json['color_a'] as int?,
        colorB: json['color_b'] as int?,
        eyeVisible: json['eye_visible'] as bool? ?? true,
      );

  Map<String, dynamic> toJson() => {
        'preset_index': presetIndex,
        'color_a': colorA,
        'color_b': colorB,
        'eye_visible': eyeVisible,
      };

  CardAppearance copyWith({
    int? presetIndex,
    int? colorA,
    int? colorB,
    bool? eyeVisible,
  }) =>
      CardAppearance(
        presetIndex: presetIndex ?? this.presetIndex,
        colorA: colorA ?? this.colorA,
        colorB: colorB ?? this.colorB,
        eyeVisible: eyeVisible ?? this.eyeVisible,
      );

  /// Resolves the effective gradient colors for this card.
  List<Color> get colors {
    if (colorA != null && colorB != null) {
      return [Color(colorA!), Color(colorB!)];
    }
    return CardPresets
        .presets[presetIndex.clamp(0, CardPresets.presets.length - 1)];
  }
}

/// A bank of premium, visually-distinct card gradients/patterns. Each card
/// starts with a different preset so users can tell them apart at a glance
/// (requirement #10 — unique background design for every card).
class CardPresets {
  static const List<List<Color>> presets = [
    // Indigo → Purple
    [Color(0xFF6F5BD3), Color(0xFF8A78E8)],
    // Teal → Cyan
    [Color(0xFF0EA5E9), Color(0xFF12BFFF)],
    // Rose → Pink
    [Color(0xFFF05B9A), Color(0xFFFFB3BA)],
    // Amber → Orange
    [Color(0xFFFFB84D), Color(0xFFF59E1A)],
    // Emerald → Green
    [Color(0xFF10B981), Color(0xFF34D399)],
    // Violet → Fuchsia
    [Color(0xFF8B5CF6), Color(0xFFEC4899)],
    // Blue → Indigo
    [Color(0xFF55AFFF), Color(0xFF4F46E5)],
    // Dark slate → muted
    [Color(0xFF1E293B), Color(0xFF334155)],
  ];
}

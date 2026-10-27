import '../entities/detected_card_model.dart';

/// Business-facing port. Implementations own persistence and synchronization.
abstract interface class DetectedCardRepository {
  Future<List<DetectedCard>> getCards(String userId);

  Future<DetectedCard> upsertCard({
    required String userId,
    required String last4,
    String? bankName,
    int? transactionCountDelta,
    CardAppearance? appearance,
  });

  Future<DetectedCard?> findCardIdentity({
    required String userId,
    required String last4,
    String? bankName,
  });

  Future<void> updateAppearance(
      String userId, String cardId, CardAppearance appearance);

  Future<void> updateDetectedCard(DetectedCard card);

  Future<void> recomputeTransactionCountsForCards(
    String userId,
    int Function(DetectedCard card) countFor,
  );

  Future<void> recomputeTransactionCounts(
      String userId, int Function(String cardLast4) countFor);

  Future<void> deleteCard(String userId, String cardId);

  Future<bool> getCardEyeVisible(String userId, String cardId);

  Future<bool> toggleCardEye(String userId, String cardId);

  Future<void> setCardEyeVisible(String userId, String cardId, bool visible);

  Future<DetectedCard?> getCardById(String userId, String cardId);

  Future<void> setCardEye(String userId, String cardId, bool visible);

  Future<void> setCashWithdrawalEnabled(
      String userId, String cardId, bool enabled);

  Future<void> setCreditCardConfig({
    required String userId,
    required String cardId,
    required bool isCreditCard,
    int creditLimitMinor = 0,
    int currentBalanceMinor = 0,
    bool cashWithdrawalEnabled = false,
    DateTime? updatedAt,
  });

  Future<CreditCardConfig?> getCreditCardConfig(String userId, String cardId);

  Future<int> addCreditBalance({
    required String userId,
    required String cardId,
    required int amountMinor,
  });

  Future<int> deductCreditBalance({
    required String userId,
    required String cardId,
    required int amountMinor,
  });
}

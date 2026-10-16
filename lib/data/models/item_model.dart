import 'package:freezed_annotation/freezed_annotation.dart';

part 'item_model.freezed.dart';
part 'item_model.g.dart';

DateTime? _dateTimeFromJson(dynamic value) =>
    value == null ? null : DateTime.parse(value.toString()).toUtc();

DateTime _dateTimeFromJsonRequired(dynamic value) =>
    DateTime.parse(value.toString()).toUtc();

@freezed
class Item with _$Item {
  const factory Item({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String name,
    @JsonKey(name: 'name_ar') String? nameAr,
    String? description,
    @JsonKey(name: 'price_minor') required int priceMinor,
    @Default('EGP') String currency,
    @JsonKey(name: 'category_id') String? categoryId,
    String? icon,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'is_archived') @Default(false) bool isArchived,
    @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
    DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
    DateTime? updatedAt,
  }) = _Item;

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
}

@freezed
class ItemPriceHistory with _$ItemPriceHistory {
  const factory ItemPriceHistory({
    required String id,
    @JsonKey(name: 'item_id') required String itemId,
    @JsonKey(name: 'price_minor') required int priceMinor,
    @JsonKey(name: 'effective_from', fromJson: _dateTimeFromJsonRequired)
    required DateTime effectiveFrom,
    @JsonKey(name: 'effective_to', fromJson: _dateTimeFromJson)
    DateTime? effectiveTo,
    @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
    DateTime? createdAt,
  }) = _ItemPriceHistory;

  factory ItemPriceHistory.fromJson(Map<String, dynamic> json) =>
      _$ItemPriceHistoryFromJson(json);
}

@freezed
class Category with _$Category {
  const factory Category({
    required String id,
    @JsonKey(name: 'user_id') String? userId,
    required String name,
    @JsonKey(name: 'name_ar') String? nameAr,
    String? icon,
    @JsonKey(name: 'parent_id') String? parentId,
    @Default('expense') String type,
    @JsonKey(name: 'is_system') @Default(false) bool isSystem,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
    DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
    DateTime? updatedAt,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}

@freezed
class Merchant with _$Merchant {
  const factory Merchant({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String name,
    @JsonKey(name: 'normalized_name') required String normalizedName,
    @JsonKey(name: 'category_id') String? categoryId,
    @JsonKey(name: 'logo_url') String? logoUrl,
    @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
    DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
    DateTime? updatedAt,
  }) = _Merchant;

  factory Merchant.fromJson(Map<String, dynamic> json) =>
      _$MerchantFromJson(json);
}

@freezed
class CashWallet with _$CashWallet {
  const factory CashWallet({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @Default('EGP') String currency,
    @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
    DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: _dateTimeFromJson)
    DateTime? updatedAt,
  }) = _CashWallet;

  factory CashWallet.fromJson(Map<String, dynamic> json) =>
      _$CashWalletFromJson(json);
}

@freezed
class CashMovement with _$CashMovement {
  const factory CashMovement({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'wallet_id') required String walletId,
    required String type,
    @JsonKey(name: 'amount_minor') required int amountMinor,
    @JsonKey(name: 'reference_type') String? referenceType,
    @JsonKey(name: 'reference_id') String? referenceId,
    String? description,
    @JsonKey(name: 'movement_date', fromJson: _dateTimeFromJsonRequired)
    required DateTime movementDate,
    @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)
    DateTime? createdAt,
  }) = _CashMovement;

  factory CashMovement.fromJson(Map<String, dynamic> json) =>
      _$CashMovementFromJson(json);
}

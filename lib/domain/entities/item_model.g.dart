// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Item _$ItemFromJson(Map<String, dynamic> json) => _Item(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  name: json['name'] as String,
  nameAr: json['name_ar'] as String?,
  description: json['description'] as String?,
  priceMinor: (json['price_minor'] as num).toInt(),
  currency: json['currency'] as String? ?? 'EGP',
  categoryId: json['category_id'] as String?,
  icon: json['icon'] as String?,
  imageUrl: json['image_url'] as String?,
  isActive: json['is_active'] as bool? ?? true,
  isArchived: json['is_archived'] as bool? ?? false,
  createdAt: _dateTimeFromJson(json['created_at']),
  updatedAt: _dateTimeFromJson(json['updated_at']),
);

Map<String, dynamic> _$ItemToJson(_Item instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'name': instance.name,
  'name_ar': instance.nameAr,
  'description': instance.description,
  'price_minor': instance.priceMinor,
  'currency': instance.currency,
  'category_id': instance.categoryId,
  'icon': instance.icon,
  'image_url': instance.imageUrl,
  'is_active': instance.isActive,
  'is_archived': instance.isArchived,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};

_ItemPriceHistory _$ItemPriceHistoryFromJson(Map<String, dynamic> json) =>
    _ItemPriceHistory(
      id: json['id'] as String,
      itemId: json['item_id'] as String,
      priceMinor: (json['price_minor'] as num).toInt(),
      effectiveFrom: _dateTimeFromJsonRequired(json['effective_from']),
      effectiveTo: _dateTimeFromJson(json['effective_to']),
      createdAt: _dateTimeFromJson(json['created_at']),
    );

Map<String, dynamic> _$ItemPriceHistoryToJson(_ItemPriceHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'item_id': instance.itemId,
      'price_minor': instance.priceMinor,
      'effective_from': instance.effectiveFrom.toIso8601String(),
      'effective_to': instance.effectiveTo?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
    };

_Category _$CategoryFromJson(Map<String, dynamic> json) => _Category(
  id: json['id'] as String,
  userId: json['user_id'] as String?,
  name: json['name'] as String,
  nameAr: json['name_ar'] as String?,
  icon: json['icon'] as String?,
  parentId: json['parent_id'] as String?,
  type: json['type'] as String? ?? 'expense',
  isSystem: json['is_system'] as bool? ?? false,
  isActive: json['is_active'] as bool? ?? true,
  createdAt: _dateTimeFromJson(json['created_at']),
  updatedAt: _dateTimeFromJson(json['updated_at']),
);

Map<String, dynamic> _$CategoryToJson(_Category instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'name': instance.name,
  'name_ar': instance.nameAr,
  'icon': instance.icon,
  'parent_id': instance.parentId,
  'type': instance.type,
  'is_system': instance.isSystem,
  'is_active': instance.isActive,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};

_Merchant _$MerchantFromJson(Map<String, dynamic> json) => _Merchant(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  name: json['name'] as String,
  normalizedName: json['normalized_name'] as String,
  categoryId: json['category_id'] as String?,
  logoUrl: json['logo_url'] as String?,
  createdAt: _dateTimeFromJson(json['created_at']),
  updatedAt: _dateTimeFromJson(json['updated_at']),
);

Map<String, dynamic> _$MerchantToJson(_Merchant instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'name': instance.name,
  'normalized_name': instance.normalizedName,
  'category_id': instance.categoryId,
  'logo_url': instance.logoUrl,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};

_CashWallet _$CashWalletFromJson(Map<String, dynamic> json) => _CashWallet(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  currency: json['currency'] as String? ?? 'EGP',
  createdAt: _dateTimeFromJson(json['created_at']),
  updatedAt: _dateTimeFromJson(json['updated_at']),
);

Map<String, dynamic> _$CashWalletToJson(_CashWallet instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'currency': instance.currency,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_CashMovement _$CashMovementFromJson(Map<String, dynamic> json) =>
    _CashMovement(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      walletId: json['wallet_id'] as String,
      type: json['type'] as String,
      amountMinor: (json['amount_minor'] as num).toInt(),
      referenceType: json['reference_type'] as String?,
      referenceId: json['reference_id'] as String?,
      description: json['description'] as String?,
      movementDate: _dateTimeFromJsonRequired(json['movement_date']),
      createdAt: _dateTimeFromJson(json['created_at']),
    );

Map<String, dynamic> _$CashMovementToJson(_CashMovement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'wallet_id': instance.walletId,
      'type': instance.type,
      'amount_minor': instance.amountMinor,
      'reference_type': instance.referenceType,
      'reference_id': instance.referenceId,
      'description': instance.description,
      'movement_date': instance.movementDate.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
    };

import 'package:flutter/material.dart';
import '../../../domain/entities/item_model.dart';
import '../../../core/theme/item_appearance.dart';
import 'item_image.dart';

class ItemAvatar extends StatelessWidget {
  const ItemAvatar({super.key, required this.item, this.size = 44});
  final Item item;
  final double size;
  @override
  Widget build(BuildContext context) {
    final appearance = ItemAppearance.decode(item.icon);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          color: appearance.color.withValues(alpha: .14),
          borderRadius: BorderRadius.circular(14)),
      child: FloosyItemImage(
          imageUrl: item.imageUrl,
          width: size,
          height: size,
          radius: 14,
          fallback: Center(
              child: Text(appearance.symbol,
                  style: TextStyle(fontSize: size * .48)))),
    );
  }
}

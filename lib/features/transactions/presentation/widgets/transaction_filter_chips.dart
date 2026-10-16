import 'package:flutter/material.dart';

import '../../../../core/theme/app_design_system.dart';

/// Localized display strings for the Transactions category filter chips.
///
/// These keys MUST exist in both `app_en.arb` and `app_ar.arb`. The chip row
/// resolves through this whitelist so a missing key can never surface as a
/// raw technical key (e.g. "filterATM") and a new label silently inherits the
/// no-wrap chip layout instead of an unconstrained wrap.
class TransactionChipLabels {
  /// Localization keys in chip order (All first).
  static const List<String> keys = [
    'filterAll',
    'filterOnline',
    'filterTransfersIn',
    'filterTransfersOut',
    'filterATM',
    'filterIncome',
  ];
}

/// Horizontally scrollable category chip row for the Transactions screen.
///
/// Each chip sizes to its own content (intrinsic width) and NEVER wraps its
/// label: long labels ("Purchases", "Transfers Out", localized Arabic
/// strings) scroll instead of breaking mid-word ("purch/ases"). A single
/// horizontal scrollable only — no nested vertical scrollables, no fixed
/// device-specific widths, no `Expanded` equal-width splitting.
class TransactionChipRow extends StatelessWidget {
  final List<String> keys;
  final int activeIndex;
  final String Function(String key) labelFor;
  final void Function(int index) onSelect;

  const TransactionChipRow({
    super.key,
    required this.keys,
    required this.activeIndex,
    required this.labelFor,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < keys.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            _Chip(
              key: ValueKey('txn_filter_chip_$i'),
              label: labelFor(keys[i]),
              isSelected: activeIndex == i,
              onTap: () => onSelect(i),
            ),
          ],
        ],
      ),
    );
  }
}

/// Filter chip for transaction type filtering. Intrinsic content width +
/// `softWrap: false` so labels ("Purchases", "Transfers In/Out", "Income",
/// "ATM", localized Arabic) always stay on ONE line.
class _Chip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _Chip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? FloosyDesign.primaryPurple
              : context.fc.elevatedSurface,
          borderRadius: BorderRadius.circular(FloosyDesign.radiusSmall),
          border: Border.all(
            color: isSelected
                ? FloosyDesign.primaryPurple
                : context.fc.borderSubtle,
          ),
        ),
        child: Text(
          label,
          softWrap: false,
          maxLines: 1,
          overflow: TextOverflow.visible,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? Colors.white : context.fc.textSecondary,
          ),
        ),
      ),
    );
  }
}

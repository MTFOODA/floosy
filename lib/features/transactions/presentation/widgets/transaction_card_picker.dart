import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/common/bank_logo.dart';
import '../../../../domain/entities/bank_directory.dart';
import '../../../../domain/entities/detected_card_model.dart';
import '../../../../domain/services/card_ownership.dart';

class TransactionCardPicker extends StatelessWidget {
  const TransactionCardPicker({
    super.key,
    required this.cards,
    required this.selectedId,
    required this.onChanged,
    required this.emptyLabel,
    required this.decoration,
  });

  final List<DetectedCard> cards;
  final String? selectedId;
  final ValueChanged<String?>? onChanged;
  final String emptyLabel;
  final InputDecoration decoration;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.s(context);
    return DropdownButtonFormField<String>(
      initialValue: cards.any((card) => card.id == selectedId)
          ? selectedId
          : '',
      isExpanded: true,
      itemHeight: null,
      decoration: decoration,
      onChanged: onChanged == null
          ? null
          : (value) => onChanged!(value == '' ? null : value),
      items: [
        DropdownMenuItem(value: '', child: Text(emptyLabel)),
        for (final card in cards)
          DropdownMenuItem(
            value: card.id,
            child: Row(
              children: [
                BankLogo(bankName: card.bankName, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    card.bankName == null
                        ? l['bankUnknown']
                        : BankCatalog.displayName(
                            card.bankName,
                            arabic: l.isArabic,
                          ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('•• ${card.last4}', textDirection: TextDirection.ltr),
                    if (cards.any(
                      (other) =>
                          other.id != card.id &&
                          other.last4 == card.last4 &&
                          sameIssuingBank(other.bankName, card.bankName),
                    ))
                      Text(
                        l.t('transactionCount', {
                          'count': '${card.transactionCount}',
                        }),
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}

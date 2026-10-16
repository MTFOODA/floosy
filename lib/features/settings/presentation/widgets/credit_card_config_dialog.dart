import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/providers.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../data/models/detected_card_model.dart';

/// Dialog for configuring a credit card's settings.
class CreditCardConfigDialog extends ConsumerStatefulWidget {
  final String cardId;
  final CreditCardConfig? currentConfig;

  const CreditCardConfigDialog({
    super.key,
    required this.cardId,
    this.currentConfig,
  });

  @override
  ConsumerState<CreditCardConfigDialog> createState() =>
      _CreditCardConfigDialogState();
}

class _CreditCardConfigDialogState
    extends ConsumerState<CreditCardConfigDialog> {
  late TextEditingController _limitController;
  late bool _cashWithdrawalEnabled;
  bool? _isCreditCard;

  /// A credit card's My Balance always starts at 0. The customer adds money
  /// via the dashboard '+' button, never through this dialog (requirement #1).
  /// The currentBalanceMinor is therefore hard-coded to 0 on save.
  static const _kInitialBalanceMinor = 0;

  @override
  void initState() {
    super.initState();
    final config = widget.currentConfig;
    _isCreditCard = config?.isCreditCard ?? false;
    _cashWithdrawalEnabled = config?.cashWithdrawalEnabled ?? false;

    final limitMinor = (config?.creditLimitMinor ?? 0);
    _limitController = TextEditingController(
      text: (limitMinor / 100).toStringAsFixed(0),
    );
  }

  Future<void> _save() async {
    final l = AppLocalizations.s(context);

    final userId = ref.read(currentUserIdProvider);
    if (userId == null) {
      if (mounted) Navigator.of(context).pop();
      return;
    }
    // Persistence belongs to the CALLER: a Fixed Amount change must flow
    // through `MoneyRepository.setFixedAmountForCard` so the invariant
    // `My Balance <= Fixed Amount` can never be violated. This dialog only
    // validates the input and returns the requested configuration.
    if (_isCreditCard != true) {
      if (mounted) {
        Navigator.of(context).pop(
          CreditCardConfigResult(
            isCreditCard: false,
            creditLimitMinor: 0,
            currentBalanceMinor: 0,
            cashWithdrawalEnabled: _cashWithdrawalEnabled,
          ),
        );
      }
      return;
    }

    final limitAmount = double.tryParse(_limitController.text) ?? 0;
    final limitMinor = (limitAmount * 100).round();

    if (limitMinor <= 0) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l['creditLimitRequired'])),
        );
      }
      return;
    }

    if (mounted) {
      Navigator.of(context).pop(
        CreditCardConfigResult(
          isCreditCard: true,
          creditLimitMinor: limitMinor,
          currentBalanceMinor: _kInitialBalanceMinor,
          cashWithdrawalEnabled: _cashWithdrawalEnabled,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.s(context);
    final isCreditCard = _isCreditCard ?? false;

    return AlertDialog(
      backgroundColor: context.fc.primarySurface,
      title: Text(l['creditCardConfig'], style: context.fc.cardTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: Text(l['isCreditCard']),
              subtitle: Text(l['creditCardHelp']),
              value: isCreditCard,
              onChanged: (value) {
                setState(() => _isCreditCard = value);
                if (!value) {
                  _limitController.clear();
                }
              },
            ),
            const Divider(),
            if (isCreditCard) ...[
              Text(l['creditLimit'],
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: _limitController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: l['creditLimitAmount'],
                  prefixText: 'EGP ',
                  suffixText: 'EGP',
                  helperText: l['creditLimitHelp'],
                ),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: Text(l['cashWithdrawal']),
                subtitle: Text(l['cashWithdrawalHelp']),
                value: _cashWithdrawalEnabled,
                onChanged: (value) {
                  setState(() => _cashWithdrawalEnabled = value);
                },
              ),
              const Divider(),
              Text(
                l['pocketCashNote'],
                style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: context.fc.textMuted),
              ),
            ],
            if (!isCreditCard) ...[
              const SizedBox(height: 8),
              Text(
                l['debitCardNote'],
                style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: context.fc.textMuted),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l['cancel'])),
        ElevatedButton(onPressed: _save, child: Text(l['save'])),
      ],
    );
  }
}

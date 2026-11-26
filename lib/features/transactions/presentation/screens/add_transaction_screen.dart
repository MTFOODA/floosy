import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:floosy/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:floosy/features/settings/presentation/cubit/cards_cubit.dart';
import 'package:floosy/features/transactions/presentation/cubit/transaction_commands_cubit.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/utils/money_formatter.dart';
import '../../../../domain/entities/transaction_model.dart';
import '../../../../routing/app_routes.dart';
import '../widgets/transaction_card_picker.dart';

/// Manual "Add Transaction" screen (Transactions → +).
///
/// Creates a manual ledger entry with an optional link to a saved card.
class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  TransactionType _type = TransactionType.purchase;
  String _currency = 'EGP';
  String? _cardId;
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  bool get _saving => context.read<TransactionCommandsCubit>().state.busy;

  static const _currencies = ['EGP', 'USD', 'EUR', 'GBP', 'SAR', 'AED', 'KWD'];

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    final l = AppLocalizations.s(context);
    final amount = parseMoneyMinor(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l['invalidAmount'])));
      return;
    }
    final userId = context.read<AuthCubit>().state.userId;
    if (userId == null) return;

    try {
      await context.read<TransactionCommandsCubit>().createManual(
        type: _type,
        amountMinor: amount,
        currency: _currency,
        note: _noteController.text,
        cardId: _cardId,
      );
      logInfo('NAV_BACK add-transaction saved → popping');
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      logError('Manual transaction save failed', e);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l['failedToLoad'])));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<TransactionCommandsCubit>();
    final l = AppLocalizations.s(context);
    final cards = context.watch<CardsCubit>().state;
    return Scaffold(
      backgroundColor: context.fc.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(l['addTransaction'], style: context.fc.cardTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.canPop()
              ? context.pop()
              : context.go(AppRoutes.transactions),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: FloosyDesign.horizontalPadding(context).copyWith(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l['typeLabel'], style: context.fc.bodyTextSmall),
              const SizedBox(height: 8),
              DropdownButtonFormField<TransactionType>(
                initialValue: _type,
                dropdownColor: context.fc.primarySurface,
                style: TextStyle(fontSize: 14, color: context.fc.textPrimary),
                decoration: _inputDecoration(context),
                items:
                    [
                          (TransactionType.purchase, l['typePurchase']),
                          (TransactionType.income, l['typeIncome']),
                          (TransactionType.transfer_in, l['typeTransferIn']),
                          (TransactionType.transfer_out, l['typeTransferOut']),
                          (TransactionType.atm_withdrawal, l['typeAtm']),
                          (TransactionType.cash_expense, l['typeCashExpense']),
                        ]
                        .map(
                          (e) =>
                              DropdownMenuItem(value: e.$1, child: Text(e.$2)),
                        )
                        .toList(),
                onChanged: (v) => setState(() => _type = v ?? _type),
              ),
              const SizedBox(height: 16),
              TransactionCardPicker(
                cards: cards.value ?? const [],
                selectedId: _cardId,
                emptyLabel: l['transactionNoCard'],
                decoration: _inputDecoration(context).copyWith(
                  labelText: l['transactionCardOptional'],
                  helperText: l['transactionNoCardHint'],
                  helperMaxLines: 2,
                ),
                onChanged: _saving || (cards.isLoading && !cards.hasValue)
                    ? null
                    : (id) => setState(() => _cardId = id),
              ),
              const SizedBox(height: 16),
              Text(l['amountLabel'], style: context.fc.bodyTextSmall),
              const SizedBox(height: 8),
              TextField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: TextStyle(fontSize: 14, color: context.fc.textPrimary),
                decoration: _inputDecoration(context),
              ),
              const SizedBox(height: 16),
              Text(l['currencyLabel'], style: context.fc.bodyTextSmall),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _currency,
                dropdownColor: context.fc.primarySurface,
                style: TextStyle(fontSize: 14, color: context.fc.textPrimary),
                decoration: _inputDecoration(context),
                items: _currencies
                    .map(
                      (c) => DropdownMenuItem(
                        value: c,
                        child: Text(l.currencyName(c)),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _currency = v ?? _currency),
              ),
              const SizedBox(height: 16),
              Text(l['noteLabel'], style: context.fc.bodyTextSmall),
              const SizedBox(height: 8),
              TextField(
                controller: _noteController,
                style: TextStyle(fontSize: 14, color: context.fc.textPrimary),
                decoration: _inputDecoration(context),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: FloosyDesign.primaryPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        FloosyDesign.radiusMedium,
                      ),
                    ),
                  ),
                  child: _saving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          l['save'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(BuildContext context) {
    return InputDecoration(
      filled: true,
      fillColor: context.fc.inputBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }
}

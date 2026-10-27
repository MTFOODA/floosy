import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:floosy/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:floosy/features/transactions/presentation/cubit/transaction_commands_cubit.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../domain/entities/transaction_model.dart';
import '../../../../routing/app_routes.dart';

/// Manual "Add Transaction" screen (Transactions → +).
///
/// Creates a single manual transaction record with the user-chosen type,
/// amount, currency and optional note. Ownership is enforced through the
/// authenticated [AuthCubit]. Creating a transaction here is a
/// record-keeping action — it intentionally does NOT move Pocket Cash, and
/// it never touches SMS-derived balance logic.
class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  TransactionType _type = TransactionType.purchase;
  String _currency = 'EGP';
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
    final l = AppLocalizations.s(context);
    final amountText = _amountController.text.trim().replaceAll(',', '');
    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l['invalidAmount'])));
      return;
    }
    final userId = context.read<AuthCubit>().state.userId;
    if (userId == null) return;

    try {
      await context.read<TransactionCommandsCubit>().createManual(
          type: _type,
          amountMinor: (amount * 100).round(),
          currency: _currency,
          note: _noteController.text);
      logInfo('NAV_BACK add-transaction saved → popping');
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      logError('Manual transaction save failed', e);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l['failedToLoad'])));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<TransactionCommandsCubit>();
    final l = AppLocalizations.s(context);
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
                items: [
                  (TransactionType.purchase, l['typePurchase']),
                  (TransactionType.income, l['typeIncome']),
                  (TransactionType.transfer_in, l['typeTransferIn']),
                  (TransactionType.transfer_out, l['typeTransferOut']),
                  (TransactionType.atm_withdrawal, l['typeAtm']),
                  (TransactionType.cash_expense, l['typeCashExpense']),
                ]
                    .map((e) => DropdownMenuItem(
                          value: e.$1,
                          child: Text(e.$2),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _type = v ?? _type),
              ),
              const SizedBox(height: 16),
              Text(l['amountLabel'], style: context.fc.bodyTextSmall),
              const SizedBox(height: 8),
              TextField(
                controller: _amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
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
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
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
                        borderRadius:
                            BorderRadius.circular(FloosyDesign.radiusMedium)),
                  ),
                  child: _saving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : Text(l['save'],
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
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

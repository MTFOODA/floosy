import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../domain/entities/salary_plan.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../cubit/finance_cubit.dart';
import '../cubit/salary_plan_cubit.dart';

Future<void> showSalarySetupDialog(
  BuildContext context, {
  required int currentBalanceMinor,
  SalaryPlan? existing,
}) async {
  final l = AppLocalizations.s(context);
  final salary = TextEditingController(
    text: existing == null
        ? ''
        : (existing.monthlySalaryMinor / 100).toStringAsFixed(2),
  );
  // Always show the live account value. Re-saving a plan must not replace a
  // newer balance with an old saved snapshot.
  final balance = TextEditingController(
    text: (currentBalanceMinor / 100).toStringAsFixed(2),
  );
  var day = existing?.cycleStartDay ?? 1;
  var detect = existing?.autoDetectSalary ?? true;
  final saved = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        backgroundColor: context.fc.primarySurface,
        title: Text(l['salarySetupTitle'], style: context.fc.cardTitle),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l['salarySetupDialogHint'],
                style: TextStyle(color: context.fc.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: salary,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: l['monthlySalary'],
                  hintText: l['salaryAmountHint'],
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: balance,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: l['startingAccountBalance'],
                  hintText: l['startingBalanceHint'],
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                initialValue: day,
                items: [
                  for (var value = 1; value <= 31; value++)
                    DropdownMenuItem(
                      value: value,
                      child: Text('${l['cycleStartDay']} $value'),
                    ),
                ],
                onChanged: (value) => setState(() => day = value ?? 1),
                decoration: InputDecoration(labelText: l['cycleStartDay']),
              ),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                value: detect,
                activeTrackColor: FloosyDesign.primaryPurple,
                onChanged: (value) => setState(() => detect = value),
                title: Text(l['autoDetectSalary']),
                subtitle: Text(
                  l['autoDetectSalaryHint'],
                  style: TextStyle(
                    fontSize: 11,
                    color: context.fc.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l['cancel']),
          ),
          ElevatedButton(
            onPressed: () {
              final salaryMinor =
                  ((double.tryParse(salary.text.trim()) ?? 0) * 100).round();
              if (salaryMinor <= 0) return;
              Navigator.pop(dialogContext, true);
            },
            child: Text(l['save']),
          ),
        ],
      ),
    ),
  );
  if (saved != true || !context.mounted) {
    salary.dispose();
    balance.dispose();
    return;
  }
  final amount = ((double.tryParse(salary.text.trim()) ?? 0) * 100).round();
  final opening = ((double.tryParse(balance.text.trim()) ?? 0) * 100).round();
  final userId = context.read<AuthCubit>().state.userId;
  final finance = context.read<FinanceCubit>();
  final salaryCubit = context.read<SalaryPlanCubit>();
  final selectedCard = finance.state.map((data) => data.card).value;
  try {
    if (userId == null || selectedCard == null) {
      throw StateError('Select a debit card before setting its balance');
    }
    // This is a real account baseline, not a separate planning number. The
    // transaction ledger keeps moving it afterwards, exactly like My Balance.
    await finance.setCurrentBalanceForCard(
      userId: userId,
      cardLast4: selectedCard.last4,
      bankName: selectedCard.bankName,
      targetBalanceMinor: opening,
    );
    await salaryCubit.configure(
      monthlySalaryMinor: amount,
      cycleStartDay: day,
      startingBalanceMinor: opening,
      autoDetectSalary: detect,
    );
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l['salaryBalanceUpdateFailed'])),
      );
    }
  } finally {
    salary.dispose();
    balance.dispose();
  }
}

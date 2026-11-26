import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/utils/money_formatter.dart';
import '../../../../domain/entities/salary_plan.dart';

Future<void> showSalarySetupDialog(
  BuildContext context, {
  required int currentBalanceMinor,
  SalaryPlan? existing,
  required Future<void> Function(int balance, int? salary, int day, bool detect)
  onSave,
}) => showDialog<void>(
  context: context,
  barrierDismissible: false,
  builder: (_) => _SalarySetupDialog(
    currentBalanceMinor: currentBalanceMinor,
    existing: existing,
    onSave: onSave,
  ),
);

class _SalarySetupDialog extends StatefulWidget {
  const _SalarySetupDialog({
    required this.currentBalanceMinor,
    required this.existing,
    required this.onSave,
  });

  final int currentBalanceMinor;
  final SalaryPlan? existing;
  final Future<void> Function(int balance, int? salary, int day, bool detect)
  onSave;

  @override
  State<_SalarySetupDialog> createState() => _SalarySetupDialogState();
}

class _SalarySetupDialogState extends State<_SalarySetupDialog> {
  final _form = GlobalKey<FormState>();
  late final _salary = TextEditingController(
    text: widget.existing == null
        ? ''
        : (widget.existing!.monthlySalaryMinor / 100).toStringAsFixed(2),
  );
  late final _balance = TextEditingController(
    text: (widget.currentBalanceMinor / 100).toStringAsFixed(2),
  );
  late int _day = widget.existing?.cycleStartDay ?? 1;
  late bool _detect = widget.existing?.autoDetectSalary ?? true;
  bool _saving = false;
  bool _failed = false;

  @override
  void dispose() {
    _salary.dispose();
    _balance.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving || !_form.currentState!.validate()) return;
    final salary = parseMoneyMinor(_salary.text);
    setState(() {
      _saving = true;
      _failed = false;
    });
    try {
      await widget.onSave(
        parseMoneyMinor(_balance.text)!,
        salary,
        _day,
        _detect,
      );
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (mounted) {
        setState(() {
          _saving = false;
          _failed = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.s(context);
    const keyboard = TextInputType.numberWithOptions(decimal: true);
    return PopScope(
      canPop: !_saving,
      child: AlertDialog(
        title: Text(l['salarySetupTitle']),
        content: SingleChildScrollView(
          child: Form(
            key: _form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l['salarySetupDialogHint']),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _balance,
                  enabled: !_saving,
                  keyboardType: keyboard,
                  decoration: InputDecoration(
                    labelText: l['startingAccountBalance'],
                    hintText: l['startingBalanceHint'],
                  ),
                  validator: (value) {
                    final balance = parseMoneyMinor(value ?? '');
                    return balance == null ||
                            (balance < 0 &&
                                balance != widget.currentBalanceMinor)
                        ? l['accountBalanceInvalid']
                        : null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _salary,
                  enabled: !_saving,
                  keyboardType: keyboard,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    labelText: l['monthlySalaryOptional'],
                    hintText: l['salaryAmountHint'],
                    helperText: l['salaryOptionalHint'],
                    helperMaxLines: 2,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return null;
                    return (parseMoneyMinor(value) ?? 0) <= 0
                        ? l['invalidAmount']
                        : null;
                  },
                ),
                if (_salary.text.trim().isNotEmpty) ...[
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    initialValue: _day,
                    isExpanded: true,
                    items: [
                      for (var day = 1; day <= 31; day++)
                        DropdownMenuItem(value: day, child: Text('$day')),
                    ],
                    onChanged: _saving
                        ? null
                        : (value) => setState(() => _day = value ?? 1),
                    decoration: InputDecoration(labelText: l['cycleStartDay']),
                  ),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    value: _detect,
                    onChanged: _saving
                        ? null
                        : (value) => setState(() => _detect = value),
                    title: Text(l['autoDetectSalary']),
                    subtitle: Text(l['autoDetectSalaryHint']),
                  ),
                ],
                if (_failed)
                  Text(
                    l['salaryBalanceUpdateFailed'],
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saving ? null : () => Navigator.of(context).pop(),
            child: Text(l['cancel']),
          ),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: Text(l[_saving ? 'saving' : 'save']),
          ),
        ],
      ),
    );
  }
}

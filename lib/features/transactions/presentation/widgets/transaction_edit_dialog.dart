import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/utils/money_formatter.dart';
import '../../../../core/widgets/common/bank_logo.dart';
import '../../../../domain/entities/bank_directory.dart';
import '../../../../domain/entities/item_model.dart' show Category;
import '../../../../domain/entities/transaction_model.dart';
import '../../../../domain/entities/transaction_edit_policy.dart';
import '../../../../domain/usecases/save_transaction_edit.dart';
import 'transaction_widgets.dart';
import 'transaction_card_picker.dart';

class TransactionEditDialog extends StatefulWidget {
  final TransactionEditPolicy policy;
  final List<Category> categories;
  final Future<void> Function(TransactionEditDraft) onSave;
  const TransactionEditDialog({
    super.key,
    required this.policy,
    this.categories = const [],
    required this.onSave,
  });
  @override
  State<TransactionEditDialog> createState() => _TransactionEditDialogState();
}

class _TransactionEditDialogState extends State<TransactionEditDialog> {
  late final _amount = TextEditingController(
    text: widget.policy.amount
        ? ''
        : (widget.policy.transaction.amountMinor / 100).toStringAsFixed(2),
  );
  late final _last4 = TextEditingController(
    text: widget.policy.transaction.cardLast4 ?? '',
  );
  late final _merchant = TextEditingController(
    text: widget.policy.merchant
        ? ''
        : widget.policy.transaction.merchantName ?? '',
  );
  final _note = TextEditingController();
  late TransactionType? _type = widget.policy.type
      ? null
      : widget.policy.transaction.type;
  late String _currency = widget.policy.transaction.currency.isEmpty
      ? 'EGP'
      : widget.policy.transaction.currency;
  String? _bank;
  String? _cardId;
  late String? _category = widget.policy.transaction.categoryId;
  bool _saving = false;
  String? _error;
  @override
  void dispose() {
    _amount.dispose();
    _last4.dispose();
    _merchant.dispose();
    _note.dispose();
    super.dispose();
  }

  InputDecoration _decoration(
    String label, {
    String? hint,
    bool enabled = true,
  }) => InputDecoration(
    labelText: label,
    hintText: hint,
    filled: true,
    fillColor: enabled
        ? context.fc.elevatedSurface
        : context.fc.borderSubtle.withValues(alpha: .3),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    suffixIcon: enabled
        ? null
        : Icon(
            Icons.lock_outline_rounded,
            size: 17,
            color: context.fc.textMuted,
          ),
  );

  Widget _field(
    String key,
    TextEditingController controller,
    String label, {
    bool editable = false,
    String? hint,
    TextInputType? keyboard,
    int? maxLength,
  }) => Opacity(
    opacity: editable ? 1 : .6,
    child: TextField(
      key: ValueKey(key),
      controller: controller,
      enabled: editable && !_saving,
      readOnly: !editable,
      keyboardType: keyboard,
      maxLength: maxLength,
      decoration: _decoration(label, hint: hint, enabled: editable),
    ),
  );

  Future<void> _save() async {
    final l = AppLocalizations.s(context), p = widget.policy;
    if (_type == null) {
      setState(() => _error = l['chooseTypeHint']);
      return;
    }
    final amount = p.amount
        ? parseMoneyMinor(_amount.text)
        : p.transaction.amountMinor;
    if (amount == null || (p.amount && amount <= 0)) {
      setState(() => _error = l['invalidAmount']);
      return;
    }
    final last4 = normalizeMoneyDigits(_last4.text.trim());
    if (_cardId == null &&
        last4.isNotEmpty &&
        !RegExp(r'^\d{4}$').hasMatch(last4)) {
      setState(() => _error = l['last4Invalid']);
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await widget.onSave(
        TransactionEditDraft(
          transaction: p.transaction,
          type: _type!,
          amountMinor: amount,
          currency: _currency,
          bankText: _bank ?? p.bankName ?? '',
          last4Text: last4,
          categoryId: _category,
          merchantName: p.merchant
              ? (_merchant.text.trim().isEmpty
                    ? p.transaction.merchantName
                    : _merchant.text.trim())
              : p.transaction.merchantName,
          transactionDate: p.transaction.transactionDate,
          additionalNote: _note.text,
          selectedCardId: _cardId,
        ),
      );
      if (mounted) Navigator.pop(context, true);
    } catch (error) {
      if (mounted) {
        final key = switch (error) {
          TransactionEditFailure(code: 'locked') => 'editLockedError',
          TransactionEditFailure(code: 'chooseCard') =>
            'transactionChooseSpecificCard',
          _ => 'saveFailed',
        };
        setState(() => _error = l[key]);
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.s(context), p = widget.policy;
    final selectedCategory = widget.categories
        .where((c) => c.id == _category)
        .firstOrNull;
    final categoryName = selectedCategory == null
        ? l['categorySelected']
        : l.isArabic
        ? selectedCategory.nameAr ?? selectedCategory.name
        : selectedCategory.name;
    final children = <Widget>[
      Text(
        l['transactionLockedHint'],
        style: TextStyle(color: context.fc.textSecondary, fontSize: 13),
      ),
      Opacity(
        opacity: p.type ? 1 : .6,
        child: DropdownButtonFormField<TransactionType>(
          key: const ValueKey('tx_type'),
          initialValue: _type,
          isExpanded: true,
          decoration: _decoration(
            l['typeLabel'],
            enabled: p.type,
            hint: l['chooseTypeHint'],
          ),
          items: [
            for (final t in TransactionType.values)
              DropdownMenuItem(
                value: t,
                child: Text(transactionTypeLabel(l, t)),
              ),
          ],
          onChanged: p.type && !_saving
              ? (v) => setState(() => _type = v!)
              : null,
        ),
      ),
      _field(
        'tx_amount',
        _amount,
        l['amount'],
        editable: p.amount,
        hint: l['amountHint'],
        keyboard: const TextInputType.numberWithOptions(decimal: true),
      ),
      if (p.currency)
        DropdownButtonFormField<String>(
          initialValue: _currency,
          isExpanded: true,
          decoration: _decoration(l['currency']),
          items: [
            for (final code in [
              'EGP',
              'USD',
              'EUR',
              'GBP',
              'SAR',
              'AED',
              'KWD',
            ])
              DropdownMenuItem(value: code, child: Text(l.currencyName(code))),
          ],
          onChanged: _saving ? null : (v) => setState(() => _currency = v!),
        )
      else
        Opacity(
          opacity: .6,
          child: TextFormField(
            initialValue: l.currencyName(_currency),
            enabled: false,
            decoration: _decoration(l['currency'], enabled: false),
          ),
        ),
      if (p.cardOptions.isNotEmpty)
        TransactionCardPicker(
          key: const ValueKey('tx_card_picker'),
          cards: p.cardOptions,
          selectedId: _cardId ?? p.transaction.cardId,
          emptyLabel:
              l[p.transaction.cardId == null
                  ? 'transactionNoCard'
                  : 'notSelected'],
          decoration: _decoration(l['transactionCardOptional']),
          onChanged: _saving
              ? null
              : (value) => setState(() => _cardId = value),
        ),
      if (_cardId == null && p.bank)
        DropdownButtonFormField<String>(
          key: const ValueKey('tx_bank'),
          initialValue: _bank,
          isExpanded: true,
          decoration: _decoration(l['bankLabel'], hint: l['chooseBankHint']),
          items: [
            for (final b in BankCatalog.all)
              DropdownMenuItem(
                value: b.name,
                child: Row(
                  children: [
                    BankLogo(bankName: b.name, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l.isArabic ? b.nameAr : b.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
          ],
          onChanged: _saving ? null : (v) => setState(() => _bank = v),
        )
      else if (_cardId == null)
        Opacity(
          opacity: .6,
          child: TextFormField(
            key: const ValueKey('tx_bank'),
            initialValue: p.bankName == null
                ? l['bankLinked']
                : BankCatalog.displayName(p.bankName, arabic: l.isArabic),
            enabled: false,
            decoration: _decoration(l['bankLabel'], enabled: false),
          ),
        ),
      if (_cardId == null)
        _field(
          'tx_last4',
          _last4,
          l['last4Label'],
          editable: p.last4,
          hint: l['last4Hint'],
          keyboard: TextInputType.number,
          maxLength: 4,
        ),
      Opacity(
        opacity: .6,
        child: TextFormField(
          key: const ValueKey('tx_date'),
          initialValue: DateFormat(
            'dd/MM/yyyy hh:mm a',
            l.locale.languageCode,
          ).format(p.transaction.transactionDate),
          enabled: false,
          decoration: _decoration(l['transactionDate'], enabled: false),
        ),
      ),
      Text(
        l['optionalInfo'],
        style: TextStyle(
          color: context.fc.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      _field(
        'tx_merchant',
        _merchant,
        l['merchantLabel'],
        editable: p.merchant,
        hint: l['merchantHint'],
      ),
      if (p.category && widget.categories.isNotEmpty)
        DropdownButtonFormField<String>(
          key: const ValueKey('tx_category'),
          initialValue: _category,
          isExpanded: true,
          decoration: _decoration(
            l['categoryOptional'],
            hint: l['chooseCategoryHint'],
          ),
          items: [
            for (final c in widget.categories)
              DropdownMenuItem(
                value: c.id,
                child: Text(
                  l.isArabic ? c.nameAr ?? c.name : c.name,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
          onChanged: _saving ? null : (v) => setState(() => _category = v),
        )
      else
        Opacity(
          opacity: .6,
          child: TextFormField(
            initialValue: p.category ? l['notSelected'] : categoryName,
            enabled: false,
            decoration: _decoration(l['categoryOptional'], enabled: false),
          ),
        ),
      if (p.transaction.notes?.isNotEmpty == true)
        Opacity(
          opacity: .6,
          child: TextFormField(
            initialValue: p.transaction.notes,
            minLines: 1,
            maxLines: 4,
            enabled: false,
            decoration: _decoration(l['existingNotes'], enabled: false),
          ),
        ),
      TextField(
        key: const ValueKey('tx_note'),
        controller: _note,
        minLines: 2,
        maxLines: 4,
        enabled: !_saving,
        decoration: _decoration(l['additionalNote'], hint: l['noteHint']),
      ),
      if (_error != null)
        Text(_error!, style: const TextStyle(color: Colors.red)),
    ];
    return PopScope(
      canPop: !_saving,
      child: AlertDialog(
        title: Text(l['transactionDetails']),
        content: SizedBox(
          width: 480,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < children.length; i++)
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: i == children.length - 1 ? 0 : 16,
                    ),
                    child: children[i],
                  ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saving ? null : () => Navigator.pop(context, false),
            child: Text(l['cancel']),
          ),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l['save']),
          ),
        ],
      ),
    );
  }
}

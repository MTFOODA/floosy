import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/utils/app_logger.dart';
import '../state/transaction_display_filter.dart';

/// Clean start/end DATE + TIME range selector for the Transactions screen.
///
/// Opened from the filter icon in the Transactions app bar/header. The chosen
/// range is a DISPLAY FILTER ONLY:
///   * it filters which ALREADY STORED transactions are visible;
///   * it never triggers an SMS scan, never deletes and never recreates
///     transactions;
///   * "Clear filter" returns the screen to showing ALL stored transactions.
class TransactionFilterSheet extends ConsumerStatefulWidget {
  const TransactionFilterSheet({super.key});

  @override
  ConsumerState<TransactionFilterSheet> createState() =>
      _TransactionFilterSheetState();
}

class _TransactionFilterSheetState
    extends ConsumerState<TransactionFilterSheet> {
  DateTime? _start;
  DateTime? _end;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final filter = ref.read(transactionDisplayFilterProvider);
    _start = filter.startDateTime;
    _end = filter.endDateTime;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.s(context);
    final isArabic = l.isArabic;
    final df = DateFormat('dd/MM/yyyy', isArabic ? 'ar' : 'en');
    final tf = DateFormat.Hm(isArabic ? 'ar' : 'en');

    return AnimatedPadding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      child: SafeArea(
        top: false,
        child: Container(
          key: const Key('transaction_filter_sheet'),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          decoration: BoxDecoration(
            color: context.fc.elevatedSurface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(Icons.filter_list_rounded,
                      size: 20, color: context.fc.textSecondary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(l['filterByDate'],
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: context.fc.textPrimary)),
                  ),
                  IconButton(
                    key: const Key('transaction_filter_close'),
                    tooltip: l['cancel'],
                    onPressed:
                        _saving ? null : () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                    color: context.fc.textSecondary,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                l['filterDisplayOnlyHint'],
                style: TextStyle(fontSize: 12, color: context.fc.textSecondary),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _Row(
                        label: l['rangeStartDate'],
                        value: _start == null
                            ? l['filterPickDate']
                            : '${df.format(_start!)}  ${tf.format(_start!)}',
                        onPickDate: () => _pickDate(isStart: true),
                        onPickTime: _start == null
                            ? null
                            : () => _pickTime(isStart: true),
                        dateKey: const Key('transaction_filter_start_date'),
                        timeKey: const Key('transaction_filter_start_time'),
                      ),
                      const SizedBox(height: 10),
                      _Row(
                        label: l['rangeEndDate'],
                        value: _end == null
                            ? l['filterPickDate']
                            : '${df.format(_end!)}  ${tf.format(_end!)}',
                        onPickDate: () => _pickDate(isStart: false),
                        onPickTime: _end == null
                            ? null
                            : () => _pickTime(isStart: false),
                        dateKey: const Key('transaction_filter_end_date'),
                        timeKey: const Key('transaction_filter_end_time'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      buttonKey: const Key('transaction_filter_clear'),
                      label: l['clearFilter'],
                      onPressed: _saving ? null : _onClear,
                      foregroundColor: context.fc.textSecondary,
                      backgroundColor: context.fc.primarySurface,
                      borderColor: context.fc.borderSubtle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _ActionButton(
                      buttonKey: const Key('transaction_filter_cancel'),
                      label: l['cancel'],
                      onPressed:
                          _saving ? null : () => Navigator.of(context).pop(),
                      foregroundColor: context.fc.textSecondary,
                      backgroundColor: Colors.transparent,
                      borderColor: context.fc.borderSubtle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _ActionButton(
                      buttonKey: const Key('transaction_filter_apply'),
                      label: l['applyFilter'],
                      onPressed: _saving ? null : _onApply,
                      foregroundColor: Colors.white,
                      backgroundColor: FloosyDesign.primaryPurple,
                      borderColor: FloosyDesign.primaryPurple,
                      gradient: FloosyDesign.purpleGradient,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Picks a new start or end DATE for the filter range.
  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: (isStart ? _start : _end) ?? now,
      firstDate: DateTime(now.year - 10),
      lastDate: DateTime(now.year + 1),
    );
    if (picked == null || !mounted) return;
    final current = isStart ? _start : _end;
    final time = current == null
        ? const TimeOfDay(hour: 0, minute: 0)
        : TimeOfDay.fromDateTime(current);
    if (isStart) {
      setState(() => _start = DateTime(
          picked.year, picked.month, picked.day, time.hour, time.minute));
    } else {
      setState(() => _end = DateTime(
          picked.year, picked.month, picked.day, time.hour, time.minute));
    }
  }

  /// Picks a new start or end TIME for the filter range.
  Future<void> _pickTime({required bool isStart}) async {
    final current = isStart ? _start : _end;
    final initial = current == null
        ? const TimeOfDay(hour: 0, minute: 0)
        : TimeOfDay.fromDateTime(current);
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
    );
    if (picked == null || !mounted) return;
    final base =
        isStart ? (_start ?? DateTime.now()) : (_end ?? DateTime.now());
    if (isStart) {
      setState(() => _start = DateTime(
          base.year, base.month, base.day, picked.hour, picked.minute));
    } else {
      setState(() => _end = DateTime(
          base.year, base.month, base.day, picked.hour, picked.minute));
    }
  }

  /// Applies the currently selected range to the display filter.
  void _onApply() {
    if (_saving) return;
    if (_start == null || _end == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.s(context)['rangeInvalid'])));
      return;
    }
    if (_start!.isAfter(_end!)) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.s(context)['rangeInvalid'])));
      return;
    }
    setState(() => _saving = true);
    try {
      ref
          .read(transactionDisplayFilterProvider.notifier)
          .setRange(_start!, _end!);
      logInfo(
          'TransactionsFilterApplied start=$_start end=$_end (display-only, no SMS scan)');
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      logError('TransactionsFilterApplyFailed', e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.s(context)['rangeInvalid'])));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  /// Clears the filter -> ALL stored transactions are shown again.
  void _onClear() {
    if (_saving) return;
    ref.read(transactionDisplayFilterProvider.notifier).clear();
    logInfo('TransactionsFilterCleared (showing all stored transactions)');
    if (mounted) Navigator.of(context).pop();
  }
}

class _ActionButton extends StatelessWidget {
  final Key buttonKey;
  final String label;
  final VoidCallback? onPressed;
  final Color foregroundColor;
  final Color backgroundColor;
  final Color borderColor;
  final Gradient? gradient;

  const _ActionButton({
    required this.buttonKey,
    required this.label,
    required this.onPressed,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.borderColor,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      enabled: onPressed != null,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          key: buttonKey,
          onTap: onPressed,
          borderRadius: BorderRadius.circular(FloosyDesign.radiusMedium),
          child: Ink(
            height: 46,
            decoration: BoxDecoration(
              color: gradient == null ? backgroundColor : null,
              gradient: gradient,
              borderRadius: BorderRadius.circular(FloosyDesign.radiusMedium),
              border: Border.all(color: borderColor),
            ),
            child: Center(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: foregroundColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onPickDate;
  final VoidCallback? onPickTime;
  final Key? dateKey;
  final Key? timeKey;

  const _Row({
    required this.label,
    required this.value,
    required this.onPickDate,
    this.onPickTime,
    this.dateKey,
    this.timeKey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: context.fc.primarySurface,
        borderRadius: BorderRadius.circular(FloosyDesign.radiusMedium),
        border: Border.all(color: context.fc.borderSubtle),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 92,
            child: Text(label,
                style:
                    TextStyle(fontSize: 13, color: context.fc.textSecondary)),
          ),
          Expanded(
            child: Text(value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13, color: context.fc.textPrimary)),
          ),
          GestureDetector(
            key: dateKey,
            onTap: onPickDate,
            child: Icon(Icons.calendar_today_rounded,
                size: 18, color: context.fc.textSecondary),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            key: timeKey,
            onTap: onPickTime,
            child: Icon(Icons.schedule_rounded,
                size: 18, color: context.fc.textSecondary),
          ),
        ],
      ),
    );
  }
}

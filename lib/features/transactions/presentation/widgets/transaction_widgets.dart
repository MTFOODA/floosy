import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/utils/display_text_guard.dart';
import '../../../../core/utils/money_formatter.dart';
import '../../../../domain/entities/transaction_model.dart';

/// Localized display name for a transaction type.
String transactionTypeLabel(AppLocalizations l, TransactionType type) {
  switch (type) {
    case TransactionType.purchase:
      return l['purchase'];
    case TransactionType.atm_withdrawal:
      return l['atmWithdrawal'];
    case TransactionType.cash_expense:
      return l['cashExpense'];
    case TransactionType.income:
      return l['income'];
    case TransactionType.transfer_in:
      return l['transferReceived'];
    case TransactionType.transfer_out:
      return l['transferSent'];
    case TransactionType.refund:
      return l['typeRefund'];
    case TransactionType.reversal:
      return l['typeReversal'];
    case TransactionType.adjustment:
      return l['typeAdjustment'];
  }
}

class TransactionGroup extends StatelessWidget {
  final String dateStr;
  final List<Transaction> transactions;
  final bool Function(TransactionType) isCredit;
  final IconData Function(TransactionType) typeIcon;
  final void Function(Transaction)? onTransactionTap;

  /// Transaction ids that have no resolvable card, so their row shows the red
  /// dot. Computed by the caller from the SAME ownership rules the balances
  /// use, so the indicator can never disagree with the figures.
  final Set<String> unresolvedCardIds;

  const TransactionGroup({
    super.key,
    required this.dateStr,
    required this.transactions,
    required this.isCredit,
    required this.typeIcon,
    this.onTransactionTap,
    this.unresolvedCardIds = const {},
  });

  @override
  Widget build(BuildContext context) {
    final total = transactions
        .where((t) => t.status == TransactionStatus.confirmed)
        .fold<int>(
            0,
            (sum, t) =>
                sum + (isCredit(t.type) ? t.amountMinor : -t.amountMinor));
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(dateStr,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: context.fc.textSecondary)),
              ),
              const SizedBox(width: 8),
              Text('${total >= 0 ? '+' : '-'}${formatMoney(total.abs())}',
                  style: TextStyle(
                      fontSize: 13,
                      color: total >= 0
                          ? FloosyDesign.positive
                          : FloosyDesign.negative)),
            ],
          ),
          const SizedBox(height: 10),
          ...transactions.map((t) => TransactionCard(
              transaction: t,
              isCredit: isCredit(t.type),
              icon: typeIcon(t.type),
              isCardUnresolved: unresolvedCardIds.contains(t.id),
              onTap: onTransactionTap == null
                  ? null
                  : () => onTransactionTap!(t))),
        ],
      ),
    );
  }
}

String _transactionSymbol(TransactionType type) => switch (type) {
      TransactionType.atm_withdrawal => '🏧',
      TransactionType.cash_expense => '💵',
      TransactionType.purchase => '🛍️',
      TransactionType.transfer_in || TransactionType.transfer_out => '🏦',
      TransactionType.income => '💰',
      TransactionType.refund || TransactionType.reversal => '↩️',
      TransactionType.adjustment => '⚖️',
    };

class TransactionCard extends StatelessWidget {
  final Transaction transaction;
  final bool isCredit;
  final IconData icon;
  final VoidCallback? onTap;

  /// True when the transaction cannot be attributed to any card, so the red
  /// "needs a card number" dot is shown. While this is true the transaction
  /// affects NO card's My Balance / Deducted Money / Pocket Cash; it stays
  /// visible so the user can supply the missing card number. The dot clears as
  /// soon as the association becomes resolvable.
  final bool isCardUnresolved;

  /// Invoked when the user taps the red dot to resolve the card.
  final VoidCallback? onResolveCard;

  const TransactionCard(
      {super.key,
      required this.transaction,
      required this.isCredit,
      required this.icon,
      this.onTap,
      this.isCardUnresolved = false,
      this.onResolveCard});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.s(context);
    // Requirement #8: the container shows bank name, last 4 card digits
    // (only when they exist — no fabricated data), transaction type,
    // amount, currency, date and time. Full card numbers are never stored
    // nor displayed.
    final hasLast4 = transaction.cardLast4 != null &&
        transaction.cardLast4!.trim().isNotEmpty;
    final dateStr =
        DateFormat('dd/MM/yyyy').format(transaction.transactionDate);
    final timeStr = DateFormat('hh:mm a').format(transaction.transactionDate);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(FloosyDesign.radiusMedium),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.fc.primarySurface,
            borderRadius: BorderRadius.circular(FloosyDesign.radiusMedium),
            border: Border.all(color: context.fc.borderSubtle),
          ),
          child: Row(
            children: [
              Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: context.fc.elevatedSurface,
                      borderRadius: BorderRadius.circular(14)),
                  child: Text(_transactionSymbol(transaction.type),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 21))),
              const SizedBox(width: 14),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bank / merchant name (for SMS transactions this is the
                  // identified bank, or the merchant when one was parsed).
                  // SMS-derived labels pass through the corruption guard: a
                  // clearly garbled label falls back to the type label instead of
                  // mojibake; legitimate Arabic/English names render untouched.
                  Text(
                      DisplayTextGuard.label(
                        transaction.merchantName ??
                            transactionTypeLabel(l, transaction.type),
                        fallback: transactionTypeLabel(l, transaction.type),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: context.fc.textPrimary)),
                  const SizedBox(height: 3),
                  if (transaction.status == TransactionStatus.pending)
                    Text(l['needsReview'],
                        style: const TextStyle(
                            color: FloosyDesign.negative, fontSize: 12)),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                            // Type + currency on one line.
                            '${transactionTypeLabel(l, transaction.type)} · ${transaction.currency}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 12, color: context.fc.textMuted)),
                      ),
                      if (hasLast4) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: context.fc.elevatedSurface,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text('••${transaction.cardLast4}',
                              style: TextStyle(
                                  fontSize: 10,
                                  letterSpacing: 0.5,
                                  color: context.fc.textSecondary)),
                        ),
                      ],
                      // RED DOT: the transaction has no resolvable card. It is
                      // deliberately NOT attributed to the selected card; it is
                      // excluded from every card's figures until the user adds or
                      // corrects the card number, at which point this dot clears.
                      if (isCardUnresolved) ...[
                        const SizedBox(width: 6),
                        Semantics(
                          label: 'Unassigned to a card',
                          button: onResolveCard != null,
                          child: GestureDetector(
                            onTap: onResolveCard,
                            child: Container(
                              width: 9,
                              height: 9,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              )),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                      '${isCredit ? '+' : '-'}'
                      '${formatMoney(transaction.amountMinor)} ${transaction.currency}',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isCredit
                              ? FloosyDesign.positive
                              : FloosyDesign.negative)),
                  const SizedBox(height: 3),
                  Text('$dateStr  $timeStr',
                      style:
                          TextStyle(fontSize: 10, color: context.fc.textMuted)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Groups transactions by calendar day (key `yyyy-MM-dd`) and orders the
/// result for presentation (requirement #12):
///   * day keys are returned NEWEST day first;
///   * inside every day, transactions are ordered by their exact timestamp
///     (date + time), newest first.
///
/// Pure function — no Flutter/UI dependency — so the ordering and grouping
/// rules are unit-testable.
Map<String, List<Transaction>> groupTransactionsByDay(List<Transaction> txs) {
  final grouped = <String, List<Transaction>>{};
  for (final t in txs) {
    final key = '${t.transactionDate.year}-'
        '${t.transactionDate.month.toString().padLeft(2, '0')}-'
        '${t.transactionDate.day.toString().padLeft(2, '0')}';
    grouped.putIfAbsent(key, () => []).add(t);
  }
  for (final dayTransactions in grouped.values) {
    dayTransactions
        .sort((a, b) => b.transactionDate.compareTo(a.transactionDate));
  }
  final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));
  return {for (final key in sortedKeys) key: grouped[key]!};
}

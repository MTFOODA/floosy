import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/utils/display_text_guard.dart';
import '../../../../core/utils/money_formatter.dart';
import '../../../../domain/entities/transaction_model.dart';
import '../../../../domain/entities/bank_directory.dart';
import '../../../../core/widgets/common/bank_logo.dart';

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
  final String? Function(Transaction)? bankNameOf;

  const TransactionGroup({
    super.key,
    required this.dateStr,
    required this.transactions,
    required this.isCredit,
    required this.typeIcon,
    this.onTransactionTap,
    this.unresolvedCardIds = const {},
    this.bankNameOf,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  dateStr,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: context.fc.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          for (var index = 0; index < transactions.length; index++)
            Padding(
              padding: EdgeInsets.only(
                bottom: index == transactions.length - 1 ? 0 : 12,
              ),
              child: TransactionCard(
                transaction: transactions[index],
                bankName: bankNameOf?.call(transactions[index]),
                isCredit: isCredit(transactions[index].type),
                icon: typeIcon(transactions[index].type),
                isCardUnresolved: unresolvedCardIds.contains(
                  transactions[index].id,
                ),
                onTap: onTransactionTap == null
                    ? null
                    : () => onTransactionTap!(transactions[index]),
              ),
            ),
        ],
      ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  final Transaction transaction;
  final String? bankName;
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

  const TransactionCard({
    super.key,
    required this.transaction,
    this.bankName,
    required this.isCredit,
    required this.icon,
    this.onTap,
    this.isCardUnresolved = false,
    this.onResolveCard,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.s(context);
    final identity =
        bankName ?? BankCatalog.byIdentity(transaction.merchantName)?.name;
    final title = BankCatalog.displayName(identity, arabic: l.isArabic);
    final merchant = transaction.merchantName?.trim() ?? '';
    final showMerchant =
        merchant.isNotEmpty &&
        BankCatalog.byIdentity(merchant) == null &&
        merchant != title;
    final last4 = transaction.cardLast4?.trim() ?? '';
    final date = DateFormat('dd/MM/yyyy').format(transaction.transactionDate);
    final time = DateFormat(
      'hh:mm a',
      l.locale.languageCode,
    ).format(transaction.transactionDate);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(FloosyDesign.radiusMedium),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: context.fc.primarySurface,
            borderRadius: BorderRadius.circular(FloosyDesign.radiusMedium),
            border: Border.all(color: context.fc.borderSubtle),
          ),
          // The bank logo stays on the physical right in either language.
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              SizedBox(
                width: 52,
                height: 54,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    BankLogo(bankName: identity, size: 48),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Semantics(
                        label: transactionTypeLabel(l, transaction.type),
                        child: Container(
                          width: 23,
                          height: 23,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: context.fc.elevatedSurface,
                            border: Border.all(
                              color: context.fc.primarySurface,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            icon,
                            size: 13,
                            color: isCredit
                                ? FloosyDesign.positive
                                : FloosyDesign.primaryPurple,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DisplayTextGuard.label(
                        title.isNotEmpty
                            ? title
                            : (showMerchant
                                  ? merchant
                                  : transactionTypeLabel(l, transaction.type)),
                        fallback: transactionTypeLabel(l, transaction.type),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: context.fc.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      transactionTypeLabel(l, transaction.type),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: context.fc.textSecondary,
                      ),
                    ),
                    if (transaction.type == TransactionType.purchase ||
                        (showMerchant && title.isNotEmpty)) ...[
                      const SizedBox(height: 5),
                      Text(
                        transaction.type == TransactionType.purchase
                            ? '${l['merchantLabel']}: ${showMerchant ? DisplayTextGuard.label(merchant) : l['merchantUnavailable']}'
                            : DisplayTextGuard.label(merchant),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: context.fc.textSecondary,
                        ),
                      ),
                    ],
                    if (transaction.status == TransactionStatus.pending)
                      Text(
                        l['needsReview'],
                        style: const TextStyle(
                          color: FloosyDesign.negative,
                          fontSize: 11,
                        ),
                      ),
                    if (last4.isNotEmpty || isCardUnresolved) ...[
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          if (last4.isNotEmpty)
                            Text(
                              '•• $last4',
                              textDirection: TextDirection.ltr,
                              style: TextStyle(
                                fontSize: 10,
                                color: context.fc.textSecondary,
                              ),
                            ),
                          if (isCardUnresolved) ...[
                            const SizedBox(width: 6),
                            Semantics(
                              label: l.isArabic
                                  ? 'تحتاج ربط بكارت'
                                  : 'Unassigned to a card',
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
                  ],
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: MediaQuery.sizeOf(context).width < 360 ? 88 : 104,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${isCredit ? '+' : '-'}${formatMoney(transaction.amountMinor, symbol: l.currencySymbol(transaction.currency))}',
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isCredit
                              ? FloosyDesign.positive
                              : FloosyDesign.negative,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      date,
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        fontSize: 10,
                        color: context.fc.textMuted,
                      ),
                    ),
                    Text(
                      time,
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        fontSize: 10,
                        color: context.fc.textMuted,
                      ),
                    ),
                  ],
                ),
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
    final key =
        '${t.transactionDate.year}-'
        '${t.transactionDate.month.toString().padLeft(2, '0')}-'
        '${t.transactionDate.day.toString().padLeft(2, '0')}';
    grouped.putIfAbsent(key, () => []).add(t);
  }
  for (final dayTransactions in grouped.values) {
    dayTransactions.sort(
      (a, b) => b.transactionDate.compareTo(a.transactionDate),
    );
  }
  final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));
  return {for (final key in sortedKeys) key: grouped[key]!};
}

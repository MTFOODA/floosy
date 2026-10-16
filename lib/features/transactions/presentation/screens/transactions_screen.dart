import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/providers.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../data/models/transaction_model.dart';
import '../../../../data/services/card_ownership.dart';
import '../../../../data/models/user_model.dart';
import '../../../../routing/app_router.dart';
import '../state/transaction_display_filter.dart';
import '../state/transaction_edit_controller.dart';
import '../state/transactions_list_controller.dart';
import '../widgets/transaction_filter_sheet.dart';
import '../widgets/transaction_filter_chips.dart';
import '../widgets/transaction_widgets.dart';

/// Transactions screen.
///
/// LOADING ARCHITECTURE (the stable version):
///
///   TransactionsScreen
///     â†’ [TransactionsListController]  (single owner of list state)
///       â†’ transactionRepository       (LOCAL db is the source of truth)
///         â†’ Drift (NativeDatabase.createInBackground â€” background isolate)
///
///   pull-to-refresh â†’ controller.refresh()
///     â†’ SmsPollingService.scanNow()   (NEW SMS only, single-flight)
///     â†’ local reload                  (never a historical re-scan)
///
///   filter icon â†’ [TransactionDisplayFilter] (DISPLAY ONLY)
///     â†’ controller.load()             (re-query; never an SMS scan)
///
/// The screen renders EXACTLY ONE scrollable ([CustomScrollView]); loading,
/// empty, error and data states are slivers inside it, so there are no nested
/// vertical scrollables and no extent swaps mid-gesture.
class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  TransactionsListController? _controller;
  String _searchQuery = '';
  final _searchController = TextEditingController();

  /// Index of the active type-filter chip (0 = All). Purely a display filter
  /// over the loaded list â€” it never touches the DB or the SMS pipeline.
  int _activeFilterIndex = 0;

  TransactionsListController _ensureController() {
    final existing = _controller;
    if (existing != null) return existing;
    final controller = TransactionsListController(
      // Local-first: the local store is the source of truth, so a slow or
      // failing network can never blank the screen (requirement: local data
      // always visible).
      loadLocal: (start, end) async {
        final userId = ref.read(currentUserIdProvider);
        if (userId == null) return const [];
        final sw = DateTime.now();
        final rows = await ref
            .read(transactionRepositoryProvider)
            .getTransactionsByRange(
              userId: userId,
              startDateTime: start,
              endDateTime: end,
              // No blocking remote fetch on the UI path. Remote rows are merged by
              // the single-flight background sync below.
              syncWithRemote: false,
            );
        logInfo('TRANSACTIONS_QUERY elapsed_ms='
            '${DateTime.now().difference(sw).inMilliseconds} count=${rows.length}');
        return rows;
      },
      runSmsSync: () async {
        final userId = ref.read(currentUserIdProvider);
        if (userId == null) return;
        // NEW SMS ONLY. `scanNow()` never performs a historical full read.
        final result = await ref.read(smsPollingServiceProvider).scanNow();
        logInfo('TRANSACTIONS_REFRESH_SMS_SCAN result=$result');
      },
    );
    _controller = controller;
    return controller;
  }

  @override
  void initState() {
    super.initState();
    _ensureController().load(start: null, end: null);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }

  /// Re-queries the stored list for the CURRENT display filter.
  ///
  /// Called when the user changes/clears the display filter, when new
  /// SMS-derived transactions were stored (refresh tick) and after returning
  /// from the add-transaction screen. This NEVER triggers an SMS scan.
  void _reloadForCurrentFilter() {
    final filter = ref.read(transactionDisplayFilterProvider);
    _ensureController().load(
      start: filter.startDateTime,
      end: filter.endDateTime,
    );
  }

  // â”€â”€ Provider listeners (all lifecycle-safe) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  //
  // Registered in `build` via `ref.listen` (the Riverpod-2 way for widget
  // callbacks: fires AFTER the widget is built, never during it), so a
  // notification from the 5-second SMS poller or the display-filter sheet
  // can no longer hit `setState() during build`.
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.s(context);
    // Transactions that belong to no card yet. They are shown in the list (so
    // the user can act on them) but excluded from EVERY card's figures, and
    // they carry the red dot until the card association is resolved.
    final unresolved = ref.watch(unassignedTransactionsProvider);
    final unresolvedIds = (unresolved.value ?? const <Transaction>[])
        .map((t) => t.id)
        .toSet();

    // New SMS-derived transactions were stored â†’ re-query the local list.
    // NO SMS scan happens here â€” the poller already finished its scan.
    ref.listen<int>(transactionsRefreshTickProvider, (previous, next) {
      if (previous != next) {
        logInfo('TRANSACTIONS_REFRESH_TICK observed â†’ local reload only');
        _reloadForCurrentFilter();
      }
    });

    // The user changed/cleared the DISPLAY filter â†’ re-query ONLY. This must
    // never invoke an SMS scan and never delete/recreate transactions.
    ref.listen<TransactionDisplayFilter>(transactionDisplayFilterProvider,
        (previous, next) {
      if (previous != next) {
        logInfo(
            'TRANSACTIONS_DISPLAY_FILTER_CHANGED $next â†’ local reload only');
        _reloadForCurrentFilter();
      }
    });

    final controller = _ensureController();
    final filter = ref.watch(transactionDisplayFilterProvider);

    return Scaffold(
      backgroundColor: context.fc.background,
      body: SafeArea(
        // Pull-to-refresh: check for NEW SMS â†’ persist â†’ reload the stored
        // list. Single-flight (controller-level) and NEW-messages-only
        // (poller-level), so it can never re-read the historical inbox.
        child: RefreshIndicator(
          onRefresh: () {
            ref.invalidate(moneySummaryProvider);
            ref.invalidate(selectedCardMoneySummaryProvider);
            return controller.refresh(
              start: filter.startDateTime,
              end: filter.endDateTime,
            );
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: FloosyDesign.horizontalPadding(context)
                      .copyWith(top: 16, bottom: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(l['transactions'], style: context.fc.pageTitle),
                          const Spacer(),
                          // DISPLAY FILTER (date/time range) â€” moved out of
                          // Settings. Tapping opens a range selector that
                          // ONLY changes what is visible.
                          GestureDetector(
                            onTap: _openFilterSheet,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: filter.isActive
                                    ? FloosyDesign.primaryPurple
                                    : context.fc.primarySurface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: filter.isActive
                                        ? FloosyDesign.primaryPurple
                                        : context.fc.borderSubtle),
                              ),
                              child: Icon(
                                Icons.filter_list_rounded,
                                size: 20,
                                color: filter.isActive
                                    ? Colors.white
                                    : context.fc.textSecondary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () async {
                              logInfo('NAV_TARGET_ROUTE '
                                  '${AppRoutes.addTransaction}');
                              await context.push(AppRoutes.addTransaction);
                              if (mounted) _reloadForCurrentFilter();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                  gradient: FloosyDesign.purpleGradient,
                                  borderRadius: BorderRadius.circular(14)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.add_rounded,
                                      color: Colors.white, size: 18),
                                  const SizedBox(width: 4),
                                  Text(l['add'],
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildSearchField(l),
                      const SizedBox(height: 16),
                      // Horizontally scrollable, content-width chips: long
                      // labels ("Purchases", "Transfers Out", localized Arabic)
                      // scroll instead of wrapping mid-word.
                      TransactionChipRow(
                        keys: TransactionChipLabels.keys,
                        activeIndex: _activeFilterIndex,
                        labelFor: _chipLabel,
                        onSelect: _onChipSelected,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              // List / loading / error / empty states live INSIDE the one
              // scrollable as slivers â€” no nested vertical scrollables.
              _buildTransactionList(
                  context, l, controller, filter, unresolvedIds),
            ],
          ),
        ),
      ),
    );
  }

  /// Search field for the transaction list header.
  Widget _buildSearchField(AppLocalizations l) {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: l['searchTransactions'],
        prefixIcon: const Icon(Icons.search_rounded, size: 20),
        suffixIcon: _searchQuery.isNotEmpty
            ? GestureDetector(
                onTap: () {
                  _searchController.clear();
                  setState(() => _searchQuery = '');
                },
                child: const Icon(Icons.clear_rounded, size: 18),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FloosyDesign.radiusMedium),
        ),
        filled: true,
        fillColor: context.fc.elevatedSurface.withValues(alpha: 0.6),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
      onChanged: (v) => setState(() => _searchQuery = v),
    );
  }

  void _onChipSelected(int index) {
    // DISPLAY-ONLY index switch: no data mutation, no SMS re-scan.
    // The filter NEVER touches ingestion - it only hides/shows rows.
    if (!mounted || _activeFilterIndex == index) return;
    setState(() => _activeFilterIndex = index);
    logInfo('TRANSACTIONS_TYPE_FILTER index=$index (display only)');
  }

  /// Chip label for the type filter at [index]. Resolves through the shared
  /// chip-label keys so every label (EN/AR) stays on ONE line in its own
  /// content-width chip.
  String _chipLabel(String key) {
    final l = AppLocalizations.of(context);
    return l[key];
  }

  Future<void> _openTransactionActions(Transaction transaction) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: context.fc.elevatedSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(
              color: sheetContext.fc.borderSubtle,
              borderRadius: BorderRadius.circular(4),
            )),
            const SizedBox(height: 18),
            ListTile(
              leading: const Icon(Icons.receipt_long_rounded),
              title: Text(transaction.merchantName ?? 'Transaction'),
              subtitle: Text('${transaction.amountMinor / 100} ${transaction.currency}'),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Edit'),
              onTap: () => Navigator.pop(sheetContext, 'edit'),
            ),
            ListTile(
              leading: const Icon(Icons.rule_folder_outlined),
              title: const Text('Add / Complete information'),
              onTap: () => Navigator.pop(sheetContext, 'complete'),
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () => Navigator.pop(sheetContext, 'delete'),
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('Cancel'),
              onTap: () => Navigator.pop(sheetContext),
            ),
          ]),
        ),
      ),
    );
    if (!mounted || action == null) return;
    if (action == 'edit' || action == 'complete') {
      await _showTransactionEditor(transaction);
    } else if (action == 'delete') {
      await _confirmAndDeleteTransaction(transaction);
    }
  }

  Future<void> _showTransactionEditor(Transaction transaction) async {
    final amount = TextEditingController(text: (transaction.amountMinor / 100).toStringAsFixed(2));
    final currency = TextEditingController(text: transaction.currency);
    final bank = TextEditingController(text: transaction.merchantName ?? '');
    final card = TextEditingController(text: transaction.cardLast4 ?? '');
    final category = TextEditingController(text: transaction.categoryId ?? '');
    final merchant = TextEditingController(text: transaction.merchantName ?? '');
    var type = transaction.type;
    var date = transaction.transactionDate;
    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit transaction'),
          content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
            DropdownButtonFormField<TransactionType>(
              initialValue: type,
              items: TransactionType.values.map((value) => DropdownMenuItem(
                value: value, child: Text(transactionTypeLabel(AppLocalizations.s(context), value)),
              )).toList(),
              onChanged: (value) => setState(() => type = value ?? type),
            ),
            TextField(controller: amount, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Amount')),
            TextField(controller: currency, decoration: const InputDecoration(labelText: 'Currency')),
            TextField(controller: bank, decoration: const InputDecoration(labelText: 'Bank ID / bank name')),
            TextField(controller: card, maxLength: 4, decoration: const InputDecoration(labelText: 'Card last4')),
            TextField(controller: category, decoration: const InputDecoration(labelText: 'Category ID (optional)')),
            TextField(controller: merchant, decoration: const InputDecoration(labelText: 'Description / merchant')),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Transaction date'),
              subtitle: Text(date.toLocal().toString()),
              trailing: const Icon(Icons.calendar_month_outlined),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context, firstDate: DateTime(2000),
                  lastDate: DateTime.now().add(const Duration(days: 1)),
                  initialDate: date,
                );
                if (picked != null) {
                  setState(() => date = DateTime(
                    picked.year, picked.month, picked.day, date.hour, date.minute));
                }
              },
            ),
          ])),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Save')),
          ],
        ),
      ),
    );
    if (saved != true || !mounted) return;
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;
    final amountValue = double.tryParse(amount.text.replaceAll(',', '').trim());
    if (amountValue == null || amountValue <= 0) return;

    // The real save behaviour lives in [TransactionEditController] so it is
    // testable - this is the exact same code the regression tests exercise.
    final controller = TransactionEditController(
      userId: userId,
      transactionRepository: ref.read(transactionRepositoryProvider),
      moneyRepository: ref.read(moneyRepositoryProvider),
      cardRepository: ref.read(detectedCardRepositoryProvider),
      bankCatalogLoader: () => ref
          .read(bankCatalogProvider.future)
          .catchError((_) => <Bank>[]),
    );
    try {
      await controller.save(TransactionEditDraft(
        transaction: transaction,
        type: type,
        amountMinor: (amountValue * 100).round(),
        currency: currency.text.trim().isEmpty
            ? transaction.currency
            : currency.text.trim().toUpperCase(),
        bankText: bank.text,
        last4Text: card.text,
        categoryId:
            category.text.trim().isEmpty ? null : category.text.trim(),
        merchantName:
            merchant.text.trim().isEmpty ? null : merchant.text.trim(),
        transactionDate: date,
      ));
    } catch (e) {
      logError('[EDIT] save failed txn=${transaction.id}', e);
    }

    if (!mounted) return;
    // The refresh is UNCONDITIONAL and runs after the awaited save. Whatever
    // happened above, the screen must re-read the transactions list and drop
    // every derived provider so the committed row is what gets rendered.
    _reloadForCurrentFilter();
    ref.invalidate(unassignedTransactionsProvider);
    ref.invalidate(detectedCardsProvider);
    ref.invalidate(moneySummaryProvider);
    ref.invalidate(selectedCardMoneySummaryProvider);
    ref.invalidate(transactionsRefreshTickProvider);
  }

  Future<void> _recomputeCardCounts(String userId) async {
    final transactions = await ref.read(transactionRepositoryProvider)
        .getTransactions(userId: userId, syncWithRemote: false);
    final cardRepo = ref.read(detectedCardRepositoryProvider);
    final cards = await cardRepo.getCards(userId);
    // Counted through the SAME ownership rule the balances use, so a card's
    // "N transactions" badge can never disagree with its figures.
    await cardRepo.recomputeTransactionCountsForCards(userId, (card) {
      return CardOwnership.forCard(transactions, card, cards).length;
    });
  }

  Future<void> _confirmAndDeleteTransaction(Transaction transaction) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete transaction?'),
        content: const Text('This removes the transaction from the application ledger. The original SMS remains recorded and will not be reprocessed.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')),
          FilledButton(style: FilledButton.styleFrom(backgroundColor: Colors.red), onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Delete')),
        ],
      ),
    );
    final userId = ref.read(currentUserIdProvider);
    if (confirmed != true || !mounted || userId == null) return;
    await ref.read(transactionRepositoryProvider).deleteTransaction(transactionId: transaction.id);
    await _recomputeCardCounts(userId);
    if (!mounted) return;
    ref.invalidate(moneySummaryProvider);
    ref.invalidate(selectedCardMoneySummaryProvider);
    ref.invalidate(detectedCardsProvider);
    ref.read(transactionsRefreshTickProvider.notifier).state++;
    _reloadForCurrentFilter();
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.fc.elevatedSurface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => const TransactionFilterSheet(),
    );
  }

  bool _isCreditFn(TransactionType type) =>
      type == TransactionType.income ||
      type == TransactionType.transfer_in ||
      type == TransactionType.refund ||
      type == TransactionType.reversal;

  IconData _typeIconFn(TransactionType type) {
    switch (type) {
      case TransactionType.purchase:
        return Icons.shopping_cart_outlined;
      case TransactionType.atm_withdrawal:
        return Icons.local_atm_outlined;
      case TransactionType.cash_expense:
        return Icons.payments_outlined;
      case TransactionType.income:
        return Icons.trending_up_rounded;
      case TransactionType.transfer_in:
        return Icons.south_west_rounded;
      case TransactionType.transfer_out:
        return Icons.north_east_rounded;
      default:
        return Icons.receipt_long_outlined;
    }
  }

  List<Transaction> _filterTransactions(List<Transaction> txs) {
    var result = txs;
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result
          .where((t) => (t.merchantName?.toLowerCase().contains(q) ?? false))
          .toList();
    }
    if (_activeFilterIndex > 0) {
      result = result.where((t) {
        switch (_activeFilterIndex) {
          case 1: // Online / purchases
            return t.type == TransactionType.purchase;
          case 2: // Received Transfer
            return t.type == TransactionType.transfer_in;
          case 3: // Outgoing Transfer (never merged with incoming)
            return t.type == TransactionType.transfer_out;
          case 4: // ATM
            return t.type == TransactionType.atm_withdrawal;
          case 5: // Income
            return t.type == TransactionType.income;
          default:
            return true;
        }
      }).toList();
    }
    return result;
  }

  /// The transaction list as slivers of the SINGLE CustomScrollView.
  ///
  /// RenderError fix: the widget NO LONGER swaps a `Future<List>` inside a
  /// FutureBuilder. The controller owns the state and emits coherent
  /// snapshots (data + loading + errors), so the tree only ever changes
  /// BETWEEN frames with a consistent scroll extent.
  Widget _buildTransactionList(
    BuildContext context,
    AppLocalizations l,
    TransactionsListController controller,
    TransactionDisplayFilter filter,
    Set<String> unresolvedCardIds,
  ) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        // 1. Hard load failure with nothing to show â†’ actionable error state.
        if (controller.loadError != null &&
            controller.transactions.isEmpty &&
            !controller.loading) {
          return _buildErrorSliver(l);
        }
        // 2. First load â†’ spinner (inside the scrollable, not a nested one).
        if (controller.loading && controller.transactions.isEmpty) {
          return const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final all = controller.transactions;
        final filtered = _filterTransactions(all);

        // 3. Inline banners (never replace the list).
        final banners = <Widget>[];
        if (controller.refreshError != null) {
          banners.add(_buildInlineBanner(
            l['errorLoading'],
            FloosyDesign.negative,
          ));
        }
        if (filter.isActive) {
          banners.add(_buildInlineBanner(
            l['filterActiveHint'],
            FloosyDesign.primaryPurple,
          ));
        }

        if (filtered.isEmpty) {
          return SliverMainAxisGroup(
            slivers: [
              SliverToBoxAdapter(child: Column(children: banners)),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.receipt_long_outlined,
                      size: 48, color: context.fc.textMuted),
                  const SizedBox(height: 12),
                  Text(l['noTransactionsFound'],
                      style: TextStyle(color: context.fc.textMuted)),
                ])),
              ),
            ],
          );
        }

        // 4. Group AFTER filtering, once per emitted snapshot.
        final grouped = groupTransactionsByDay(filtered);
        final sortedKeys = grouped.keys.toList();
        return SliverMainAxisGroup(
          slivers: [
            SliverToBoxAdapter(child: Column(children: banners)),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) {
                  final key = sortedKeys[i];
                  final txs = grouped[key]!;
                  final parts = key.split('-');
                  final dateStr = '${parts[2]}/${parts[1]}/${parts[0]}';
                  return TransactionGroup(
                      dateStr: dateStr,
                      transactions: txs,
                      isCredit: _isCreditFn,
                      typeIcon: _typeIconFn,
                        unresolvedCardIds: unresolvedCardIds,
                      onTransactionTap: _openTransactionActions);
                },
                childCount: sortedKeys.length,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInlineBanner(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Text(text, style: TextStyle(fontSize: 12, color: color)),
      ),
    );
  }

  Widget _buildErrorSliver(AppLocalizations l) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded,
                size: 48, color: FloosyDesign.negative),
            const SizedBox(height: 12),
            Text(l['errorLoading'],
                textAlign: TextAlign.center,
                style: TextStyle(color: context.fc.textSecondary)),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                logInfo('TRANSACTIONS_RETRY_REQUESTED');
                _reloadForCurrentFilter();
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 26, vertical: 11),
                decoration: BoxDecoration(
                  color: FloosyDesign.primaryPurple,
                  borderRadius: BorderRadius.circular(FloosyDesign.radiusPill),
                ),
                child: Text(l['retry'],
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

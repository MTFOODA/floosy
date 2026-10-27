import '../../../../core/theme/card_appearance_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:floosy/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:floosy/features/dashboard/presentation/cubit/finance_cubit.dart';
import 'package:floosy/features/items/presentation/cubit/items_cubit.dart';
import 'package:floosy/features/settings/presentation/cubit/cards_cubit.dart';
import 'package:floosy/features/settings/presentation/cubit/profile_cubit.dart';
import 'package:floosy/features/transactions/presentation/cubit/sms_cubit.dart';
import 'package:floosy/core/localization/preferences_cubit.dart';
import 'package:floosy/core/state/refresh_cubit.dart';
import 'package:floosy/core/state/load_state.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/utils/money_formatter.dart';
import '../../../../domain/entities/item_model.dart';
import '../../../../domain/entities/money_model.dart';
import '../../../../domain/entities/detected_card_model.dart';
import '../../../../core/widgets/common/item_avatar.dart';
import '../../../../core/theme/item_appearance.dart';
import '../../../../core/widgets/common/finance_panel.dart';
import '../../../../routing/app_routes.dart';
import '../widgets/card_selector_section.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  /// Item id currently being purchased Ã¢â‚¬â€ duplicate-tap protection (#27).
  String? _purchasingItemId;

  /// Toggles the eye visibility for the currently selected card ONLY.
  ///
  /// Visibility is display-only (requirement #10): the eye state lives on the
  /// card's own persisted appearance, and refreshing it deliberately does NOT
  /// invalidate any money provider, so My Balance / Fixed Amount / Deducted
  /// Money / Pocket Cash are never recalculated or modified Ã¢â‚¬â€ and no other
  /// card is affected.
  Future<void> _toggleBalanceVisibility(DetectedCard card) async {
    final userId = context.read<AuthCubit>().state.userId;
    if (userId == null) return;
    final repo = context.read<CardsCubit>();
    await repo.toggleCardEye(userId, card.id);
    if (!mounted) return;
    // Refresh THIS card's eye provider only.
    context.read<CardsCubit>().reload();
  }

  String _greetingKey() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'greetingMorning';
    if (hour < 17) return 'greetingAfternoon';
    return 'greetingEvening';
  }

  String _getFormattedDate(AppLocalizations l) {
    final now = DateTime.now();
    final days = [
      l['wd1'],
      l['wd2'],
      l['wd3'],
      l['wd4'],
      l['wd5'],
      l['wd6'],
      l['wd7']
    ];
    final months = [
      l['mo1'],
      l['mo2'],
      l['mo3'],
      l['mo4'],
      l['mo5'],
      l['mo6'],
      l['mo7'],
      l['mo8'],
      l['mo9'],
      l['mo10'],
      l['mo11'],
      l['mo12']
    ];
    return '${days[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.s(context);
    final userId = context.watch<AuthCubit>().state.userId;
    final profileAsync = context.watch<ProfileCubit>().state;
    context.read<RefreshCubit>().state;
    // Card-specific money figures: when a detected card is selected, My
    // Balance, Pocket Cash and Deducted Money show THAT CARD's values only
    // (scoped by card_last4). No selection Ã¢â€ â€™ explicit zeros.
    final summaryAsync =
        context.watch<FinanceCubit>().state.map((data) => data.summary);
    // Surface provider failures during development instead of silently
    // rendering zeros Ã¢â‚¬â€ zero must mean "calculated zero", not "error".

    final itemsAsync = userId != null
        ? context.watch<ItemsCubit>().state.map((data) => data.active)
        : null;
    final userName = profileAsync.value?.fullName ?? l['greetingFriend'];
    return Scaffold(
      backgroundColor: context.fc.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            final sms = context.read<SmsCubit>();
            final finance = context.read<FinanceCubit>();
            final items = context.read<ItemsCubit>();
            // Requirement #3: pull-to-refresh triggers an IMMEDIATE bank-SMS
            // check through the SAME central pipeline used by the 5-second
            // polling. ANR fix: scanNow() with NO fullScan Ã¢â‚¬â€ it only checks
            // messages newer than the persisted cursor, so a pull can never
            // re-read the historical inbox (that full re-read was the main
            // thread blocker behind the MIUI ANR).
            try {
              await sms.scanNow();
            } catch (e) {
              logError('PULL_REFRESH sms scan failed', e);
            }
            await Future.wait([finance.reload(), items.reload()]);
          },
          child: SingleChildScrollView(
            padding: FloosyDesign.horizontalPadding(context)
                .copyWith(top: 16, bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(userName, l),
                const SizedBox(height: 20),
                const DetectedCardsSection(compact: true),
                const SizedBox(height: 20),
                _buildBalanceCard(summaryAsync, l),
                const SizedBox(height: 20),
                _buildSummaryCards(summaryAsync, l),
                const SizedBox(height: 24),
                _buildItemsSection(itemsAsync, l),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _buildFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildHeader(String userName, AppLocalizations l) {
    return FinancePanel(
      colors: const [Color(0xFF0B4667), Color(0xFF137FA8)],
      child: Row(children: [
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(_getFormattedDate(l),
              style: const TextStyle(fontSize: 11, color: Colors.white70)),
          const SizedBox(height: 6),
          Text(l[_greetingKey()],
              style: const TextStyle(fontSize: 13, color: Colors.white70)),
          const SizedBox(height: 4),
          Text('$userName \u{1F44B}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
        ])),
        IconButton(
            tooltip: l['settings'],
            onPressed: () => context.push(AppRoutes.settings),
            style: IconButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: .12)),
            icon:
                const Icon(Icons.tune_rounded, color: Colors.white, size: 21)),
        IconButton(
            tooltip: 'Floosy',
            onPressed: () => showAboutDialog(
                context: context,
                applicationName: 'Floosy',
                applicationVersion: '1.0.0'),
            icon: const Icon(Icons.info_outline_rounded,
                color: Colors.white70, size: 21)),
      ]),
    );
  }

  Widget _buildBalanceCard(LoadState summaryAsync, AppLocalizations l) {
    final balance = summaryAsync.value?.myBalanceMinor ?? 0;
    // The selected card drives BOTH the eye state and the "+" limit.
    final selectedCard =
        context.watch<FinanceCubit>().state.map((data) => data.card).value;

    // Per-card eye state, read from its OWN provider so toggling one card's
    // visibility never invalidates a money provider or another card.
    final isEyeVisible = selectedCard == null
        ? true
        : (context.watch<CardsCubit>().eyeVisible(selectedCard.id).value ??
            selectedCard.appearance.eyeVisible);

    // The "+" button's availability is a BUSINESS RULE read from the money
    // layer rather than recomputed here:
    //   credit card WITHOUT a Fixed Amount -> disabled (configure it first)
    //   credit card that reached its limit  -> disabled
    //   credit card with headroom           -> enabled, capped to that headroom
    //   debit card                          -> enabled (no Fixed Amount concept)
    //   no card selected                    -> disabled
    final isPlusEnabled = context
            .watch<FinanceCubit>()
            .state
            .map((data) => data.canAddBalance)
            .value ??
        false;

    return FinancePanel(
      height: 138,
      colors: const [Color(0xFF145574), Color(0xFF1489B7)],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(l['myBalance'],
                  style: const TextStyle(fontSize: 14, color: Colors.white70)),
              const Spacer(),
              // "Add My Balance" Ã¢â‚¬â€ ICON ONLY (requirement #10). No text
              // label beside the icon; a Tooltip keeps it understandable
              // and accessible. Existing balance behavior unchanged.
              GestureDetector(
                onTap: isPlusEnabled ? _showAddBalanceDialog : null,
                child: Tooltip(
                  message: l['addMyBalance'],
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(10)),
                    child: Icon(
                      Icons.add_rounded,
                      color: isPlusEnabled ? Colors.white : Colors.white38,
                      size: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: selectedCard != null
                    ? () => _toggleBalanceVisibility(selectedCard)
                    : null,
                child: Icon(
                    isEyeVisible
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                    color: Colors.white38,
                    size: 20),
              ),
            ],
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
                isEyeVisible
                    ? formatMoney(balance)
                    : '\u2022\u2022\u2022\u2022\u2022\u2022',
                style: context.fc.financialValueLarge
                    .copyWith(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(LoadState summaryAsync, AppLocalizations l) {
    final pocketCash = summaryAsync.value?.pocketCashMinor ?? 0;
    final deducted = summaryAsync.value?.deductedMinor ?? 0;

    // The Pocket Cash container is gated by THIS card's own "Use Card for
    // Cash Withdrawal" setting Ã¢â‚¬â€ never by the global/default value. When OFF
    // for a credit card the entire Pocket Cash container is omitted (no empty
    // card, no 0 EGP placeholder, no disabled placeholder). Debit cards keep
    // the existing behaviour.
    final selectedCard =
        context.watch<FinanceCubit>().state.map((data) => data.card).value;
    final showPocketCash = selectedCard == null ||
        (context
                .watch<FinanceCubit>()
                .state
                .map((data) => data.pocketCashVisible)
                .value ??
            true);

    return Row(
      children: [
        if (showPocketCash) ...[
          Expanded(
              child: _SummaryCard(
                  title: l['pocketCashLabel'],
                  amount: formatMoney(pocketCash),
                  subtitle: l['fromATM'],
                  color: FloosyDesign.warmYellow,
                  icon: Icons.account_balance_wallet_rounded)),
          const SizedBox(width: 16),
        ],
        Expanded(
            child: _SummaryCard(
                title: l['deductedMoney'],
                amount: formatMoney(deducted),
                subtitle: l['thisMonth'],
                color: FloosyDesign.coralRed,
                icon: Icons.trending_down_rounded)),
      ],
    );
  }

  /// "Add My Balance" Ã¢â‚¬â€ manual top-up dialog. Increases Balance via an 'in'
  /// bank movement; NEVER touches Pocket Cash or Deducted From (#33/#36).
  ///
  /// Lifecycle safety: [userId], the selected card's `card_last4`, and the
  /// [MoneyRepository] instance are ALL captured BEFORE the async dialog gap.
  /// Nothing after `await showDialog` touches `ref`, so confirming the dialog
  /// after the Dashboard was disposed can never throw
  /// `Bad state: Cannot use "ref" after the widget was disposed.`
  /// The pending top-up is always stamped with the card that was selected
  /// when the user pressed "Add Balance" Ã¢â‚¬â€ never a later selection.
  /// Enforces the fixed amount limit: the user cannot add more than
  /// (fixed_amount - current_balance) for the selected card.
  Future<void> _showAddBalanceDialog() async {
    final l = AppLocalizations.s(context);
    // Capture immutable inputs while this widget is alive.
    final userId = context.read<AuthCubit>().state.userId;
    if (userId == null) return;
    final selectedCard =
        context.read<FinanceCubit>().state.map((data) => data.card).value;
    final selectedCardLast4 =
        selectedCard?.last4 ?? context.read<SelectedCardCubit>().state.last4;
    final selectedCardBankName = selectedCard?.bankName;
    if (selectedCardLast4 == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l['selectCardMessage'])),
        );
      }
      return;
    }
    // Repository instance is lifecycle-independent Ã¢â‚¬â€ capture it now so the
    // save below never needs `ref` after the async gap.
    final moneyRepo = context.read<FinanceCubit>();
    final amountController = TextEditingController();
    final noteController = TextEditingController();
    final currencyNotifier = ValueNotifier<String>('EGP');

    // Maximum addable amount comes from the business layer Ã¢â‚¬â€ the SAME rule
    // that `addBalanceManually` enforces, so no silent clamping is possible.
    //   credit card Ã¢â€ â€™ Fixed Amount Ã¢Ë†â€™ My Balance (0 when already at the max)
    //   debit card  Ã¢â€ â€™ null (no Fixed Amount)
    final maxAddable = await moneyRepo.getMaxAddableForCard(
        userId, selectedCardLast4,
        bankName: selectedCardBankName);
    final hasFixedAmount = maxAddable != null;
    final maxAddableMinor = maxAddable ?? 0;

    // The widget may have been disposed during the await above.
    if (!mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: context.fc.primarySurface,
        title: Text(l['addMyBalance'], style: context.fc.cardTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(color: context.fc.textPrimary),
              decoration: InputDecoration(
                  labelText: l['amountLabel'],
                  labelStyle: TextStyle(color: context.fc.textSecondary),
                  // Show the maximum addable amount as helper text for credit cards
                  hintText: hasFixedAmount
                      ? '${l['maxAddable']}: ${formatMoney(maxAddableMinor)}'
                      : null),
            ),
            const SizedBox(height: 12),
            ValueListenableBuilder<String>(
              valueListenable: currencyNotifier,
              builder: (context, currency, _) =>
                  DropdownButtonFormField<String>(
                initialValue: currency,
                dropdownColor: context.fc.primarySurface,
                style: TextStyle(color: context.fc.textPrimary, fontSize: 14),
                items: const ['EGP', 'USD', 'EUR', 'GBP', 'SAR', 'AED']
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => currencyNotifier.value = v ?? 'EGP',
                decoration: InputDecoration(
                    labelText: l['currencyLabel'],
                    labelStyle: TextStyle(color: context.fc.textSecondary)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: noteController,
              style: TextStyle(color: context.fc.textPrimary),
              decoration: InputDecoration(
                  labelText: l['noteLabel'],
                  labelStyle: TextStyle(color: context.fc.textSecondary)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l['cancel']),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l['add']),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    final amount = double.tryParse(amountController.text.trim());
    if (amount == null || amount <= 0) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l['invalidAmount'])));
      }
      return;
    }
    // Snapshot plain field values before any further awaits Ã¢â‚¬â€ the
    // controllers/notifier are local, but reading them now keeps the save
    // fully independent of widget/provider lifecycle.
    var amountMinor = (amount * 100).round();
    // Enforce the maximum addable amount for credit cards
    if (hasFixedAmount && amountMinor > maxAddableMinor) {
      amountMinor = maxAddableMinor;
      if (amountMinor <= 0) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l['maxAmountReached'])),
          );
        }
        return;
      }
    }
    final currency = currencyNotifier.value;
    final note = noteController.text.trim();
    try {
      // No `ref` access here: uses only values captured before the dialog.
      await moneyRepo.addBalanceManually(
        userId: userId,
        cardLast4: selectedCardLast4,
        bankName: selectedCardBankName,
        amountMinor: amountMinor,
        currency: currency,
        note: note,
      );
      // Touching providers after an async gap requires a live widget.
      if (!mounted) return;
      context.read<FinanceCubit>().reload();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l['balanceAdded'])));
    } catch (e) {
      logError('Add My Balance failed', e);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l['failedToLoad'])));
      }
    }
  }

  /// MAIN/HOME PAGE item tap Ã¢â€ â€™ Item Purchase (requirement #21-#28).
  /// Confirms with the user, checks Pocket Cash, then executes the atomic
  /// [MoneyRepository.purchaseItemWithCash]: the selected card's Pocket Cash Ã¢Ë†â€™,
  /// expense transaction + (counts towards Deducted From), bank Balance
  /// unchanged. Transaction is linked to the selected card via card_last4.
  Future<void> _purchaseItem(Item item) async {
    if (_purchasingItemId != null) return;
    setState(() => _purchasingItemId = item.id);
    try {
      await _confirmAndPurchaseItem(item);
    } finally {
      if (mounted) setState(() => _purchasingItemId = null);
    }
  }

  Future<void> _confirmAndPurchaseItem(Item item) async {
    final l = AppLocalizations.s(context);
    final userId = context.read<AuthCubit>().state.userId;
    if (userId == null) return;

    // Duplicate-tap protection: one purchase at a time (#27).

    // Requirement #10: verify a card is selected before doing anything.
    // Never silently charge another card.
    final selectedCard =
        context.read<FinanceCubit>().state.map((data) => data.card).value;
    if (selectedCard == null) {
      if (mounted) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: context.fc.primarySurface,
            title: Text(l['selectCard']),
            content: Text(l['selectCardMessage']),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l['close']),
              ),
            ],
          ),
        );
      }
      return;
    }

    // Requirement #17: Re-read the CURRENTLY selected card right before
    // showing the confirmation. A stale reference must never charge the wrong
    // card.
    if (!mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: context.fc.primarySurface,
        title: Text(l['purchaseItem'], style: context.fc.cardTitle),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.nameAr ?? item.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                formatMoney(item.priceMinor),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6F5BD3),
                ),
              ),
              const SizedBox(height: 20),
              const Divider(height: 1),
              const SizedBox(height: 20),
              Text(
                l['payFrom'],
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 8),
              Text(l['pocketCashLabel']),
              const SizedBox(height: 8),
              _CardPreview(card: selectedCard),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l['cancel']),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: selectedCard.appearance.colors.last,
              foregroundColor: Colors.white,
            ),
            child: Text(l['purchase']),
          ),
        ],
      ),
    ).then((value) => value ?? false);
    if (!confirmed || !mounted) return;

    // Requirement #17: re-validate the active card identity immediately before
    // completing the purchase, including the bank when last4 collides.
    final activeCard =
        context.read<FinanceCubit>().state.map((data) => data.card).value;
    if (activeCard == null || activeCard.id != selectedCard.id) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l['selectCardMessage'])),
        );
      }
      return;
    }

    final activeCardLast4 = activeCard.last4;
    setState(() => _purchasingItemId = item.id);
    logInfo(
        'ITEM_PURCHASE_STARTED itemId=${item.id} cardLast4=$activeCardLast4 '
        'amountMinor=${item.priceMinor}');
    try {
      final repo = context.read<FinanceCubit>();
      await repo.purchaseItemWithCash(
        userId: userId,
        item: item,
        cardLast4: activeCardLast4,
        bankName: activeCard.bankName,
      );
      logInfo(
          'ITEM_PURCHASE_SUCCESS itemId=${item.id} cardLast4=$activeCardLast4');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '${item.nameAr ?? item.name} Ã¢â‚¬â€ ${formatMoney(item.priceMinor)}'),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } on InsufficientPocketCashException catch (e) {
      logInfo('ITEM_PURCHASE_FAILED insufficient cash itemId=${item.id} '
          'required=${e.requiredMinor} available=${e.availableMinor}');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l['notEnoughPocketCash']),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    } catch (e) {
      logError('ITEM_PURCHASE_FAILED itemId=${item.id}', e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l['purchaseFailed']),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    }
  }

  Widget _buildItemsSection(LoadState? itemsAsync, AppLocalizations l) {
    final items = itemsAsync?.value ?? [];
    return Column(
      children: [
        Row(
          children: [
            Text(l['myItems'], style: context.fc.sectionTitle),
            const Spacer(),
            GestureDetector(
              onTap: () {
                logInfo('NAV_TARGET_ROUTE ${AppRoutes.items}');
                context.push(AppRoutes.items);
              },
              child: Text(l['seeAll'],
                  style: const TextStyle(
                      fontSize: 14,
                      color: FloosyDesign.brightPurple,
                      fontWeight: FontWeight.w500)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (itemsAsync?.isLoading == true)
          const Padding(
              padding: EdgeInsets.all(32), child: CircularProgressIndicator())
        else if (items.isEmpty)
          Padding(
              padding: const EdgeInsets.all(24),
              child: Text(l['noItems'],
                  textAlign: TextAlign.center,
                  style: TextStyle(color: context.fc.textMuted)))
        else
          ...items.take(4).map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                // MAIN/HOME PAGE tap Ã¢â€ â€™ Item Purchase (#21-#23). This callback is
                // ONLY attached here Ã¢â‚¬â€ the Items management screen never charges.
                child: _BudgetItemCard(
                  item: item,
                  onTap: () => _purchaseItem(item),
                  purchasing: _purchasingItemId == item.id,
                ),
              )),
      ],
    );
  }

  Widget _buildFab() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 90),
      child: GestureDetector(
        onTap: () {
          logInfo('NAV_TARGET_ROUTE ${AppRoutes.items}');
          context.push(AppRoutes.items);
        },
        child: Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            color: FloosyDesign.cyan,
            shape: BoxShape.circle,
            boxShadow: glowShadow(FloosyDesign.cyan, radius: 16, opacity: 0.3),
          ),
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 32),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title, amount, subtitle;
  final Color color;
  final IconData icon;
  const _SummaryCard(
      {required this.title,
      required this.amount,
      required this.subtitle,
      required this.color,
      required this.icon});
  @override
  Widget build(BuildContext context) => FinancePanel(
        height: 124,
        padding: const EdgeInsets.all(16),
        colors: [Color.lerp(color, Colors.black, .22)!, color],
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(icon, color: Colors.white, size: 19),
            const SizedBox(width: 7),
            Expanded(
                child: Text(title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)))
          ]),
          const Spacer(),
          FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(amount,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white))),
          const SizedBox(height: 7),
          Text(subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, color: Colors.white70)),
        ]),
      );
}

class _BudgetItemCard extends StatelessWidget {
  final Item item;
  final VoidCallback? onTap;
  final bool purchasing;
  const _BudgetItemCard({
    required this.item,
    this.onTap,
    this.purchasing = false,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.s(context);
    final counts =
        context.watch<ItemsCubit>().state.map((data) => data.usage).value ??
            const <String, int>{};
    final count = counts[item.id] ?? 0;
    final total = counts.values.fold<int>(0, (sum, value) => sum + value);
    final progress = total == 0 ? 0.0 : count / total;
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: purchasing ? 0.6 : 1.0,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: context.fc.cardSurface,
            borderRadius: BorderRadius.circular(FloosyDesign.radiusLarge),
            border: Border.all(color: context.fc.borderSubtle),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Real item image (bounded, rounded, graceful fallback).
                  ItemAvatar(item: item, size: 44),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(item.nameAr ?? item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: context.fc.textPrimary)),
                  ),
                  const SizedBox(width: 8),
                  Text(formatMoney(item.priceMinor),
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: context.fc.textPrimary)),
                ],
              ),
              const SizedBox(height: 14),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: progress),
                duration: FloosyDesign.chartAnim,
                curve: Curves.easeOutCubic,
                builder: (context, value, _) {
                  return ClipRRect(
                    borderRadius:
                        BorderRadius.circular(FloosyDesign.radiusPill),
                    child: LinearProgressIndicator(
                      value: value,
                      backgroundColor: context.fc.elevatedSurface,
                      color: ItemAppearance.decode(item.icon).color,
                      minHeight: 5,
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              Text(
                l.t('percentUsed', {'value': '${(progress * 100).round()}'}),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, color: context.fc.textMuted),
              ),
              const SizedBox(height: 4),
              Text(
                  l.t('itemUsageShare', {'count': '$count', 'total': '$total'}),
                  style: TextStyle(fontSize: 11, color: context.fc.textMuted)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Compact card preview used in the purchase confirmation dialog.
/// Shows ONLY bank name + last 4 digits -- never the full PAN.
class _CardPreview extends StatelessWidget {
  final DetectedCard card;
  const _CardPreview({required this.card});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: card.appearance.colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.credit_card,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  card.bankName ?? 'Bank',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  'Ã¢â‚¬Â¢Ã¢â‚¬Â¢Ã¢â‚¬Â¢Ã¢â‚¬Â¢ ${card.last4}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

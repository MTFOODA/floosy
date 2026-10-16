import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/utils/money_formatter.dart';
import '../../../../data/models/item_model.dart';
import '../../../../data/models/money_model.dart';
import '../../../../data/models/detected_card_model.dart';
import '../../../../core/widgets/common/item_image.dart';
import '../../../../routing/app_router.dart';
import '../widgets/card_selector_section.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
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
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;
    final repo = ref.read(detectedCardRepositoryProvider);
    await repo.toggleCardEye(userId, card.id);
    if (!mounted) return;
    // Refresh THIS card's eye provider only.
    ref.invalidate(cardEyeVisibleProvider(card.id));
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
    final userId = ref.watch(currentUserIdProvider);
    final profileAsync = ref.watch(userProfileProvider);
    // Card-specific money figures: when a detected card is selected, My
    // Balance, Pocket Cash and Deducted Money show THAT CARD's values only
    // (scoped by card_last4). No selection Ã¢â€ â€™ explicit zeros.
    final summaryAsync = ref.watch(selectedCardMoneySummaryProvider);
    // Surface provider failures during development instead of silently
    // rendering zeros Ã¢â‚¬â€ zero must mean "calculated zero", not "error".
    ref.listen(selectedCardMoneySummaryProvider, (previous, next) {
      if (next is AsyncError) {
        logError('SELECTED_CARD_SUMMARY_FAILED', next.error);
      }
    });
    final itemsAsync =
        userId != null ? ref.watch(dashboardItemsProvider(userId)) : null;
    final userName = profileAsync.value?.fullName ?? 'there';
    return Scaffold(
      backgroundColor: context.fc.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Requirement #3: pull-to-refresh triggers an IMMEDIATE bank-SMS
            // check through the SAME central pipeline used by the 5-second
            // polling. ANR fix: scanNow() with NO fullScan Ã¢â‚¬â€ it only checks
            // messages newer than the persisted cursor, so a pull can never
            // re-read the historical inbox (that full re-read was the main
            // thread blocker behind the MIUI ANR).
            try {
              await ref.read(smsPollingServiceProvider).scanNow();
            } catch (e) {
              logError('PULL_REFRESH sms scan failed', e);
            }
            ref.invalidate(moneySummaryProvider);
            ref.invalidate(selectedCardMoneySummaryProvider);
            if (userId != null) ref.invalidate(dashboardItemsProvider(userId));
          },
          child: SingleChildScrollView(
            padding: FloosyDesign.horizontalPadding(context)
                .copyWith(top: 16, bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(userName, l),
                const SizedBox(height: 20),
                const DetectedCardsSection(),
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
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_getFormattedDate(l),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13, color: context.fc.textMuted)),
              const SizedBox(height: 4),
              Text('${l[_greetingKey()]},',
                  style:
                      TextStyle(fontSize: 15, color: context.fc.textSecondary)),
              const SizedBox(height: 2),
              Text('$userName \u{1F44B}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: context.fc.textPrimary)),
            ],
          ),
        ),
        const _HeaderButton(icon: Icons.notifications_outlined),
        const SizedBox(width: 12),
        const _HeaderButton(icon: Icons.info_outline_rounded),
      ],
    );
  }

  Widget _buildBalanceCard(AsyncValue summaryAsync, AppLocalizations l) {
    final balance = summaryAsync.value?.myBalanceMinor ?? 0;
    // The selected card drives BOTH the eye state and the "+" limit.
    final selectedCard = ref.watch(selectedCardProvider).value;

    // Per-card eye state, read from its OWN provider so toggling one card's
    // visibility never invalidates a money provider or another card.
    final isEyeVisible = selectedCard == null
        ? true
        : (ref.watch(cardEyeVisibleProvider(selectedCard.id)).value ??
            selectedCard.appearance.eyeVisible);


    // The "+" button's availability is a BUSINESS RULE read from the money
    // layer rather than recomputed here:
    //   credit card WITHOUT a Fixed Amount -> disabled (configure it first)
    //   credit card that reached its limit  -> disabled
    //   credit card with headroom           -> enabled, capped to that headroom
    //   debit card                          -> enabled (no Fixed Amount concept)
    //   no card selected                    -> disabled
    final isPlusEnabled =
        ref.watch(canAddSelectedCardBalanceProvider).value ?? false;

    return Container(
      width: double.infinity,
      height: 175,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: context.fc.balanceGradient,
        borderRadius: BorderRadius.circular(FloosyDesign.radiusXL),
        border: Border.all(color: context.fc.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(l['myBalance'],
                  style:
                      TextStyle(fontSize: 14, color: context.fc.textSecondary)),
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
                        color:
                            FloosyDesign.primaryPurple.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(10)),
                    child: Icon(
                      Icons.add_rounded,
                      color: isPlusEnabled
                          ? FloosyDesign.brightPurple
                          : context.fc.textMuted,
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
                    color: context.fc.textMuted,
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
                style: context.fc.financialValueLarge),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(AsyncValue summaryAsync, AppLocalizations l) {
    final pocketCash = summaryAsync.value?.pocketCashMinor ?? 0;
    final deducted = summaryAsync.value?.deductedMinor ?? 0;

    // The Pocket Cash container is gated by THIS card's own "Use Card for
    // Cash Withdrawal" setting Ã¢â‚¬â€ never by the global/default value. When OFF
    // for a credit card the entire Pocket Cash container is omitted (no empty
    // card, no 0 EGP placeholder, no disabled placeholder). Debit cards keep
    // the existing behaviour.
    final selectedCard = ref.watch(selectedCardProvider).value;
    final showPocketCash = selectedCard == null ||
        (ref.watch(cardPocketCashVisibleProvider(selectedCard.last4)).value ??
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
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;
    final selectedCard = ref.read(selectedCardProvider).value;
    final selectedCardLast4 =
        selectedCard?.last4 ?? ref.read(selectedCardLast4Provider);
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
    final moneyRepo = ref.read(moneyRepositoryProvider);
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
      ref.invalidate(selectedCardMoneySummaryProvider);
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
  /// [MoneyRepository.purchaseItemWithCard]: the selected card's Pocket Cash Ã¢Ë†â€™,
  /// expense transaction + (counts towards Deducted From), bank Balance
  /// unchanged. Transaction is linked to the selected card via card_last4.
  Future<void> _purchaseItem(Item item) async {
    final l = AppLocalizations.s(context);
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;

    // Duplicate-tap protection: one purchase at a time (#27).
    if (_purchasingItemId != null) {
      logInfo('ITEM_PURCHASE_DUPLICATE_BLOCKED itemId=${item.id}');
      return;
    }

    // Requirement #10: verify a card is selected before doing anything.
    // Never silently charge another card.
    final selectedCard = ref.read(selectedCardProvider).value;
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
    final activeCard = ref.read(selectedCardProvider).value;
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
      final repo = ref.read(moneyRepositoryProvider);
      await repo.purchaseItemWithCard(
        userId: userId,
        item: item,
        cardLast4: activeCardLast4,
        bankName: activeCard.bankName,
      );
      ref.invalidate(selectedCardMoneySummaryProvider);
      ref.invalidate(dashboardItemsProvider(userId));
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
    } finally {
      if (mounted) setState(() => _purchasingItemId = null);
    }
  }

  Widget _buildItemsSection(AsyncValue? itemsAsync, AppLocalizations l) {
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

class _HeaderButton extends StatelessWidget {
  final IconData icon;
  const _HeaderButton({required this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: context.fc.elevatedSurface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.fc.borderSubtle),
      ),
      child: Icon(icon, color: context.fc.textSecondary, size: 22),
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
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.fc.primarySurface,
        borderRadius: BorderRadius.circular(FloosyDesign.radiusLarge),
        border: Border.all(color: context.fc.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 20)),
          const SizedBox(height: 12),
          Text(title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14, color: context.fc.textSecondary)),
          const SizedBox(height: 4),
          FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(amount,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: context.fc.textPrimary))),
          const SizedBox(height: 4),
          Text(subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12, color: context.fc.textMuted)),
        ],
      ),
    );
  }
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
    // Real render/progress value for this item Ã¢â‚¬â€ computed from its price and
    // budget spread, animated from zero once. Never removed/zeroed.
    final price = item.priceMinor / 100;
    final budget = price * 1.2;
    final progress = (price / budget).clamp(0.0, 1.0);
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
                  FloosyItemImage(
                    imageUrl: item.imageUrl,
                    width: 42,
                    height: 42,
                    radius: 12,
                    fallback: Container(
                      color: context.fc.elevatedSurface,
                      child: const Icon(Icons.shopping_bag_outlined,
                          color: FloosyDesign.textSecondary, size: 20),
                    ),
                  ),
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
                      color: FloosyDesign.primaryPurple,
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

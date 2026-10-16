import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../data/models/detected_card_model.dart';
import '../../../../routing/app_router.dart';
import 'small_detected_card.dart';

/// Detected cards section for the Dashboard.
/// Displays small cards for each detected bank card with dynamic layout.
class DetectedCardsSection extends ConsumerWidget {
  const DetectedCardsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.s(context);
    final cardsAsync = ref.watch(detectedCardsProvider);
    final selectedLast4 = ref.watch(selectedCardLast4Provider);

    // Selection reconciliation (lifecycle-safe: ref.listen callbacks run
    // after the build phase). The persisted notifier is the ONE source of
    // truth; [SelectedCardNotifier.reconcile] decides:
    //   * no saved selection ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ select the FIRST detected card
    //   * saved card_last4 no longer exists ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ fall back to the first card
    //   * valid saved selection ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ left untouched (user's choice wins)
    ref.listen(detectedCardsProvider, (previous, next) {
      if (next is! AsyncData) return;
      final cards = next.value;
      if (cards == null) return;
      final notifier = ref.read(selectedCardNotifierProvider.notifier);
      notifier.reconcileCards(cards);
    });

    return cardsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (cards) {
        if (cards.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l['yourCards'],
                  style: context.fc.sectionTitle.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      GoRouter.of(context).push(AppRoutes.detectedCards),
                  child: Text(
                    l['manageCards'],
                    style: const TextStyle(
                      color: FloosyDesign.primaryPurple,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildCardsLayout(context, ref, l, cards, selectedLast4),
          ],
        );
      },
    );
  }

  Widget _buildSingleCard(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l,
    DetectedCard card,
    String? selectedLast4,
  ) {
    final isSelected = _isSelected(ref, card, selectedLast4);
    return _buildCardItem(context, ref, l, card, isSelected, scale: 1.0);
  }

  /// Dynamically adapts the layout to the actual number of detected cards:
  /// 1 card -> full-width, 2 -> side by side, 3 -> scaled single row,
  /// 4 -> compact 2x2 grid, 5+ -> horizontally scrollable row.
  Widget _buildCardsLayout(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l,
    List<DetectedCard> cards,
    String? selectedLast4,
  ) {
    if (cards.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            l['noCardsDetected'],
            style: TextStyle(
              color: context.fc.textSecondary,
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    if (cards.length == 1) {
      return _buildSingleCard(
        context,
        ref,
        l,
        cards.first,
        selectedLast4,
      );
    } else if (cards.length == 2) {
      return _buildTwoCards(
        context,
        ref,
        l,
        cards,
        selectedLast4,
      );
    } else if (cards.length == 3) {
      return _buildThreeCards(
        context,
        ref,
        l,
        cards,
        selectedLast4,
      );
    } else if (cards.length == 4) {
      return _buildFourCards(
        context,
        ref,
        l,
        cards,
        selectedLast4,
      );
    } else {
      return _buildScrollableCards(
        context,
        ref,
        l,
        cards,
        selectedLast4,
      );
    }
  }

  Widget _buildTwoCards(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l,
    List<DetectedCard> cards,
    String? selectedLast4,
  ) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: cards.map((card) {
          final isSelected = _isSelected(ref, card, selectedLast4);
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child:
                  _buildCardItem(context, ref, l, card, isSelected, scale: 1.0),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildThreeCards(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l,
    List<DetectedCard> cards,
    String? selectedLast4,
  ) {
    return Row(
      children: cards.map((card) {
        final isSelected = _isSelected(ref, card, selectedLast4);
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child:
                _buildCardItem(context, ref, l, card, isSelected, scale: 0.82),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFourCards(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l,
    List<DetectedCard> cards,
    String? selectedLast4,
  ) {
    return Column(
      children: [
        Row(
          children: cards.take(2).map((card) {
            final isSelected = _isSelected(ref, card, selectedLast4);
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: _buildCardItem(context, ref, l, card, isSelected,
                    scale: 0.7),
              ),
            );
          }).toList(),
        ),
        Row(
          children: cards.skip(2).take(2).map((card) {
            final isSelected = _isSelected(ref, card, selectedLast4);
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: _buildCardItem(context, ref, l, card, isSelected,
                    scale: 0.7),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildScrollableCards(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l,
    List<DetectedCard> cards,
    String? selectedLast4,
  ) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: cards.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final card = cards[index];
          final isSelected = _isSelected(ref, card, selectedLast4);
          return _buildCardItem(context, ref, l, card, isSelected, scale: 0.8);
        },
      ),
    );
  }

  bool _isSelected(WidgetRef ref, DetectedCard card, String? selectedLast4) {
    final selectedBankName = ref.read(selectedCardBankNameProvider);
    return card.last4 == selectedLast4 &&
        (selectedBankName == null || card.bankName == selectedBankName);
  }

  Widget _buildCardItem(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l,
    DetectedCard card,
    bool isSelected, {
    double scale = 1.0,
  }) {
    return Transform.scale(
      scale: scale,
      child: SmallDetectedCard(
        card: card,
        isSelected: isSelected,
        onTap: () {
          ref
              .read(selectedCardNotifierProvider.notifier)
              .setSelectedCard(card.last4, bankName: card.bankName);
        },
      ),
    );
  }
}

import '../../../../core/theme/card_appearance_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:floosy/features/settings/presentation/cubit/cards_cubit.dart';
import 'package:floosy/core/localization/preferences_cubit.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../domain/entities/detected_card_model.dart';
import '../../../../domain/services/card_ownership.dart';
import '../../../../routing/app_routes.dart';
import 'small_detected_card.dart';

/// Detected cards section for the Dashboard.
/// Displays small cards for each detected bank card with dynamic layout.
class DetectedCardsSection extends StatelessWidget {
  const DetectedCardsSection({super.key, this.compact = false});
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.s(context);
    final cardsAsync = context.watch<CardsCubit>().state;
    final selectedLast4 = context.watch<SelectedCardCubit>().state.last4;

    return cardsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (cards) {
        if (cards.isEmpty) return const SizedBox.shrink();

        if (compact) {
          return Row(children: [
            Expanded(
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(children: [
                      for (final card in cards)
                        Padding(
                            padding: const EdgeInsetsDirectional.only(end: 8),
                            child: ChoiceChip(
                              selected:
                                  _isSelected(context, card, selectedLast4),
                              selectedColor: card.appearance.colors.last
                                  .withValues(alpha: .22),
                              avatar: Icon(Icons.credit_card_rounded,
                                  size: 17, color: card.appearance.colors.last),
                              label: Text(
                                  '${card.bankName ?? l['yourCards']}  •• ${card.last4}',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: context.fc.textPrimary)),
                              onSelected: (_) => context
                                  .read<SelectedCardCubit>()
                                  .setSelectedCard(card.last4,
                                      bankName: card.bankName),
                            )),
                    ]))),
            IconButton(
                tooltip: l['manageCards'],
                onPressed: () => context.push(AppRoutes.detectedCards),
                icon: const Icon(Icons.tune_rounded, size: 20)),
          ]);
        }

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
            _buildCardsLayout(context, l, cards, selectedLast4),
          ],
        );
      },
    );
  }

  Widget _buildSingleCard(
    BuildContext context,
    AppLocalizations l,
    DetectedCard card,
    String? selectedLast4,
  ) {
    final isSelected = _isSelected(context, card, selectedLast4);
    return _buildCardItem(context, l, card, isSelected, scale: 1.0);
  }

  /// Dynamically adapts the layout to the actual number of detected cards:
  /// 1 card -> full-width, 2 -> side by side, 3 -> scaled single row,
  /// 4 -> compact 2x2 grid, 5+ -> horizontally scrollable row.
  Widget _buildCardsLayout(
    BuildContext context,
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
        l,
        cards.first,
        selectedLast4,
      );
    } else if (cards.length == 2) {
      return _buildTwoCards(
        context,
        l,
        cards,
        selectedLast4,
      );
    } else if (cards.length == 3) {
      return _buildThreeCards(
        context,
        l,
        cards,
        selectedLast4,
      );
    } else if (cards.length == 4) {
      return _buildFourCards(
        context,
        l,
        cards,
        selectedLast4,
      );
    } else {
      return _buildScrollableCards(
        context,
        l,
        cards,
        selectedLast4,
      );
    }
  }

  Widget _buildTwoCards(
    BuildContext context,
    AppLocalizations l,
    List<DetectedCard> cards,
    String? selectedLast4,
  ) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: cards.map((card) {
          final isSelected = _isSelected(context, card, selectedLast4);
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: _buildCardItem(context, l, card, isSelected, scale: 1.0),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildThreeCards(
    BuildContext context,
    AppLocalizations l,
    List<DetectedCard> cards,
    String? selectedLast4,
  ) {
    return Row(
      children: cards.map((card) {
        final isSelected = _isSelected(context, card, selectedLast4);
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: _buildCardItem(context, l, card, isSelected, scale: 0.82),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFourCards(
    BuildContext context,
    AppLocalizations l,
    List<DetectedCard> cards,
    String? selectedLast4,
  ) {
    return Column(
      children: [
        Row(
          children: cards.take(2).map((card) {
            final isSelected = _isSelected(context, card, selectedLast4);
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: _buildCardItem(context, l, card, isSelected, scale: 0.7),
              ),
            );
          }).toList(),
        ),
        Row(
          children: cards.skip(2).take(2).map((card) {
            final isSelected = _isSelected(context, card, selectedLast4);
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: _buildCardItem(context, l, card, isSelected, scale: 0.7),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildScrollableCards(
    BuildContext context,
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
          final isSelected = _isSelected(context, card, selectedLast4);
          return _buildCardItem(context, l, card, isSelected, scale: 0.8);
        },
      ),
    );
  }

  bool _isSelected(
      BuildContext context, DetectedCard card, String? selectedLast4) {
    final selection = context.read<SelectedCardCubit>().state;
    if (selection.requiresChoice) return false;
    final selectedBankName = selection.bankName;
    final selectedBankIdentity = normalizeBankIdentity(selectedBankName);
    return card.last4 == selectedLast4 &&
        (selectedBankIdentity == null ||
            normalizeBankIdentity(card.bankName) == selectedBankIdentity);
  }

  Widget _buildCardItem(
    BuildContext context,
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
          context
              .read<SelectedCardCubit>()
              .setSelectedCard(card.last4, bankName: card.bankName);
        },
      ),
    );
  }
}

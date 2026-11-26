import '../../../../core/widgets/common/bank_logo.dart';
import '../../../../domain/entities/bank_directory.dart';
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
    final selection = context.watch<SelectedCardCubit>().state;

    return cardsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (cards) {
        if (cards.isEmpty) return const SizedBox.shrink();

        if (compact) {
          return Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final card in cards)
                        Padding(
                          padding: const EdgeInsetsDirectional.only(end: 8),
                          child: ChoiceChip(
                            showCheckmark: false,
                            selected: _isSelected(selection, card),
                            selectedColor: card.appearance.colors.last
                                .withValues(alpha: .22),
                            avatar: BankLogo(bankName: card.bankName, size: 22),
                            label: Text(
                              '${card.bankName == null ? l['yourCards'] : BankCatalog.displayName(card.bankName, arabic: l.isArabic)}  •• ${card.last4}',
                              style: TextStyle(
                                fontSize: 12,
                                color: context.fc.textPrimary,
                              ),
                            ),
                            onSelected: (_) => context
                                .read<SelectedCardCubit>()
                                .setSelectedCard(
                                  card.last4,
                                  bankName: card.bankName,
                                ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              IconButton(
                tooltip: l['manageCards'],
                onPressed: () => context.push(AppRoutes.detectedCards),
                icon: const Icon(Icons.tune_rounded, size: 20),
              ),
            ],
          );
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
            LayoutBuilder(
              builder: (context, constraints) {
                final width = cards.length == 1
                    ? constraints.maxWidth.clamp(156.0, 220.0).toDouble()
                    : (constraints.maxWidth * .44)
                          .clamp(156.0, 224.0)
                          .toDouble();
                return SizedBox(
                  height: width / 1.586 + 24,
                  child: ListView.separated(
                    primary: false,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 12,
                    ),
                    itemCount: cards.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final card = cards[index];
                      return SizedBox(
                        width: width,
                        child: SmallDetectedCard(
                          key: ValueKey(card.id),
                          card: card,
                          isSelected: _isSelected(selection, card),
                          onTap: () =>
                              context.read<SelectedCardCubit>().setSelectedCard(
                                card.last4,
                                bankName: card.bankName,
                              ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  bool _isSelected(CardSelection selection, DetectedCard card) {
    if (selection.requiresChoice) return false;
    final selectedBankName = selection.bankName;
    final selectedBankIdentity = normalizeBankIdentity(selectedBankName);
    return card.last4 == selection.last4 &&
        (selectedBankIdentity == null ||
            normalizeBankIdentity(card.bankName) == selectedBankIdentity);
  }
}

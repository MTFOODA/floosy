import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../data/models/detected_card_model.dart';
import '../widgets/detected_bank_card.dart';
import '../widgets/card_customization_sheet.dart';

/// "Detected Cards" page (requirement #6). Accessible from Settings.
class DetectedCardsScreen extends ConsumerWidget {
  const DetectedCardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.s(context);
    final cardsAsync = ref.watch(detectedCardsProvider);

    return Scaffold(
      backgroundColor: context.fc.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: FloosyDesign.horizontalPadding(context)
              .copyWith(top: 16, bottom: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button — uses GoRouter for consistent back navigation.
              // This route is pushed ON TOP of the Settings tab, so pop() returns
              // to Settings. It does NOT switch between bottom-nav tabs.
              GestureDetector(
                onTap: () {
                  // Use GoRouter pop if this is a pushed route; otherwise stay on
                  // Settings (don't switch tabs via back).
                  if (context.canPop()) {
                    context.pop();
                  }
                  // If canPop is false, we're already on a root tab — do nothing.
                },
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: context.fc.elevatedSurface,
                    shape: BoxShape.circle,
                    border: Border.all(color: context.fc.borderSubtle),
                  ),
                  child: Icon(Icons.arrow_back_rounded,
                      color: context.fc.textPrimary, size: 20),
                ),
              ),
              const SizedBox(height: 20),
              Text(l['detectedCards'], style: context.fc.pageTitle),
              const SizedBox(height: 6),
              Text(l['detectedCardsSubtitle'], style: context.fc.bodyText),
              const SizedBox(height: 24),
              cardsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => _ErrorView(),
                data: (cards) => _buildContent(context, ref, l, cards),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, AppLocalizations l,
      List<DetectedCard> cards) {
    if (cards.isEmpty) {
      return _EmptyCardsView(l: l);
    }

    // Card count (requirement #8).
    final countLabel = l.t('cardsDetected', {'count': cards.length.toString()});

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          countLabel,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: FloosyDesign.primaryPurple,
          ),
        ),
        const SizedBox(height: 16),
        // Card list — each card is tappable for customization.
        ...cards.map((card) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                children: [
                  DetectedBankCard(
                    card: card,
                    onEdit: () => _openCustomization(context, ref, card),
                    showEye: false,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${card.bankName ?? 'Bank'} •••• ${card.last4}',
                    style: context.fc.bodyTextSmall,
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Future<void> _openCustomization(
      BuildContext context, WidgetRef ref, DetectedCard card) async {
    final repo = ref.read(detectedCardRepositoryProvider);
    final changed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CardCustomizationSheet(card: card, repository: repo),
    );
    if (changed == true) {
      ref.invalidate(detectedCardsProvider);
    }
  }
}

class _EmptyCardsView extends StatelessWidget {
  final AppLocalizations l;
  const _EmptyCardsView({required this.l});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 40),
          // Minimal bank-card illustration.
          Container(
            width: 120,
            height: 76,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  context.fc.textMuted.withValues(alpha: 0.25),
                  context.fc.textMuted.withValues(alpha: 0.12),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.credit_card_outlined,
                color: context.fc.textMuted.withValues(alpha: 0.5), size: 32),
          ),
          const SizedBox(height: 20),
          Text(l['noCardsDetected'], style: context.fc.sectionTitle),
          const SizedBox(height: 8),
          Text(
            l['noCardsDetectedSubtitle'],
            textAlign: TextAlign.center,
            style: context.fc.bodyText,
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 40),
          Icon(Icons.error_outline,
              size: 48, color: FloosyDesign.negative.withValues(alpha: 0.7)),
          const SizedBox(height: 12),
          Text('Something went wrong', style: context.fc.bodyText),
        ],
      ),
    );
  }
}

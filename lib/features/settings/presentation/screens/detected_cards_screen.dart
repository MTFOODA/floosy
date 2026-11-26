import 'package:flutter/material.dart';
import '../../../../app/app_runtime.dart';
import '../../../../domain/usecases/remove_empty_duplicate_card.dart';
import '../../../../domain/entities/bank_directory.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:floosy/features/settings/presentation/cubit/cards_cubit.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../domain/entities/detected_card_model.dart';
import '../widgets/detected_bank_card.dart';
import '../widgets/card_customization_sheet.dart';
import '../../../dashboard/presentation/cubit/finance_cubit.dart';
import '../../../dashboard/presentation/cubit/salary_plan_cubit.dart';
import '../../../dashboard/presentation/widgets/salary_setup_dialog.dart';

/// "Detected Cards" page (requirement #6). Accessible from Settings.
class DetectedCardsScreen extends StatelessWidget {
  const DetectedCardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.s(context);
    final cardsAsync = context.watch<CardsCubit>().state;

    return Scaffold(
      backgroundColor: context.fc.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: FloosyDesign.horizontalPadding(
            context,
          ).copyWith(top: 16, bottom: 120),
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
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: context.fc.textPrimary,
                    size: 20,
                  ),
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
                data: (cards) => _buildContent(context, l, cards),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    AppLocalizations l,
    List<DetectedCard> cards,
  ) {
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
        ...cards.map(
          (card) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              children: [
                DetectedBankCard(
                  card: card,
                  onEdit: () => _openCustomization(context, card),
                  showEye: false,
                ),
                if (!card.isCreditCard) ...[
                  const SizedBox(height: 8),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: OutlinedButton.icon(
                      onPressed: () => _openSalarySetup(context, card),
                      icon: const Icon(Icons.payments_outlined, size: 18),
                      label: Text(l['cardBalanceAndSalary']),
                    ),
                  ),
                ],
                if (RemoveEmptyDuplicateCard.isNewerDuplicate(card, cards))
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: TextButton.icon(
                      onPressed: () =>
                          _confirmDuplicateRemoval(context, l, card),
                      icon: const Icon(Icons.delete_outline, size: 18),
                      label: Text(l['removeDuplicateCard']),
                    ),
                  ),
                const SizedBox(height: 6),
                Text(
                  '${card.bankName == null ? AppLocalizations.s(context)['bankUnknown'] : BankCatalog.displayName(card.bankName, arabic: AppLocalizations.s(context).isArabic)} •••• ${card.last4}',
                  style: context.fc.bodyTextSmall,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _confirmDuplicateRemoval(
    BuildContext context,
    AppLocalizations l,
    DetectedCard card,
  ) async {
    final runtime = context.read<AppRuntime>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l['removeDuplicateCard']),
        content: Text(
          l.t('removeDuplicateCardBody', {
            'bank': BankCatalog.displayName(card.bankName, arabic: l.isArabic),
            'last4': card.last4,
          }),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l['cancel']),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l['delete']),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    try {
      final removed = await runtime.removeEmptyDuplicateCard(card.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l[removed ? 'duplicateCardRemoved' : 'duplicateCardHasData'],
            ),
          ),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l['saveFailed'])));
      }
    }
  }

  Future<void> _openCustomization(
    BuildContext context,
    DetectedCard card,
  ) async {
    final repo = context.read<CardsCubit>();
    final changed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CardCustomizationSheet(card: card, repository: repo),
    );
    if (changed == true) {
      repo.reload();
    }
  }

  Future<void> _openSalarySetup(BuildContext context, DetectedCard card) async {
    if (card.isCreditCard) return;
    final cards = context.read<CardsCubit>();
    final finance = context.read<FinanceCubit>();
    final salary = context.read<SalaryPlanCubit>();
    try {
      final currentBalance = await finance.currentBalanceForCard(card);
      final existing = await salary.planFor(card);
      if (!context.mounted || ModalRoute.of(context)?.isCurrent != true) return;
      await showSalarySetupDialog(
        context,
        currentBalanceMinor: currentBalance,
        existing: existing,
        onSave: (balance, amount, day, detect) async {
          final fresh = await cards.getCardById(card.userId, card.id);
          if (fresh == null || fresh.isCreditCard) {
            throw StateError('The debit card is no longer available');
          }
          if (balance != currentBalance) {
            await finance.setCurrentBalanceForCard(
              userId: fresh.userId,
              cardLast4: fresh.last4,
              bankName: fresh.bankName,
              targetBalanceMinor: balance,
            );
          }
          if (amount != null) {
            await salary.configure(
              card: fresh,
              monthlySalaryMinor: amount,
              cycleStartDay: day,
              startingBalanceMinor: balance,
              autoDetectSalary: detect,
            );
          }
        },
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.s(context)['errorLoading'])),
      );
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
            child: Icon(
              Icons.credit_card_outlined,
              color: context.fc.textMuted.withValues(alpha: 0.5),
              size: 32,
            ),
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
          Icon(
            Icons.error_outline,
            size: 48,
            color: FloosyDesign.negative.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.s(context)['errorLoading'],
            style: context.fc.bodyText,
          ),
        ],
      ),
    );
  }
}

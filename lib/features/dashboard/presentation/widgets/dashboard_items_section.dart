import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/providers.dart';
import '../../../../../core/localization/app_localizations.dart';
import '../../../../../core/utils/money_formatter.dart';
import '../../../../../core/widgets/common/item_image.dart';
import '../../../../../data/models/item_model.dart';
import '../../../../../data/models/money_model.dart';

/// Monthly usage count (quantity) for one item — real recorded transactions.
final itemMonthlyUsageProvider =
    FutureProvider.autoDispose.family<int, String>((ref, itemId) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return 0;
  final now = DateTime.now();
  final local = ref.watch(moneyLocalDataSourceProvider);
  final usages =
      await local.getItemUsages(userId, year: now.year, month: now.month);
  return usages
      .where((u) => u.itemId == itemId)
      .fold<int>(0, (sum, u) => sum + u.quantity);
});

/// High-usage flag computed from the user's real history baseline.
final itemHighFrequencyProvider =
    FutureProvider.autoDispose.family<bool, String>((ref, itemId) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return false;
  final service = ref.watch(highFrequencyServiceProvider);
  return service.isHighFrequency(userId: userId, itemId: itemId);
});

/// The user's reusable items on the home screen.
///
/// * One tap on an item immediately records a REAL cash expense:
///     Pocket Cash -= price, Deducted Money += price, item counter += 1.
/// * Each item shows its month usage counter.
/// * Discretionary items used unusually frequently this month get a red
///   high-usage indicator (never applied to fixed recurring expenses —
///   those live in the budgets/recurring screens).
class DashboardItemsSection extends ConsumerStatefulWidget {
  final List<Item> items;

  const DashboardItemsSection({super.key, required this.items});

  @override
  ConsumerState<DashboardItemsSection> createState() =>
      _DashboardItemsSectionState();
}

class _DashboardItemsSectionState extends ConsumerState<DashboardItemsSection> {
  bool _isProcessing = false;

  Future<void> _tapItem(Item item) async {
    if (_isProcessing) return;
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;
    final l = AppLocalizations.s(context);

    // Check if a card is selected
    final selectedCardLast4 = ref.read(selectedCardLast4Provider);
    if (selectedCardLast4 == null) {
      if (mounted) {
        // Requirement #10: never silently charge another card — ask the user
        // to select a detected card first.
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
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

    // Show purchase confirmation dialog first
    final confirmed = await _showPurchaseConfirmation(item, selectedCardLast4);
    if (!confirmed || !mounted) return;

    setState(() => _isProcessing = true);
    try {
      await ref.read(moneyRepositoryProvider).purchaseItemWithCard(
            userId: userId,
            item: item,
            cardLast4: selectedCardLast4,
          );
      // Refresh CARD-SPECIFIC money figures + item counters
      ref.invalidate(selectedCardMoneySummaryProvider);
      ref.invalidate(dashboardItemsProvider(userId));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '${item.nameAr ?? item.name} — ${formatMoney(item.priceMinor)}'),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } on InsufficientPocketCashException {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l['notEnoughPocketCash']),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l['error']),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.s(context);
    if (widget.items.isEmpty) {
      return _EmptyItemsCard(message: l['noItems'], sub: l['noItemsSubtitle']);
    }
    return _ItemsGrid(
        items: widget.items, isProcessing: _isProcessing, onTap: _tapItem);
  }

  Future<bool> _showPurchaseConfirmation(Item item, String cardLast4) async {
    final l = AppLocalizations.s(context);
    // Re-read the CURRENTLY selected card right before showing the dialog —
    // requirement #17/#18: a stale reference must never charge the wrong
    // card, and rapid double-taps are blocked by [_isProcessing].
    final selectedCard = ref.read(selectedCardProvider).value;

    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l['purchaseItem']),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Item details
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
              // Card info — ONLY bank name + last 4 digits (never full PAN).
              Text(
                l['payFrom'],
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: selectedCard?.appearance.colors ??
                        [
                          const Color(0xFF6F5BD3),
                          const Color(0xFF8A78E8),
                        ],
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
                            selectedCard?.bankName ?? 'Bank',
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
                            '•••• ${selectedCard?.last4 ?? '----'}',
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
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l['cancel']),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6F5BD3),
              foregroundColor: Colors.white,
            ),
            child: Text(l['purchase']),
          ),
        ],
      ),
    ).then((value) => value ?? false);
  }
}

/// Provider wrapping the active items for a user (dashboard scoped).
final dashboardItemsProvider =
    FutureProvider.autoDispose.family<List<Item>, String>((ref, userId) async {
  return ref.watch(itemRepositoryProvider).getActiveItems(userId);
});

class _EmptyItemsCard extends StatelessWidget {
  final String message;
  final String sub;
  const _EmptyItemsCard({required this.message, required this.sub});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(Icons.inventory_2_outlined, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(message,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(
              sub,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemsGrid extends ConsumerWidget {
  final List<Item> items;
  final bool isProcessing;
  final void Function(Item) onTap;

  const _ItemsGrid({
    required this.items,
    required this.isProcessing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.s(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l['activeItems'],
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            // Responsive: 4 columns on wide (Windows/desktop), 3 on phones.
            final crossAxisCount = constraints.maxWidth > 600 ? 4 : 3;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                // Tall aspect ratio so the image area dominates the card
                // (image on top, then name + price + counter below).
                childAspectRatio: 0.72,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final usage =
                    ref.watch(itemMonthlyUsageProvider(item.id)).value ?? 0;
                final isHigh =
                    ref.watch(itemHighFrequencyProvider(item.id)).value == true;
                return _ItemCard(
                  item: item,
                  usageCount: usage,
                  isHighFrequency: isHigh,
                  isProcessing: isProcessing,
                  onTap: () => onTap(item),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _ItemCard extends StatelessWidget {
  final Item item;
  final int usageCount;
  final bool isHighFrequency;
  final bool isProcessing;
  final VoidCallback onTap;

  const _ItemCard({
    required this.item,
    required this.usageCount,
    required this.isHighFrequency,
    required this.isProcessing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: isProcessing ? null : onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.dividerColor),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image area fills all vertical space above the meta row so
                // the card reads as a real shortcut/icon tile. The image is
                // never stretched — BoxFit.cover preserves its proportions.
                // FloosyItemImage resolves the stored reference to a signed
                // URL (the private `item-images` bucket 400s plain public
                // URLs) and falls back to the icon when there is no image or
                // the network load fails.
                Expanded(
                  child: Container(
                    width: double.infinity,
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: FloosyItemImage(
                      imageUrl: item.imageUrl,
                      fit: BoxFit.cover,
                      loadingBackground:
                          theme.colorScheme.surfaceContainerHighest,
                      fallback: _FallbackIcon(item: item),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        item.nameAr ?? item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              formatMoney(item.priceMinor),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[600]),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '× $usageCount',
                              style: const TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (isHighFrequency)
              const Positioned(top: 6, right: 6, child: _RedDot()),
          ],
        ),
      ),
    );
  }
}

class _FallbackIcon extends StatelessWidget {
  final Item item;

  const _FallbackIcon({required this.item});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        _iconDataFor(item.icon),
        size: 36,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

/// Maps the item's icon code to a Material icon.
IconData _iconDataFor(String? icon) {
  switch (icon) {
    case 'water':
      return Icons.water_drop;
    case 'coffee':
      return Icons.local_cafe;
    case 'food':
      return Icons.lunch_dining;
    case 'snack':
      return Icons.fastfood;
    default:
      return Icons.local_drink;
  }
}

class _RedDot extends StatelessWidget {
  const _RedDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: 14,
      decoration: const BoxDecoration(
        color: Color(0xFFEF4444),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.priority_high, size: 10, color: Colors.white),
    );
  }
}

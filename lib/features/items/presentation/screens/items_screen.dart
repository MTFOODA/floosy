import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/providers.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/utils/money_formatter.dart';
import '../../../../data/models/item_model.dart';
import '../../../../data/services/item_image_service.dart';
import '../../../../core/widgets/common/item_image.dart';
import '../../../../routing/app_router.dart';

/// Item management — lives INSIDE Settings per product spec.
///
/// Add / Edit / Disable-Enable / Delete items with name, price and image.
/// Images are uploaded to the Supabase `item-images` bucket (user-isolated
/// folder). Deleting asks first; archiving is preferred so history stays.
class ItemsScreen extends ConsumerStatefulWidget {
  const ItemsScreen({super.key});

  @override
  ConsumerState<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends ConsumerState<ItemsScreen> {
  @override
  Widget build(BuildContext context) {
    final userId = ref.watch(currentUserIdProvider);
    final l = AppLocalizations.s(context);

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l['activeItems'])),
        body: Center(child: Text(l['error'])),
      );
    }

    final itemsAsync = ref.watch(allItemsProvider(userId));

    return Scaffold(
      appBar: AppBar(
        title: Text(l['activeItems']),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            logInfo('NAV_BACK items → previous route');
            context.canPop() ? context.pop() : context.go(AppRoutes.settings);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showItemDialog(),
        icon: const Icon(Icons.add),
        label: Text(l['addItem']),
      ),
      body: itemsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l['failedToLoad']),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => ref.invalidate(allItemsProvider(userId)),
                child: Text(l['retry']),
              ),
            ],
          ),
        ),
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.local_mall_outlined,
                      size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(l['noItems'],
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text(
                    l['noItemsSubtitle'],
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(allItemsProvider(userId));
              ref.invalidate(dashboardItemsProvider(userId));
            },
            child: LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
                // Archived items are "deleted" from the user's perspective —
                // never shown in Manage Items, matching Home.
                final visible = items.where((i) => !i.isArchived).toList();
                final horizontalPad = constraints.maxWidth < 360 ? 24.0 : 32.0;
                final cardWidth = (constraints.maxWidth -
                        horizontalPad -
                        12 * (crossAxisCount - 1)) /
                    crossAxisCount;
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    // Extent scales with card width so image + name + price
                    // always fit — no dead space, no overflow at 320-430px.
                    mainAxisExtent: (cardWidth * 1.05).clamp(150.0, 200.0),
                  ),
                  itemCount: visible.length,
                  itemBuilder: (context, index) => _ItemManagementCard(
                    item: visible[index],
                    onEdit: () => _showItemDialog(visible[index]),
                    onToggleActive: () => _toggleActive(visible[index]),
                    onDelete: () => _deleteItem(visible[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _showItemDialog([Item? existing]) async {
    final l = AppLocalizations.s(context);
    final nameController = TextEditingController(text: existing?.name ?? '');
    final nameArController =
        TextEditingController(text: existing?.nameAr ?? '');
    final priceController = TextEditingController(
      text: existing == null
          ? ''
          : (existing.priceMinor / 100)
              .toStringAsFixed(existing.priceMinor % 100 == 0 ? 0 : 2),
    );
    String? imageUrl = existing?.imageUrl;

    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(existing == null ? l['addItem'] : l['editItem']),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ImagePickerTile(
                  imageUrl: imageUrl,
                  onPicked: (path) => setDialogState(() => imageUrl = path),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: l['itemName']),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: nameArController,
                  decoration: InputDecoration(labelText: l['itemNameAr']),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: priceController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: l['itemPrice']),
                ),
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
              child: Text(existing == null ? l['add'] : l['save']),
            ),
          ],
        ),
      ),
    );
    if (saved != true || !mounted) return;

    final name = nameController.text.trim();
    final price = double.tryParse(priceController.text.replaceAll(',', '.'));
    if (name.isEmpty || price == null || price <= 0) return;
    final priceMinor = (price * 100).round();
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;

    await _persistItem(
      existing: existing,
      userId: userId,
      name: name,
      nameAr: nameArController.text.trim().isEmpty
          ? null
          : nameArController.text.trim(),
      priceMinor: priceMinor,
      pickedImagePath:
          imageUrl != null && !imageUrl!.startsWith('http') ? imageUrl : null,
    );
  }

  Future<void> _persistItem({
    required Item? existing,
    required String userId,
    required String name,
    required String? nameAr,
    required int priceMinor,
    required String? pickedImagePath,
  }) async {
    final l = AppLocalizations.s(context);
    final repo = ref.read(itemRepositoryProvider);
    try {
      if (existing == null) {
        final created = await repo.createItem(
          userId: userId,
          name: name,
          nameAr: nameAr,
          priceMinor: priceMinor,
          currency: 'EGP',
        );
        if (pickedImagePath != null) {
          final url = await ref.read(itemImageServiceProvider).uploadImage(
                userId: userId,
                itemId: created.id,
                filePath: pickedImagePath,
              );
          if (url != null) {
            logInfo('ITEM_IMAGE_DATABASE_VALUE itemId=${created.id} '
                'image_url=$url');
            await repo.updateItem(created.copyWith(imageUrl: url));
          } else {
            logWarning('ITEM_IMAGE skipped: upload failed for '
                'itemId=${created.id} — item saved without image');
          }
        }
      } else {
        // Only upload when the user actually chose a NEW local file in the
        // picker. The dialog's image state starts as the existing storage
        // reference (e.g. `{userId}/{itemId}.jpg`); feeding that to
        // uploadImage() would try to read a non-existent local file, the
        // upload returns null, and the current image_url would be erased.
        // Cancelling the picker also leaves the existing reference untouched.
        String? finalUrl = existing.imageUrl;
        if (pickedImagePath != null && isLocalFilePath(pickedImagePath)) {
          finalUrl = await ref.read(itemImageServiceProvider).uploadImage(
                userId: userId,
                itemId: existing.id,
                filePath: pickedImagePath,
              );
        }
        final priceChanged = existing.priceMinor != priceMinor;
        final updated = existing.copyWith(
          name: name,
          nameAr: nameAr,
          priceMinor: priceMinor,
          imageUrl: finalUrl,
        );
        await repo.updateItem(updated);
        // Record price history only when the price actually changed;
        // historical transactions keep their original amounts.
        if (priceChanged) {
          await repo.updatePrice(
              itemId: existing.id, newPriceMinor: priceMinor);
        }
      }
      ref.invalidate(allItemsProvider(userId));
      ref.invalidate(dashboardItemsProvider(userId));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l['error']),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    }
  }

  Future<void> _toggleActive(Item item) async {
    final l = AppLocalizations.s(context);
    final repo = ref.read(itemRepositoryProvider);
    try {
      if (item.isActive) {
        await repo.deactivateItem(item.id);
      } else {
        await repo.updateItem(item.copyWith(isActive: true));
      }
      final userId = ref.read(currentUserIdProvider);
      if (userId != null) {
        ref.invalidate(allItemsProvider(userId));
        ref.invalidate(dashboardItemsProvider(userId));
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
    }
  }

  Future<void> _deleteItem(Item item) async {
    final l = AppLocalizations.s(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l['delete']),
        content: Text('${l['delete']} "${item.nameAr ?? item.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l['cancel']),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l['delete']),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      // Archive instead of hard delete so historical records stay intact.
      // Best-effort cleanup of the stored image.
      await ref.read(itemRepositoryProvider).archiveItem(item.id);
      final imageService = ref.read(itemImageServiceProvider);
      final userId = ref.read(currentUserIdProvider);
      if (userId != null) {
        await imageService.deleteImage(userId: userId, itemId: item.id);
        // Invalidate BOTH item providers so the deleted item disappears from
        // Manage Items AND Home immediately (single source of truth).
        ref.invalidate(allItemsProvider(userId));
        ref.invalidate(dashboardItemsProvider(userId));
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
    }
  }
}

/// All items (active + inactive) for management.
final allItemsProvider =
    FutureProvider.autoDispose.family<List<Item>, String>((ref, userId) async {
  return ref.watch(itemRepositoryProvider).getAllItems(userId);
});

class _ItemManagementCard extends StatelessWidget {
  final Item item;
  final VoidCallback onEdit;
  final VoidCallback onToggleActive;
  final VoidCallback onDelete;

  const _ItemManagementCard({
    required this.item,
    required this.onEdit,
    required this.onToggleActive,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.s(context);
    final active = item.isActive && !item.isArchived;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onEdit,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image area — always visible. Resolves the real stored image
            // (signed URL for the private bucket) with a graceful fallback.
            // Controlled, intentional image area (top of card). A fixed height
            // avoids the large empty placeholder block and keeps the layout
            // stable regardless of whether an image was attached.
            SizedBox(
              height: 72,
              width: double.infinity,
              child: FloosyItemImage(
                imageUrl: item.imageUrl,
                fit: BoxFit.cover,
                fallback: const _ImagePlaceholder(),
              ),
            ),
            // Content takes the remaining height. It is Expanded (not a rigid
            // flex:2 slice) so the name row + price always fit instead of being
            // squeezed into too little space (the original 15 px overflow).
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.nameAr ?? item.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              decoration:
                                  active ? null : TextDecoration.lineThrough,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        PopupMenuButton<String>(
                          padding: EdgeInsets.zero,
                          onSelected: (value) {
                            if (value == 'edit') onEdit();
                            if (value == 'toggle') onToggleActive();
                            if (value == 'delete') onDelete();
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                                value: 'edit', child: Text(l['edit'])),
                            PopupMenuItem(
                                value: 'toggle',
                                child:
                                    Text(active ? l['disable'] : l['enable'])),
                            PopupMenuItem(
                                value: 'delete', child: Text(l['delete'])),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formatMoney(item.priceMinor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Icon(Icons.image_outlined, size: 32, color: Colors.grey[500]),
    );
  }
}

/// Image picker tile used inside the item dialog. Shows the current image
/// (network or local file) and opens the gallery picker on tap.
class _ImagePickerTile extends StatelessWidget {
  final String? imageUrl;
  final ValueChanged<String> onPicked;

  const _ImagePickerTile({required this.imageUrl, required this.onPicked});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.s(context);
    return GestureDetector(
      onTap: () async {
        final picker = ImagePicker();
        final picked = await picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1024,
          maxHeight: 1024,
          imageQuality: 80,
        );
        if (picked != null) onPicked(picked.path);
        if (picked != null) {
          logInfo('ITEM_IMAGE_PICKER picked.path=${picked.path} '
              'isLocal=${isLocalFilePath(picked.path)} '
              'fileExists=${picked.path.startsWith('http') ? 'N/A-URL' : File(picked.path).existsSync()}');
          onPicked(picked.path);
        }
      },
      child: Container(
        width: 96,
        height: 96,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? (isLocalFilePath(imageUrl!)
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(File(imageUrl!),
                        fit: BoxFit.cover, width: 96, height: 96),
                  )
                : FloosyItemImage(
                    imageUrl: imageUrl,
                    width: 96,
                    height: 96,
                    radius: 12,
                    fallback: const SizedBox(),
                  ))
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_a_photo_outlined),
                  const SizedBox(height: 4),
                  Text(l['itemImage'], style: const TextStyle(fontSize: 10)),
                ],
              ),
      ),
    );
  }
}

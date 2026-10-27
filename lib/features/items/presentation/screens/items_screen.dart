import '../../../../domain/entities/image_reference.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:floosy/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:floosy/features/items/presentation/cubit/items_cubit.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../core/utils/money_formatter.dart';
import '../../../../domain/entities/item_model.dart';
import '../../../../core/theme/item_appearance.dart';
import '../../../../core/theme/app_design_system.dart';
import '../../../../core/widgets/common/item_avatar.dart';
import '../../../../domain/usecases/save_item.dart';
import '../../../../core/widgets/common/item_image.dart';
import '../../../../routing/app_routes.dart';

/// Item management — lives INSIDE Settings per product spec.
///
/// Add / Edit / Disable-Enable / Delete items with name, price and image.
/// Images are uploaded to the Supabase `item-images` bucket (user-isolated
/// folder). Deleting asks first; archiving is preferred so history stays.
class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  @override
  Widget build(BuildContext context) {
    final userId = context.watch<AuthCubit>().state.userId;
    final l = AppLocalizations.s(context);

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l['activeItems'])),
        body: Center(child: Text(l['error'])),
      );
    }

    final itemsAsync =
        context.watch<ItemsCubit>().state.map((data) => data.all);

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
                onPressed: () => context.read<ItemsCubit>().reload(),
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
              context.read<ItemsCubit>().reload();
              context.read<ItemsCubit>().reload();
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: items.where((item) => !item.isArchived).length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item =
                    items.where((item) => !item.isArchived).elementAt(index);
                return _ItemManagementCard(
                    item: item,
                    onEdit: () => _showItemDialog(item),
                    onToggleActive: () => _toggleActive(item),
                    onDelete: () => _deleteItem(item));
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
    var appearance = ItemAppearance.decode(existing?.icon);

    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog.fullscreen(
          child: Scaffold(
            backgroundColor: context.fc.background,
            appBar: AppBar(
              leading: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: () => Navigator.pop(dialogContext, false)),
              title: Text(existing == null ? l['addItem'] : l['editItem']),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ImagePickerTile(
                    imageUrl: imageUrl,
                    onPicked: (path) => setDialogState(() => imageUrl = path),
                  ),
                  const SizedBox(height: 12),
                  Align(
                      alignment: AlignmentDirectional.centerStart,
                      child:
                          Text(l['itemIcon'], style: context.fc.bodyTextSmall)),
                  const SizedBox(height: 8),
                  Wrap(spacing: 6, runSpacing: 6, children: [
                    for (final symbol in ItemAppearance.symbols)
                      Semantics(
                          selected: appearance.symbol == symbol,
                          button: true,
                          child: InkWell(
                            onTap: () => setDialogState(() => appearance =
                                ItemAppearance(
                                    symbol: symbol, color: appearance.color)),
                            borderRadius: BorderRadius.circular(12),
                            child: AnimatedContainer(
                                duration: FloosyDesign.fast,
                                width: 34,
                                height: 34,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: appearance.symbol == symbol
                                        ? appearance.color
                                            .withValues(alpha: .25)
                                        : context.fc.cardSurface,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: appearance.symbol == symbol
                                            ? appearance.color
                                            : Colors.transparent)),
                                child: Text(symbol,
                                    style: const TextStyle(fontSize: 19))),
                          )),
                  ]),
                  const SizedBox(height: 14),
                  Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(l['itemColor'],
                          style: context.fc.bodyTextSmall)),
                  const SizedBox(height: 8),
                  Wrap(spacing: 8, runSpacing: 8, children: [
                    for (var i = 0; i < ItemAppearance.colors.length; i++)
                      Tooltip(
                        message: l[ItemAppearance.colorLabels[i]],
                        child: Semantics(
                            button: true,
                            label: l[ItemAppearance.colorLabels[i]],
                            selected:
                                appearance.color == ItemAppearance.colors[i],
                            child: InkWell(
                              onTap: () => setDialogState(() => appearance =
                                  ItemAppearance(
                                      symbol: appearance.symbol,
                                      color: ItemAppearance.colors[i])),
                              customBorder: const CircleBorder(),
                              child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                      color: ItemAppearance.colors[i],
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: appearance.color ==
                                                  ItemAppearance.colors[i]
                                              ? Colors.white
                                              : Colors.transparent,
                                          width: 2)),
                                  child: appearance.color ==
                                          ItemAppearance.colors[i]
                                      ? const Icon(Icons.check,
                                          size: 16, color: Color(0xFF151827))
                                      : null),
                            )),
                      ),
                  ]),
                  const SizedBox(height: 18),
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
            bottomNavigationBar: SafeArea(
              minimum: const EdgeInsets.all(20),
              child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF147FA9),
                        foregroundColor: Colors.white),
                    onPressed: () => Navigator.pop(dialogContext, true),
                    child: Text(existing == null ? l['add'] : l['save']),
                  )),
            ),
          ),
        ),
      ),
    );
    if (saved != true || !mounted) return;

    final name = nameController.text.trim();
    final price = double.tryParse(priceController.text.replaceAll(',', '.'));
    if (name.isEmpty || price == null || price <= 0) return;
    final priceMinor = (price * 100).round();
    final userId = context.read<AuthCubit>().state.userId;
    if (userId == null) return;

    await _persistItem(
      existing: existing,
      userId: userId,
      name: name,
      nameAr: nameArController.text.trim().isEmpty
          ? null
          : nameArController.text.trim(),
      priceMinor: priceMinor,
      icon: appearance.encode(),
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
    required String icon,
    required String? pickedImagePath,
  }) async {
    final l = AppLocalizations.s(context);
    final repo = context.read<ItemsCubit>();
    try {
      await repo.save(ItemDraft(
          existing: existing,
          userId: userId,
          name: name,
          nameAr: nameAr,
          priceMinor: priceMinor,
          icon: icon,
          pickedImagePath: pickedImagePath));
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
    final repo = context.read<ItemsCubit>();
    try {
      if (item.isActive) {
        await repo.deactivateItem(item.id);
      } else {
        await repo.updateItem(item.copyWith(isActive: true));
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
    if (confirmed != true || !mounted) return;
    final cubit = context.read<ItemsCubit>();
    final userId = context.read<AuthCubit>().state.userId;
    try {
      // Archive instead of hard delete so historical records stay intact.
      // Best-effort cleanup of the stored image.
      await cubit.archiveItem(item.id);
      if (userId != null) {
        await cubit.deleteImage(userId: userId, itemId: item.id);
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

class _ItemManagementCard extends StatelessWidget {
  final Item item;
  final VoidCallback onEdit, onToggleActive, onDelete;
  const _ItemManagementCard(
      {required this.item,
      required this.onEdit,
      required this.onToggleActive,
      required this.onDelete});
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.s(context);
    return Material(
      color: context.fc.cardSurface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              border: Border.all(color: context.fc.borderSubtle),
              borderRadius: BorderRadius.circular(16)),
          child: Row(children: [
            ItemAvatar(item: item),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(item.nameAr ?? item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: context.fc.textPrimary,
                          decoration: item.isActive
                              ? null
                              : TextDecoration.lineThrough)),
                  const SizedBox(height: 4),
                  Text(formatMoney(item.priceMinor),
                      style: context.fc.bodyTextSmall)
                ])),
            IconButton(
                onPressed: onEdit,
                tooltip: l['edit'],
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.edit_rounded,
                    size: 19, color: FloosyDesign.blue)),
            PopupMenuButton<String>(
                tooltip: l['seeAll'],
                onSelected: (value) =>
                    value == 'delete' ? onDelete() : onToggleActive(),
                itemBuilder: (_) => [
                      PopupMenuItem(
                          value: 'toggle',
                          child: Text(l[item.isActive ? 'disable' : 'enable'])),
                      PopupMenuItem(
                          value: 'delete',
                          child: Row(children: [
                            const Icon(Icons.delete_outline_rounded,
                                size: 19, color: FloosyDesign.negative),
                            const SizedBox(width: 8),
                            Text(l['delete'])
                          ])),
                    ]),
          ]),
        ),
      ),
    );
  }
}

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

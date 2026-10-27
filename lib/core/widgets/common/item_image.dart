import '../../../features/items/presentation/cubit/item_image_cubit.dart';
import '../../../domain/repositories/financial_queries_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:floosy/core/state/load_state.dart';
import '../../utils/app_logger.dart';

/// Bounded, rounded item-image widget that renders the REAL item image.
///
/// Handles the full image pipeline:
///  * resolves any stored reference (storage path OR full URL) into a signed
///    URL via [ItemImageCubit] — required because the `item-images`
///    bucket is private (plain public URLs 400 in `Image.network`)
///  * keeps the image inside its box with [fit]
///  * shows a subtle loading indicator while resolving/downloading
///  * shows [fallback] when the reference is empty/resolves to null/errors
///
/// When [width]/[height] are provided the image is kept strictly inside that
/// box; otherwise it fills the parent constraints.
class FloosyItemImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final double radius;
  final BoxFit fit;
  final Widget fallback;
  final Color? loadingBackground;

  const FloosyItemImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.radius = 12,
    this.fit = BoxFit.cover,
    required this.fallback,
    this.loadingBackground,
  });

  @override
  Widget build(BuildContext context) {
    final raw = imageUrl;
    if (raw == null || raw.trim().isEmpty) {
      return _frame(context, fallback);
    }

    return BlocProvider(
      key: ValueKey(raw),
      create: (_) => ItemImageCubit(context.read<FinancialQueriesRepository>())
        ..resolve(raw),
      child: BlocBuilder<ItemImageCubit, LoadState<String?>>(
        builder: (context, urlAsync) {
          final content = urlAsync.when(
            loading: () => _loading(context),
            error: (_, __) => fallback,
            data: (url) {
              if (url == null || url.isEmpty) {
                logWarning('ITEM_IMAGE_LOAD_FAILED could not resolve "$raw" '
                    '(missing object or bucket access denied)');
                return fallback;
              }
              return Image.network(
                url,
                fit: fit,
                loadingBuilder: (context, child, progress) =>
                    progress == null ? child : _loading(context),
                errorBuilder: (_, __, ___) {
                  logWarning('ITEM_IMAGE_LOAD_FAILED network error for "$raw"');
                  return fallback;
                },
              );
            },
          );
          return _frame(context, content);
        },
      ),
    );
  }

  Widget _frame(BuildContext context, Widget child) {
    final rounded = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: child,
    );
    if (width == null && height == null) return rounded;
    return SizedBox(width: width, height: height, child: rounded);
  }

  Widget _loading(BuildContext context) {
    final bg = loadingBackground ??
        Theme.of(context).colorScheme.surfaceContainerHighest;
    return ColoredBox(
      color: bg,
      child: const Center(
        child: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}

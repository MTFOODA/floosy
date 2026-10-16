import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/utils/app_logger.dart';

/// Returns true when [path] refers to a LOCAL device file (e.g. a file just
/// picked from the gallery that has NOT been uploaded yet) — the only value
/// that should ever be passed to [ItemImageService.uploadImage].
///
/// Persisted references are NOT local: Supabase storage paths
/// (`{userId}/{itemId}.{ext}`) are relative, and `http(s)` URLs point at the
/// bucket. A Windows drive path (`C:\...`), an Android/iOS path
/// (`/data/...`, `/storage/...`, `/var/...`) or any other absolute POSIX path
/// (`/home/...` on desktop) IS a local file.
bool isLocalFilePath(String path) {
  if (path.startsWith('http://') || path.startsWith('https://')) return false;
  // Windows absolute path like C:\...
  if (path.length >= 2 && path[1] == ':') return true;
  // Any other absolute path (Android, iOS, Linux/macOS desktop). Storage
  // paths are relative, so they never start with a slash.
  if (path.startsWith('/')) return true;
  return false;
}

/// Uploads item images to the `item-images` storage bucket with per-user
/// folder isolation (`{userId}/{itemId}.{ext}`), matching the RLS policies
/// in supabase/migrations/021_storage_policies.sql.
class ItemImageService {
  final SupabaseClient _client;
  static const String bucket = 'item-images';

  ItemImageService(this._client);

  /// Picks nothing itself — receives a local file path from image_picker,
  /// uploads it and returns the storage PATH (not a public URL). The
  /// `item-images` bucket is private (RLS requires auth), so a plain public
  /// URL returns 400 for `Image.network`. The UI must resolve this path to a
  /// signed URL via [resolveItemImageUrlAsync] before displaying. Returns
  /// null on failure.
  Future<String?> uploadImage({
    required String userId,
    required String itemId,
    required String filePath,
  }) async {
    try {
      final file = File(filePath);
      final exists = await file.exists();
      logInfo('ITEM_IMAGE_UPLOAD_START path=$filePath exists=$exists');
      if (!exists) return null;

      final ext = filePath.split('.').last.toLowerCase();
      final safeExt =
          ['jpg', 'jpeg', 'png', 'webp'].contains(ext) ? ext : 'jpg';
      final path = '$userId/$itemId.$safeExt';

      await _client.storage.from(bucket).upload(
            path,
            file,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: true,
            ),
          );

      logInfo('ITEM_IMAGE_UPLOAD_SUCCESS storage_path=$path');
      // Return the storage path, NOT the public URL. The bucket is private,
      // so the UI must resolve this to a signed URL for display.
      return path;
    } catch (e) {
      logError('ITEM_IMAGE_UPLOAD_FAILED path=$filePath', e);
      return null;
    }
  }

  /// Deletes the item image if one exists (best effort).
  Future<void> deleteImage({
    required String userId,
    required String itemId,
  }) async {
    try {
      for (final ext in const ['jpg', 'jpeg', 'png', 'webp']) {
        await _client.storage.from(bucket).remove(['$userId/$itemId.$ext']);
      }
    } catch (_) {
      // Non-fatal.
    }
  }
}

/// Resolves a stored image reference into a displayable URL.
///
/// Accepts a full `http(s)` URL (legacy), a public object URL, or a raw
/// storage path (`{userId}/{file}`) — the latter is turned into a public
/// URL through the same bucket. Returns null when nothing can be shown.
///
/// DEPRECATED for display: the `item-images` bucket is private (RLS requires
/// auth), so this public URL returns 400 for `Image.network` (which sends no
/// auth header). Use [resolveItemImageUrlAsync], which returns a signed URL,
/// for anything rendered on screen.
String? resolveItemImageUrl(String? imageUrl) {
  if (imageUrl == null || imageUrl.trim().isEmpty) return null;
  final trimmed = imageUrl.trim();
  if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
    return trimmed;
  }
  if (trimmed.contains('/')) {
    try {
      return Supabase.instance.client.storage
          .from(ItemImageService.bucket)
          .getPublicUrl(trimmed);
    } catch (_) {
      return null;
    }
  }
  return null;
}

/// Resolves a stored image reference into a URL that actually renders in an
/// `Image.network` widget.
///
/// The `item-images` bucket is NOT public: its RLS policy only allows
/// authenticated reads, so a plain `getPublicUrl` URL returns 400 for
/// `Image.network` (which sends no auth header). This returns a
/// time-limited SIGNED URL whenever the value is a storage path or a public
/// object URL for this bucket. External URLs pass through unchanged.
Future<String?> resolveItemImageUrlAsync(String? imageUrl) async {
  if (imageUrl == null || imageUrl.trim().isEmpty) return null;
  final trimmed = imageUrl.trim();

  // Already a signed URL — use as-is.
  if (trimmed.contains('/object/sign/')) return trimmed;

  String? path;
  if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
    // Extract the storage path from a public object URL:
    //   .../object/public/item-images/{userId}/{file}.jpg
    const marker = '/object/public/${ItemImageService.bucket}/';
    final idx = trimmed.indexOf(marker);
    if (idx == -1) return trimmed; // External URL — not our bucket.
    path = trimmed.substring(idx + marker.length).split('?').first;
  } else if (trimmed.contains('/')) {
    path = trimmed;
  } else {
    return null;
  }

  try {
    return await Supabase.instance.client.storage
        .from(ItemImageService.bucket)
        .createSignedUrl(path, 3600);
  } catch (_) {
    return null;
  }
}

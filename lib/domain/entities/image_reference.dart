bool isLocalFilePath(String path) {
  if (path.startsWith('http://') || path.startsWith('https://')) return false;
  // Windows absolute path like C:\...
  if (path.length >= 2 && path[1] == ':') return true;
  // Any other absolute path (Android, iOS, Linux/macOS desktop). Storage
  // paths are relative, so they never start with a slash.
  if (path.startsWith('/')) return true;
  return false;
}

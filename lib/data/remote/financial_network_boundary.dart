import 'package:http/http.dart' as http;

class FinancialNetworkBlocked implements Exception {
  const FinancialNetworkBlocked();
  @override
  String toString() => 'Financial network access is disabled';
}

/// Default-deny egress boundary for normal application traffic. Legacy import
/// has a separate read-only reader; it cannot use this client to write data.
class FinancialNetworkBoundary extends http.BaseClient {
  final http.Client inner;
  final String host;
  FinancialNetworkBoundary(this.inner, this.host);
  bool permits(String method, Uri uri) {
    if (uri.scheme != 'https' || uri.host != host) return false;
    final path = uri.path;
    if (path.startsWith('/auth/v1/')) return true;
    if (path == '/rest/v1/profiles') return true;
    if (method == 'GET' &&
        const [
          '/rest/v1/banks',
          '/rest/v1/bank_sms_patterns',
          '/rest/v1/badges',
        ].contains(path)) {
      return true;
    }
    if (RegExp(
      r'^/storage/v1/object/(?:sign/|authenticated/|public/|upload/sign/|list/)?avatars(?:/|$)',
    ).hasMatch(path)) {
      return true;
    }
    return false;
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (!permits(request.method, request.url)) {
      throw const FinancialNetworkBlocked();
    }
    return inner.send(request);
  }

  @override
  void close() => inner.close();
}

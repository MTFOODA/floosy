import 'dart:typed_data';

class BackupSummary {
  final DateTime createdAt;
  final int transactions;
  const BackupSummary(this.createdAt, this.transactions);
}

abstract interface class BackupRepository {
  Future<Uint8List> create(String user, String password);
  Future<BackupSummary> inspect(String user, Uint8List bytes, String password);
  Future<void> restore(String user, Uint8List bytes, String password);
}

class BackupFailure implements Exception {
  final String code;
  const BackupFailure(this.code);
}

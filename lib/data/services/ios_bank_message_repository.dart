import 'dart:async';
import 'package:flutter/widgets.dart';
import '../../core/services/ios_bank_message_bridge.dart';
import '../../domain/entities/imported_bank_message.dart';
import '../../domain/entities/sms_ingestion_result.dart';
import '../../domain/repositories/bank_message_import_repository.dart';
import 'sms_parser_service.dart';

/// Drains a durable, account-bound iOS queue through the existing SMS processor.
/// This queue has no Android scan watermark: delayed/older imports cannot be
/// skipped by a cursor. A failed operation remains queued for a later attempt.
class IosBankMessageRepository extends WidgetsBindingObserver
    implements BankMessageImportRepository {
  final IosBankMessageBridge bridge;
  final Future<bool> Function(String userId, ImportedBankMessage message)
      process;
  final Future<bool> Function(String userId, String hash) isProcessed;
  final VoidCallback onChanged;
  String? _userId;
  int _generation = 0;
  bool _started = false;
  bool _foreground = false;
  Timer? _timer;
  Future<void> _binding = Future.value();
  Future<SmsIngestionResult>? _work;

  IosBankMessageRepository(
      {required this.bridge,
      required this.process,
      required this.isProcessed,
      required this.onChanged});

  @override
  Future<void> bindUser(String? userId) {
    _userId = userId;
    _generation++;
    // Serialize rapid logout/login events so a late platform reply can never
    // restore the previous owner of the native queue.
    return _binding =
        _binding.catchError((Object _) {}).then((_) => bridge.bindUser(userId));
  }

  Future<String> _owner() async {
    final userId = _userId;
    if (userId == null) throw StateError('Sign in to import bank messages');
    try {
      await _binding;
    } catch (_) {
      // For example, protected storage was unavailable before first unlock.
      // Retry binding once; never read any queue without successful binding.
      await bindUser(userId);
    }
    if (_userId != userId) throw StateError('Account changed during import');
    return userId;
  }

  @override
  Future<BankMessageInbox> getInbox() async => bridge.inbox(await _owner());
  @override
  Future<void> setEnabled(bool enabled) async =>
      bridge.setEnabled(await _owner(), enabled);
  @override
  Future<void> addMessage(
          String sender, String body, DateTime receivedAt) async =>
      bridge.addMessage(await _owner(), sender, body, receivedAt);
  @override
  Future<void> retryMessage(String id) async =>
      bridge.updateMessage(await _owner(), id, 'retry');
  @override
  Future<void> discardMessage(String id) async =>
      bridge.updateMessage(await _owner(), id, 'remove');

  @override
  void start() {
    if (_started) return;
    _started = true;
    _foreground =
        WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;
    WidgetsBinding.instance.addObserver(this);
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _tick());
    unawaited(_tick());
  }

  @override
  void stop() {
    _started = false;
    _timer?.cancel();
    _timer = null;
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _foreground = state == AppLifecycleState.resumed;
    if (_foreground) unawaited(_tick());
  }

  Future<void> _tick() async {
    if (!_started || !_foreground || _userId == null) return;
    try {
      await scanNow();
    } catch (_) {
      // The durable queue remains intact. A foreground tick or manual retry
      // can resume processing; never log the imported message or account ID.
    }
  }

  @override
  Future<SmsIngestionResult> scanNow() {
    if (_work case final Future<SmsIngestionResult> work) return work;
    late final Future<SmsIngestionResult> work;
    work = _scan().whenComplete(() {
      if (identical(_work, work)) _work = null;
    });
    return _work = work;
  }

  Future<SmsIngestionResult> _scan() async {
    if (_userId == null) {
      return const SmsIngestionResult(
          scanned: 0,
          transactionsCreated: 0,
          duplicatesOrSkipped: 0,
          errors: 0);
    }
    final userId = await _owner();
    final generation = _generation;
    final inbox = await bridge.inbox(userId);
    if (!inbox.enabled) {
      return const SmsIngestionResult(
          scanned: 0,
          transactionsCreated: 0,
          duplicatesOrSkipped: 0,
          errors: 0);
    }
    var scanned = 0, created = 0, skipped = 0, errors = 0, reviews = 0;
    for (final message
        in inbox.messages.where((m) => !m.needsReview).take(50)) {
      if (_generation != generation || _userId != userId) break;
      scanned++;
      try {
        final hash =
            SMSParser.fingerprintOf('${message.sender}|${message.body}');
        final known = await isProcessed(userId, hash);
        if (_generation != generation) break;
        final recorded = !known && await process(userId, message);
        if (_generation != generation) break;
        if (known || recorded) {
          if (recorded) created++;
          await bridge.updateMessage(userId, message.id, 'remove');
          if (!recorded) {
            skipped++;
          }
        } else {
          // Unknown sender, OTP, incomplete parsing, or an unconfirmed duplicate
          // is retained for explicit review; never silently throw it away.
          await bridge.updateMessage(userId, message.id, 'review');
          reviews++;
          skipped++;
        }
      } catch (_) {
        errors++;
      }
    }
    if (created > 0 && _generation == generation) onChanged();
    return SmsIngestionResult(
        scanned: scanned,
        transactionsCreated: created,
        duplicatesOrSkipped: skipped,
        errors: errors,
        parseFailures: reviews);
  }
}

import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../../core/utils/app_logger.dart';
import '../../../../data/models/transaction_model.dart';

/// Lifecycle-safe state machine for the Transactions screen list.
///
/// WHY THIS EXISTS (root cause of the RenderError / "PULL_REFRESH reload
/// failed"):
///
/// The screen previously held ONE mutable `Future<List<Transaction>> _future`
/// that FIVE independent async paths wrote into with `setState(...)`:
/// initState, two `ref.listenManual` callbacks, `ref.listen` inside `build`
/// (fired by the SMS poller's refresh tick), the pull-to-refresh handler and
/// the navigation-return handler. Consequences:
///
///   * `setState(() => _future = Future.error(e))` swapped the FutureBuilder
///     between "spinner" / "error" / "N transaction groups" while a
///     RefreshIndicator drag was still active, changing the scroll extent
///     mid-gesture → rendering-library exceptions (RenderError).
///   * A provider notification (refresh tick) could arrive while the widget
///     was building → `setState() called during build`.
///   * Async completions could touch `ref` after dispose.
///   * Two refreshes could run concurrently and the loser's result overwrote
///     the winner's.
///
/// This controller fixes all of that structurally:
///
///   * ONE owner of the UI state (data / loading / error / refreshing).
///   * `notifyListeners()` is guarded by a `_disposed` flag, so an async
///     completion after dispose can never touch a dead widget tree.
///   * Every async load is stamped with a generation token: an obsolete
///     result can never overwrite a newer one.
///   * `refresh()` is single-flight: concurrent callers join the same future,
///     and a second SMS sync can never start while the first is running.
///   * A failed refresh KEEPS the currently displayed list (plus an inline
///     error flag) instead of replacing the screen with an error future.
class TransactionsListController extends ChangeNotifier {
  TransactionsListController({
    required Future<List<Transaction>> Function(
      DateTime? start,
      DateTime? end,
    ) loadLocal,
    required Future<void> Function() runSmsSync,
  })  : _loadLocal = loadLocal,
        _runSmsSync = runSmsSync;

  final Future<List<Transaction>> Function(DateTime? start, DateTime? end)
      _loadLocal;
  final Future<void> Function() _runSmsSync;

  List<Transaction> _transactions = const [];
  bool _loading = true;
  bool _refreshing = false;

  /// Non-null when the LAST load failed. The previous list (if any) stays
  /// visible so a transient failure never blanks the screen.
  Object? _loadError;

  /// Non-null when the last PULL-TO-REFRESH failed (the list stays visible).
  Object? _refreshError;

  int _generation = 0;
  bool _disposed = false;

  Future<void>? _refreshFuture;

  List<Transaction> get transactions => _transactions;
  bool get loading => _loading;
  bool get refreshing => _refreshing;
  Object? get loadError => _loadError;
  Object? get refreshError => _refreshError;

  /// Initial load (screen entry / filter change / retry).
  Future<void> load({required DateTime? start, required DateTime? end}) {
    final generation = ++_generation;
    _loading = true;
    _loadError = null;
    _notify();
    return _load(generation, start, end, tag: 'TRANSACTIONS_LOAD');
  }

  Future<void> _load(
    int generation,
    DateTime? start,
    DateTime? end, {
    required String tag,
  }) async {
    final sw = DateTime.now();
    try {
      final result = await _loadLocal(start, end);
      if (_disposed || generation != _generation) {
        logInfo('$tag STALE_RESULT_DROPPED gen=$generation');
        return;
      }
      _transactions = result;
      _loadError = null;
      logInfo('$tag COMPLETE count=${result.length} '
          'duration_ms=${DateTime.now().difference(sw).inMilliseconds}');
    } catch (e, st) {
      if (_disposed || generation != _generation) return;
      // Keep the previously loaded list visible; surface the real error.
      logError('$tag FAILED keeping previous list', e, st);
      _loadError = e;
    } finally {
      if (!_disposed && generation == _generation) {
        _loading = false;
        _notify();
      }
    }
  }

  /// Pull-to-refresh: check for NEW SMS only → reload from the local DB.
  ///
  /// Single-flight: while a refresh is running every additional caller joins
  /// the same future (never a duplicate SMS scan, never a second reload race).
  Future<void> refresh({
    required DateTime? start,
    required DateTime? end,
  }) {
    final ongoing = _refreshFuture;
    if (ongoing != null) {
      logInfo('TRANSACTIONS_REFRESH JOIN (single-flight)');
      return ongoing;
    }
    final future = _refresh(start, end);
    _refreshFuture = future;
    return future.whenComplete(() {
      if (identical(_refreshFuture, future)) _refreshFuture = null;
    });
  }

  Future<void> _refresh(DateTime? start, DateTime? end) async {
    if (_disposed) return;
    final generation = ++_generation;
    _refreshing = true;
    _refreshError = null;
    _notify();
    try {
      // 1. Central SMS sync — NEW messages only (the polling service owns the
      //    single-flight scan, so this joins any in-flight poll cycle).
      await _runSmsSync();
      // 2. Reload the stored list from the local database.
      final result = await _loadLocal(start, end);
      if (_disposed || generation != _generation) return;
      _transactions = result;
      _loadError = null;
      logInfo('TRANSACTIONS_REFRESH COMPLETE count=${result.length}');
    } catch (e, st) {
      if (_disposed || generation != _generation) return;
      // The list stays visible; the error is surfaced inline, NOT by throwing
      // a broken future into the widget tree.
      logError('TRANSACTIONS_REFRESH FAILED keeping current list', e, st);
      _refreshError = e;
    } finally {
      if (!_disposed && generation == _generation) {
        _refreshing = false;
        _notify();
      }
    }
  }

  void _notify() {
    if (_disposed) return;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

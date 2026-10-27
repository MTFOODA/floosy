import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_logger.dart';
import '../../../../domain/entities/transaction_model.dart';

class TransactionsListState {
  final List<Transaction> transactions;
  final bool loading;
  final bool refreshing;
  final Object? loadError;
  final Object? refreshError;
  const TransactionsListState(
      {this.transactions = const [],
      this.loading = true,
      this.refreshing = false,
      this.loadError,
      this.refreshError});
}

/// Single-flight refresh and generation-checked local loads.
class TransactionsListCubit extends Cubit<TransactionsListState> {
  TransactionsListCubit({
    required Future<List<Transaction>> Function(
      DateTime? start,
      DateTime? end,
    ) loadLocal,
    required Future<void> Function() runSmsSync,
  })  : _loadLocal = loadLocal,
        _runSmsSync = runSmsSync,
        super(const TransactionsListState());

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
  bool get _disposed => isClosed;

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
      if (!_disposed) {
        _refreshing = false;
        _notify();
      }
    }
  }

  void _notify() {
    if (_disposed) return;
    emit(TransactionsListState(
        transactions: List.unmodifiable(_transactions),
        loading: _loading,
        refreshing: _refreshing,
        loadError: _loadError,
        refreshError: _refreshError));
  }
}

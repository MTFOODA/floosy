import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:floosy/data/models/transaction_model.dart';
import 'package:floosy/features/transactions/presentation/state/transactions_list_controller.dart';

// ─────────────────────────────────────────────────────────────────────────────
// TransactionsScreen state contract: DISPLAY filtering must never touch SMS
// ingestion, never delete stored rows, and must stay lifecycle-safe.
// ─────────────────────────────────────────────────────────────────────────────

Transaction _tx(String id, DateTime date) => Transaction(
      id: id,
      userId: 'u1',
      type: TransactionType.purchase,
      source: TransactionSource.sms,
      amountMinor: 1000,
      currency: 'EGP',
      transactionDate: date,
      fingerprint: 'fp-$id',
    );

/// Stand-in for the local database: keeps every stored row and answers range
/// queries exactly like `getTransactionsByRange` (inclusive bounds, null =
/// unbounded). It offers NO delete/rewrite API on purpose, so a test can prove
/// that a display range never mutates storage.
class _StoredRows {
  final List<Transaction> rows = [];
  int queries = 0;

  Future<List<Transaction>> query(DateTime? start, DateTime? end) async {
    queries++;
    return rows.where((t) {
      if (start != null && t.transactionDate.isBefore(start)) return false;
      if (end != null && t.transactionDate.isAfter(end)) return false;
      return true;
    }).toList();
  }
}

void main() {
  group('TransactionsListController (display filter vs SMS ingestion)', () {
    late _StoredRows stored;

    setUp(() {
      stored = _StoredRows()
        ..rows.addAll([
          _tx('a', DateTime(2026, 9, 1, 0, 0)), // boundary: start of range
          _tx('b', DateTime(2026, 9, 5, 12, 0)),
          _tx('c', DateTime(2026, 9, 20, 23, 59)), // boundary: end of range
          _tx('d', DateTime(2026, 9, 25, 8, 0)),
          _tx('e', DateTime(2026, 10, 2, 9, 0)),
        ]);
    });

    test('no filter shows ALL stored transactions', () async {
      var smsSyncs = 0;
      final controller = TransactionsListController(
        loadLocal: stored.query,
        runSmsSync: () async => smsSyncs++,
      );

      await controller.load(start: null, end: null);

      expect(controller.transactions, hasLength(5));
      expect(controller.loading, isFalse);
      expect(controller.loadError, isNull);
      expect(smsSyncs, 0);
      controller.dispose();
    });

    test(
        'changing (01→05, 01→20) and clearing the range never scans SMS and '
        'never deletes stored rows', () async {
      var smsSyncs = 0;
      final controller = TransactionsListController(
        loadLocal: stored.query,
        runSmsSync: () async => smsSyncs++,
      );

      await controller.load(start: null, end: null); // open: everything
      expect(controller.transactions, hasLength(5));

      // Shrink: 01/09 → 05/09
      await controller.load(
        start: DateTime(2026, 9, 1),
        end: DateTime(2026, 9, 5, 23, 59, 59),
      );
      expect(controller.transactions.map((t) => t.id), ['a', 'b']);

      // Expand: 01/09 → 20/09
      await controller.load(
        start: DateTime(2026, 9, 1),
        end: DateTime(2026, 9, 20, 23, 59, 59),
      );
      expect(controller.transactions.map((t) => t.id), ['a', 'b', 'c']);

      // Clear the filter → ALL stored transactions are back, none recreated.
      await controller.load(start: null, end: null);
      expect(controller.transactions, hasLength(5));

      // The DISPLAY path never invokes the SMS pipeline and never mutates
      // storage: the same five rows are still there (no delete, no re-create).
      expect(smsSyncs, 0);
      expect(stored.rows, hasLength(5));
      expect(stored.rows.map((t) => t.id).toSet(), {'a', 'b', 'c', 'd', 'e'});
      controller.dispose();
    });

    test('pull-to-refresh runs the SMS check once and reloads the stored list',
        () async {
      var smsSyncs = 0;
      final controller = TransactionsListController(
        loadLocal: stored.query,
        runSmsSync: () async => smsSyncs++,
      );

      await controller.load(start: null, end: null);
      await controller.refresh(start: null, end: null);

      expect(smsSyncs, 1);
      expect(controller.refreshError, isNull);
      expect(controller.refreshing, isFalse);
      expect(controller.transactions, hasLength(5));
      controller.dispose();
    });

    test('concurrent refreshes JOIN one refresh (never two SMS scans)',
        () async {
      final gate = Completer<void>();
      var smsSyncs = 0;
      final controller = TransactionsListController(
        loadLocal: stored.query,
        runSmsSync: () async {
          smsSyncs++;
          await gate.future;
        },
      );

      final first = controller.refresh(start: null, end: null);
      final second = controller.refresh(start: null, end: null);
      gate.complete();
      await Future.wait([first, second]);

      expect(smsSyncs, 1);
      controller.dispose();
    });

    test('a failed load keeps the visible list, exposes the error, retries',
        () async {
      var fail = false;
      final controller = TransactionsListController(
        loadLocal: (start, end) async {
          if (fail) throw StateError('db down');
          return stored.query(start, end);
        },
        runSmsSync: () async {},
      );

      await controller.load(start: null, end: null);
      expect(controller.transactions, hasLength(5));

      fail = true;
      await controller.load(start: null, end: null);
      expect(controller.loadError, isNotNull);
      // The screen never blanks out: the previous list stays visible.
      expect(controller.transactions, hasLength(5));
      expect(controller.loading, isFalse);

      fail = false; // Retry (the error state's Retry button)
      await controller.load(start: null, end: null);
      expect(controller.loadError, isNull);
      expect(controller.transactions, hasLength(5));
      controller.dispose();
    });

    test('leaving the screen during a load neither throws nor notifies',
        () async {
      final gate = Completer<void>();
      var notifications = 0;
      final controller = TransactionsListController(
        loadLocal: (start, end) async {
          await gate.future;
          return stored.query(start, end);
        },
        runSmsSync: () async {},
      );
      controller.addListener(() => notifications++);

      final pending = controller.load(start: null, end: null);
      final beforeDispose = notifications;
      controller.dispose(); // screen disposed while the load is in flight
      gate.complete();
      await pending; // must not throw

      // No state mutation / notification reached the dead widget tree.
      expect(notifications, beforeDispose);
    });

    test('an obsolete (slow) load never overwrites a newer result', () async {
      final slowGate = Completer<void>();
      var calls = 0;
      final controller = TransactionsListController(
        loadLocal: (start, end) async {
          calls++;
          if (calls == 1) {
            await slowGate.future; // stale generation finishes LAST
            return [_tx('stale', DateTime(2026, 9, 1))];
          }
          return [_tx('fresh', DateTime(2026, 9, 18))];
        },
        runSmsSync: () async {},
      );

      final stale = controller.load(start: null, end: null);
      final fresh = controller.load(
        start: DateTime(2026, 9, 18),
        end: DateTime(2026, 9, 20),
      );
      await fresh;
      expect(controller.transactions.single.id, 'fresh');

      slowGate.complete();
      await stale;
      // The older generation was dropped, never rendered.
      expect(controller.transactions.single.id, 'fresh');
      controller.dispose();
    });
  });
}

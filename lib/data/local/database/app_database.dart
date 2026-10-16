import 'package:drift/drift.dart';

// Platform-specific database connection factory.
import 'database_connection.dart';

part 'app_database.g.dart';

// ─────────────────────────────────────────────────────────────────────────────
// TABLES
// ─────────────────────────────────────────────────────────────────────────────

class Transactions extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get bankId => text().nullable()();
  TextColumn get categoryId => text().nullable()();
  TextColumn get merchantId => text().nullable()();
  TextColumn get type => text()();
  TextColumn get source => text()();
  IntColumn get amountMinor => integer()();
  TextColumn get currency => text().withDefault(const Constant('EGP'))();
  DateTimeColumn get transactionDate => dateTime()();
  TextColumn get merchantName => text().nullable()();
  TextColumn get cardLast4 => text().nullable()();
  TextColumn get cardId => text().nullable()();
  TextColumn get rawReference => text().nullable()();
  TextColumn get externalReference => text().nullable()();
  TextColumn get fingerprint => text().withDefault(const Constant(''))();
  TextColumn get status => text().withDefault(const Constant('confirmed'))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Expenses extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get transactionId => text().nullable()();
  TextColumn get categoryId => text().nullable()();
  IntColumn get amountMinor => integer()();
  TextColumn get currency => text().withDefault(const Constant('EGP'))();
  DateTimeColumn get expenseDate => dateTime()();
  TextColumn get paymentMethod => text()();
  TextColumn get merchantId => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class ExpenseItems extends Table {
  TextColumn get id => text()();
  TextColumn get expenseId => text()();
  TextColumn get itemId => text()();
  IntColumn get quantity => integer()();
  IntColumn get unitPriceMinor => integer()();
  IntColumn get totalPriceMinor => integer()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Items extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get name => text()();
  TextColumn get nameAr => text().nullable()();
  TextColumn get description => text().nullable()();
  IntColumn get priceMinor => integer()();
  TextColumn get currency => text().withDefault(const Constant('EGP'))();
  TextColumn get categoryId => text().nullable()();
  TextColumn get icon => text().nullable()();
  TextColumn get imageUrl => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().nullable()();
  TextColumn get name => text()();
  TextColumn get nameAr => text().nullable()();
  TextColumn get icon => text().nullable()();
  TextColumn get parentId => text().nullable()();
  TextColumn get type => text().withDefault(const Constant('expense'))();
  BoolColumn get isSystem => boolean().withDefault(const Constant(false))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class CashWallets extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get currency => text().withDefault(const Constant('EGP'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class CashMovements extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get walletId => text()();
  TextColumn get type => text()();
  IntColumn get amountMinor => integer()();
  TextColumn get referenceType => text().nullable()();
  TextColumn get referenceId => text().nullable()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get movementDate => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Budgets extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get name => text()();
  IntColumn get amountMinor => integer()();
  TextColumn get currency => text().withDefault(const Constant('EGP'))();
  TextColumn get period => text().withDefault(const Constant('monthly'))();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class RecurringExpenses extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get name => text()();
  TextColumn get nameAr => text().nullable()();
  IntColumn get amountMinor => integer()();
  TextColumn get currency => text().withDefault(const Constant('EGP'))();
  TextColumn get categoryId => text().nullable()();
  TextColumn get icon => text().nullable()();
  TextColumn get frequency => text()();
  DateTimeColumn get nextDueDate => dateTime()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Alerts extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get type => text()();
  TextColumn get severity => text().withDefault(const Constant('info'))();
  TextColumn get itemId => text().nullable()();
  TextColumn get categoryId => text().nullable()();
  TextColumn get title => text()();
  TextColumn get message => text()();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class SyncQueue extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get operation => text()();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

// ─────────────────────────────────────────────────────────────────────────────
// MONEY MODEL TABLES (schema v2)
// ─────────────────────────────────────────────────────────────────────────────

class MonthlyIncomes extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  IntColumn get year => integer()();
  IntColumn get month => integer()();
  TextColumn get label => text().nullable()();
  IntColumn get amountMinor => integer()();
  TextColumn get currency => text().withDefault(const Constant('EGP'))();
  TextColumn get bankAccountId => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class BankAccounts extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get name => text()();
  TextColumn get bankId => text().nullable()();
  TextColumn get accountLast4 => text().nullable()();
  IntColumn get openingBalanceMinor =>
      integer().withDefault(const Constant(0))();
  TextColumn get currency => text().withDefault(const Constant('EGP'))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class BankMovements extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text()();
  TextColumn get userId => text()();
  TextColumn get type => text()();
  IntColumn get amountMinor => integer()();
  TextColumn get description => text().nullable()();
  TextColumn get referenceType => text().nullable()();
  TextColumn get referenceId => text().nullable()();
  DateTimeColumn get movementDate => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class ItemUsages extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get itemId => text()();
  TextColumn get expenseId => text()();
  IntColumn get quantity => integer()();
  IntColumn get totalAmountMinor => integer()();
  DateTimeColumn get usageDate => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// LOCAL per-message processed-SMS ledger (detection dedupe, requirement
/// #12/#13 of the Detection-Range spec).
///
/// One row is written exactly once per SMS that was successfully DETECTED
/// (parsed + transaction persisted). The `(user_id, message_hash)` pair is
/// THE authoritative local processed identity:
///
///   Is this SMS already processed?
///       YES → skip detection
///       NO  → detect and persist
///
/// The hash is the SAME deterministic `sender|body` fingerprint already used
/// by the remote `sms_messages` table (idempotency layer 1) — this table is
/// its offline-capable local mirror, NOT a new dedupe formula. It survives
/// app restarts and works without network, so processed SMS are never
/// re-parsed after a range change, a restart, or while offline.
///
/// The raw message body is never stored — only the stable hash plus parsed
/// metadata (same privacy rule as the remote sms_messages table).
@TableIndex(name: 'processed_sms_user_hash_unique', columns: {#userId, #messageHash}, unique: true)
class ProcessedSmsMessages extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get sender => text().nullable()();
  TextColumn get messageHash => text()();
  DateTimeColumn get receivedAt => dateTime()();
  TextColumn get transactionId => text().nullable()();
  DateTimeColumn get processedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// LOCAL mirror of the complete sms_messages detection record. It is not a
/// second detection system: it is the restart-safe local source for the same
/// rows written remotely, including messages that need review.
@TableIndex(name: 'sms_messages_user_hash_unique', columns: {#userId, #messageHash}, unique: true)
class SmsMessages extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get sender => text().nullable()();
  TextColumn get messageHash => text()();
  TextColumn get messageBody => text().nullable()();
  DateTimeColumn get receivedAt => dateTime()();
  DateTimeColumn get processedAt => dateTime().nullable()();
  TextColumn get processingStatus => text().withDefault(const Constant('pending'))();
  BoolColumn get bankIdentified => boolean().withDefault(const Constant(false))();
  BoolColumn get typeIdentified => boolean().withDefault(const Constant(false))();
  BoolColumn get amountIdentified => boolean().withDefault(const Constant(false))();
  BoolColumn get currencyIdentified => boolean().withDefault(const Constant(false))();
  BoolColumn get cardLast4Identified => boolean().withDefault(const Constant(false))();
  TextColumn get detectedBankId => text().nullable()();
  TextColumn get detectedBankName => text().nullable()();
  TextColumn get detectedType => text().nullable()();
  IntColumn get detectedAmountMinor => integer().nullable()();
  TextColumn get detectedCurrency => text().nullable()();
  TextColumn get detectedCardLast4 => text().nullable()();
  TextColumn get transactionId => text().nullable()();
  TextColumn get parserVersion => text().nullable()();
  RealColumn get confidence => real().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [
  Transactions,
  Expenses,
  ExpenseItems,
  Items,
  Categories,
  CashWallets,
  CashMovements,
  Budgets,
  RecurringExpenses,
  Alerts,
  SyncQueue,
  MonthlyIncomes,
  BankAccounts,
  BankMovements,
  ItemUsages,
  ProcessedSmsMessages,
  SmsMessages,
])
class AppDatabase extends _$AppDatabase {
  /// [executor] may be injected for tests (e.g. an in-memory
  /// [NativeDatabase]); the default opens the on-disk app database.
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(monthlyIncomes);
            await m.createTable(bankAccounts);
            await m.createTable(bankMovements);
            await m.createTable(itemUsages);
          }
          // Add card_id column to existing transactions tables.
          // This migration handles databases created before card-specific
          // transaction tracking was introduced (schemaVersion 2 → 3).
          if (from < 3) {
            await m.addColumn(transactions, transactions.cardId);
          }
          // Local processed-SMS ledger (schemaVersion 3 → 4). New installs
          // get the table via onCreate; existing installs get it here.
          if (from < 4) {
            await m.createTable(processedSmsMessages);
          }
          if (from < 5) {
            await m.createTable(smsMessages);
          }
        },
      );

  static QueryExecutor _openConnection() {
    return openDatabaseConnection();
  }
}

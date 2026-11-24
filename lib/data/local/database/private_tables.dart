import 'package:drift/drift.dart';

Future<void> createPrivateTables(GeneratedDatabase db) async {
  await db.customStatement('''CREATE TABLE IF NOT EXISTS private_records (
    owner TEXT NOT NULL, kind TEXT NOT NULL, id TEXT NOT NULL,
    payload BLOB NOT NULL, PRIMARY KEY (owner,kind,id)) WITHOUT ROWID''');
  await db.customStatement('''CREATE TABLE IF NOT EXISTS migration_journal (
    owner TEXT NOT NULL, stage TEXT NOT NULL, payload BLOB NOT NULL,
    PRIMARY KEY(owner,stage)) WITHOUT ROWID''');
  await db.customStatement('''CREATE TABLE IF NOT EXISTS sms_payloads (
    owner TEXT NOT NULL, hash TEXT NOT NULL, payload BLOB NOT NULL,
    PRIMARY KEY(owner,hash)) WITHOUT ROWID''');
  await db.customStatement('''CREATE TABLE IF NOT EXISTS private_media (
    owner TEXT NOT NULL, id TEXT NOT NULL, mime TEXT NOT NULL, payload BLOB NOT NULL,
    PRIMARY KEY(owner,id)) WITHOUT ROWID''');
}

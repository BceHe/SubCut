import 'package:path/path.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class LocalDatabase {
  LocalDatabase._();

  static final instance = LocalDatabase._();
  static const _databaseName = 'subcut.db';
  static const _databaseVersion = 1;
  static const _databaseKeyName = 'subcut_database_key';
  static const _secureStorage = FlutterSecureStorage();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    final databasePath = await getDatabasesPath();
    final databaseKey = await _getDatabaseKey();
    _database = await openDatabase(
      join(databasePath, _databaseName),
      version: _databaseVersion,
      password: databaseKey,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (database, version) async {
        await database.execute('''
          CREATE TABLE subscriptions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            category TEXT NOT NULL,
            price INTEGER NOT NULL CHECK (price >= 0),
            billing_cycle TEXT NOT NULL CHECK (billing_cycle IN ('monthly', 'yearly')),
            next_due_date TEXT NOT NULL,
            is_trial INTEGER NOT NULL DEFAULT 0,
            trial_end_date TEXT,
            merchant_key TEXT,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL,
            is_active INTEGER NOT NULL DEFAULT 1
          )
        ''');
        await database.execute('''
          CREATE TABLE transaction_records (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            subscription_id INTEGER,
            amount INTEGER NOT NULL CHECK (amount >= 0),
            transaction_date TEXT NOT NULL,
            source TEXT NOT NULL CHECK (source IN ('notification', 'ocr', 'manual')),
            merchant_name TEXT,
            raw_text TEXT,
            confidence REAL,
            created_at TEXT NOT NULL,
            FOREIGN KEY (subscription_id) REFERENCES subscriptions(id) ON DELETE SET NULL
          )
        ''');
        await database.execute('''
          CREATE TABLE notification_settings (
            id INTEGER PRIMARY KEY,
            remind_days_before TEXT NOT NULL DEFAULT '[3,1]',
            notifications_enabled INTEGER NOT NULL DEFAULT 1,
            updated_at TEXT NOT NULL
          )
        ''');
        await database.execute(
          'CREATE INDEX idx_subscriptions_due_date ON subscriptions(next_due_date, is_active)',
        );
        await database.execute(
          'CREATE INDEX idx_transactions_subscription_date ON transaction_records(subscription_id, transaction_date)',
        );
        await database.execute(
          'CREATE INDEX idx_subscriptions_merchant_key ON subscriptions(merchant_key)',
        );
      },
    );
    return _database!;
  }

  Future<String> _getDatabaseKey() async {
    final existingKey = await _secureStorage.read(key: _databaseKeyName);
    if (existingKey != null && existingKey.isNotEmpty) {
      return existingKey;
    }

    final key = '${DateTime.now().microsecondsSinceEpoch}-${DateTime.now().millisecondsSinceEpoch}';
    await _secureStorage.write(key: _databaseKeyName, value: key);
    return key;
  }

  Future<void> close() async {
    await _database?.close();
    _database = null;
  }
}

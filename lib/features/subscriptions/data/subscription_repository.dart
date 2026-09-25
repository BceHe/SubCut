import 'package:flutter/foundation.dart';

import '../../../core/database/local_database.dart';
import '../models/subscription.dart';

class SubscriptionRepository {
  SubscriptionRepository({LocalDatabase? database}) : _database = database ?? LocalDatabase.instance;

  static final List<Subscription> _webSubscriptions = [];
  static int _nextWebId = 1;
  final LocalDatabase _database;

  Future<List<Subscription>> getActiveSubscriptions() async {
    if (kIsWeb) {
      final subscriptions = _webSubscriptions.where((item) => item.isActive).toList()
        ..sort((first, second) => first.nextDueDate.compareTo(second.nextDueDate));
      return subscriptions;
    }
    final database = await _database.database;
    final rows = await database.query(
      'subscriptions',
      where: 'is_active = ?',
      whereArgs: [1],
      orderBy: 'next_due_date ASC',
    );
    return rows.map(Subscription.fromMap).toList();
  }

  Future<Subscription?> getById(int id) async {
    if (kIsWeb) {
      for (final subscription in _webSubscriptions) {
        if (subscription.id == id) {
          return subscription;
        }
      }
      return null;
    }
    final database = await _database.database;
    final rows = await database.query('subscriptions', where: 'id = ?', whereArgs: [id], limit: 1);
    return rows.isEmpty ? null : Subscription.fromMap(rows.first);
  }

  Future<int> insert(Subscription subscription) async {
    if (kIsWeb) {
      final id = _nextWebId++;
      _webSubscriptions.add(
        subscription.copyWith(
          id: id,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
      return id;
    }
    final database = await _database.database;
    return database.insert('subscriptions', subscription.toMap()..remove('id'));
  }

  Future<int> update(Subscription subscription) async {
    if (kIsWeb) {
      final index = _webSubscriptions.indexWhere((item) => item.id == subscription.id);
      if (index == -1) {
        return 0;
      }
      _webSubscriptions[index] = subscription.copyWith(updatedAt: DateTime.now());
      return 1;
    }
    final database = await _database.database;
    return database.update(
      'subscriptions',
      subscription.copyWith(updatedAt: DateTime.now()).toMap()..remove('id'),
      where: 'id = ?',
      whereArgs: [subscription.id],
    );
  }

  Future<int> delete(int id) async {
    if (kIsWeb) {
      final index = _webSubscriptions.indexWhere((item) => item.id == id);
      if (index == -1) {
        return 0;
      }
      _webSubscriptions[index] = _webSubscriptions[index].copyWith(
        isActive: false,
        updatedAt: DateTime.now(),
      );
      return 1;
    }
    final database = await _database.database;
    return database.update(
      'subscriptions',
      {'is_active': 0, 'updated_at': DateTime.now().toUtc().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

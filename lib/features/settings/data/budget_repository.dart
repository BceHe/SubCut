import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BudgetRepository {
  BudgetRepository({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const _monthlyBudgetKey = 'subcut_monthly_budget';
  final FlutterSecureStorage _storage;

  Future<int?> getMonthlyBudget() async {
    final value = await _storage.read(key: _monthlyBudgetKey);
    if (value == null) {
      return null;
    }
    return int.tryParse(value);
  }

  Future<void> saveMonthlyBudget(int amount) async {
    await _storage.write(key: _monthlyBudgetKey, value: amount.toString());
  }

  Future<void> clearMonthlyBudget() async {
    await _storage.delete(key: _monthlyBudgetKey);
  }
}

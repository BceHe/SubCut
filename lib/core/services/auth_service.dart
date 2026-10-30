import '../../features/auth/models/user_model.dart';
import '../database/local_database.dart';

class AuthService {
  AuthService({LocalDatabase? database})
      : _database = database ?? LocalDatabase.instance;

  static UserModel? currentUser;
  final LocalDatabase _database;

  Future<UserModel?> signIn(String email, String password) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (normalizedEmail.isEmpty || password.isEmpty) {
      return null;
    }
    final database = await _database.database;
    final rows = await database.query('users',
        where: 'email = ?', whereArgs: [normalizedEmail], limit: 1);
    if (rows.isEmpty || rows.first['password'] != password) {
      return null;
    }
    final row = rows.first;
    return currentUser = UserModel(
        id: row['id'] as int,
        name: row['name'] as String,
        email: row['email'] as String);
  }

  Future<UserModel?> register(
      String name, String email, String password) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (name.trim().isEmpty || normalizedEmail.isEmpty || password.length < 4) {
      return null;
    }
    final database = await _database.database;
    try {
      final id = await database.insert('users', {
        'name': name.trim(),
        'email': normalizedEmail,
        'password': password,
        'created_at': DateTime.now().toUtc().toIso8601String(),
      });
      return currentUser =
          UserModel(id: id, name: name.trim(), email: normalizedEmail);
    } catch (_) {
      return null;
    }
  }
}

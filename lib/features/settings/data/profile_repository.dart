import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileRepository {
  ProfileRepository({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const _nameKey = 'subcut_profile_name';
  final FlutterSecureStorage _storage;

  Future<String?> getName() async {
    final name = await _storage.read(key: _nameKey);
    if (name == null || name.trim().isEmpty) {
      return null;
    }
    return name;
  }

  Future<void> saveName(String name) async {
    await _storage.write(key: _nameKey, value: name.trim());
  }
}

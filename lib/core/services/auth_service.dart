import '../../features/auth/models/user_model.dart';

class AuthService {
  Future<UserModel?> signIn(String email, String password) async {
    if (email.trim().isEmpty || password.isEmpty) {
      return null;
    }

    return UserModel(name: 'Pengguna SubCut', email: email.trim());
  }
}

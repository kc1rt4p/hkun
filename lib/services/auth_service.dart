import 'package:get_storage/get_storage.dart';
import 'package:hkun/repositories/auth_repository.dart';

class AuthService {
  final _authRepo = AuthRepository();
  final _storage = GetStorage();

  Future<bool> signIn(String email, String password) async {
    final result = await _authRepo.signIn(email: email, password: password);
    if (result == null) return false;
    return true;
  }

  Future<void> signOut() async {
    await _storage.remove('credentials');
    await _authRepo.signOut();
  }

  Future<bool> isLoggedIn() async {
    return await _authRepo.isLoggedIn();
  }
}

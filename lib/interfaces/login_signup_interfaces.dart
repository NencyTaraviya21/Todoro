import 'package:todoro/import_export/todoro_import_export.dart';

abstract class IAuthRepository {
  Future<AuthResult> login(AuthRequest request);
  Future<AuthResult> register(AuthRequest request);
}

abstract class IStorageService {
  Future<void> saveUser(User user);
  Future<User?> getUser();
  Future<void> clearUser();
}
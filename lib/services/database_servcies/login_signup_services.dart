
import 'package:todoro/import_export/todoro_import_export.dart';

class StorageService implements IStorageService {
  final GetStorage _storage = GetStorage();
  static const String _userKey = 'user';

  @override
  Future<void> saveUser(User user) async {
    await _storage.write(_userKey, user.toJson());
  }

  @override
  Future<User?> getUser() async {
    final userData = _storage.read(_userKey);
    if (userData != null) {
      return User.fromJson(userData);
    }
    return null;
  }

  @override
  Future<void> clearUser() async {
    await _storage.remove(_userKey);
  }
}

class AuthService extends GetxService {
  final IAuthRepository _authRepository = Get.find<IAuthRepository>();
  final IStorageService _storageService = Get.find<IStorageService>();

  final Rx<User?> _currentUser = Rx<User?>(null);
  User? get currentUser => _currentUser.value;

  final RxBool _isLoggedIn = false.obs;
  bool get isLoggedIn => _isLoggedIn.value;

  @override
  void onInit() {
    super.onInit();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await _storageService.getUser();
    if (user != null) {
      _currentUser.value = user;
      _isLoggedIn.value = true;
    }
  }

  Future<AuthResult> login(AuthRequest request) async {
    final result = await _authRepository.login(request);

    if (result.success && result.user != null) {
      _currentUser.value = result.user;
      _isLoggedIn.value = true;
      await _storageService.saveUser(result.user!);
    }

    return result;
  }

  Future<AuthResult> register(AuthRequest request) async {
    final result = await _authRepository.register(request);

    if (result.success && result.user != null) {
      _currentUser.value = result.user;
      _isLoggedIn.value = true;
      await _storageService.saveUser(result.user!);
    }

    return result;
  }

  Future<void> logout() async {
    _currentUser.value = null;
    _isLoggedIn.value = false;
    await _storageService.clearUser();
  }
}
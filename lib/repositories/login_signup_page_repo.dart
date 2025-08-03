import 'package:todoro/import_export/todoro_import_export.dart';

class AuthRepository implements IAuthRepository {
  @override
  Future<AuthResult> login(AuthRequest request) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Simple validation
    if (request.email.isEmpty || request.password.isEmpty) {
      return AuthResult(
        success: false,
        message: 'Please fill in all fields',
      );
    }

    if (!request.email.contains('@')) {
      return AuthResult(
        success: false,
        message: 'Please enter a valid email',
      );
    }

    // Mock successful login
    return AuthResult(
      success: true,
      user: User(
        id: '1',
        name: 'User',
        email: request.email,
      ),
    );
  }

  @override
  Future<AuthResult> register(AuthRequest request) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Simple validation
    if (request.email.isEmpty ||
        request.password.isEmpty ||
        request.name?.isEmpty == true) {
      return AuthResult(
        success: false,
        message: 'Please fill in all fields',
      );
    }

    if (!request.email.contains('@')) {
      return AuthResult(
        success: false,
        message: 'Please enter a valid email',
      );
    }

    if (request.password.length < 6) {
      return AuthResult(
        success: false,
        message: 'Password must be at least 6 characters',
      );
    }

    // Mock successful registration
    return AuthResult(
      success: true,
      user: User(
        id: '1',
        name: request.name!,
        email: request.email,
      ),
    );
  }
}
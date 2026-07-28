import 'package:flutter/foundation.dart';

import '../services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel({AuthService? service}) : _service = service ?? AuthService();

  final AuthService _service;

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String email, String password) async {
    if (email.trim().isEmpty || password.isEmpty) {
      _setError('Completa tu correo y contraseña.');
      return false;
    }

    return _run(() => _service.login(email.trim(), password));
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (name.trim().isEmpty || email.trim().isEmpty || password.isEmpty) {
      _setError('Completa todos los campos.');
      return false;
    }
    if (password != confirmPassword) {
      _setError('Las contraseñas no coinciden.');
      return false;
    }

    return _run(
      () => _service.register(
        name: name.trim(),
        email: email.trim(),
        password: password,
      ),
    );
  }

  Future<bool> _run(Future<void> Function() action) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await action();
      return true;
    } on AuthException catch (error) {
      _errorMessage = error.message;
      return false;
    } catch (_) {
      _errorMessage =
          'No se pudo conectar con el backend. Verifica que esté corriendo.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }
}

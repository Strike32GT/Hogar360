import 'package:flutter/foundation.dart';

import '../../../core/session/app_session.dart';
import '../models/profile_summary.dart';
import '../services/profile_service.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel({ProfileService? service})
    : _service = service ?? ProfileService();

  final ProfileService _service;

  ProfileSummary _summary = const ProfileSummary(
    calculationsCount: 0,
    completionPercentage: 0,
  );
  bool _isLoading = false;
  String? _errorMessage;

  ProfileSummary get summary => _summary;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get userName => AppSession.instance.userName ?? 'Usuario Hogar360';

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    try {
      _summary = await _service.getSummary();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateName(String name) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      _errorMessage = 'Ingresa un nombre válido.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _service.updateName(trimmedName);
      return true;
    } on ProfileException catch (error) {
      _errorMessage = error.message;
      return false;
    } catch (_) {
      _errorMessage = 'No se pudo actualizar el nombre.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

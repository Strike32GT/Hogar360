import 'package:shared_preferences/shared_preferences.dart';

class AppSession {
  AppSession._();

  static final AppSession instance = AppSession._();
  static const _tokenKey = 'session.token';
  static const _userNameKey = 'session.userName';
  static const _userEmailKey = 'session.userEmail';

  String? token;
  String? userName;
  String? userEmail;

  bool get isAuthenticated => token != null;

  Future<void> restore() async {
    final preferences = await SharedPreferences.getInstance();
    token = preferences.getString(_tokenKey);
    userName = preferences.getString(_userNameKey);
    userEmail = preferences.getString(_userEmailKey);
  }

  Future<void> setSession({
    required String token,
    required String name,
    required String email,
  }) async {
    this.token = token;
    userName = name;
    userEmail = email;

    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_tokenKey, token);
    await preferences.setString(_userNameKey, name);
    await preferences.setString(_userEmailKey, email);
  }

  Future<void> updateUserName(String name) async {
    userName = name;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_userNameKey, name);
  }

  Future<void> clear() async {
    token = null;
    userName = null;
    userEmail = null;

    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_tokenKey);
    await preferences.remove(_userNameKey);
    await preferences.remove(_userEmailKey);
  }
}

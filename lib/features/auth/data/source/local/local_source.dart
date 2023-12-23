import 'package:shared_preferences/shared_preferences.dart';

sealed class AuthLocalSource {
  Future<bool> setUserId(String id);
  Future<bool> get removeUserId;
  String? get getUserId;
}

class AuthLocalSourceImplement implements AuthLocalSource {
  final SharedPreferences sharedPreferences;

  AuthLocalSourceImplement({required this.sharedPreferences});
  @override
  String? get getUserId => sharedPreferences.getString('userId');
  @override
  Future<bool> get removeUserId async =>
      await sharedPreferences.remove('userId');

  @override
  Future<bool> setUserId(String id) =>
      sharedPreferences.setString('userId', id);
}

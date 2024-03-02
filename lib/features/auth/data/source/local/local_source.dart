import 'package:shared_preferences/shared_preferences.dart';

sealed class AuthLocalSource {
  Future<bool> setUserId(String id);
  Future<bool> get removeUserId;
  String? get getUserId;
  Future<bool> setUserName(String id);
  Future<bool> get removeUserName;
  String? get getUserName;
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

  @override
  String? get getUserName => sharedPreferences.getString('userName');
  @override
  Future<bool> get removeUserName async =>
      await sharedPreferences.remove('userName');

  @override
  Future<bool> setUserName(String userName) =>
      sharedPreferences.setString('userName', userName);
}

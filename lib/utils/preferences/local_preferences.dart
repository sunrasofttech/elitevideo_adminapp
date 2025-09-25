import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageUtils {
  static late final SharedPreferences instance;

  static Future<SharedPreferences> init() async => instance = await SharedPreferences.getInstance();

  static String? get userToken => instance.getString('token');
  static String? get userId => instance.getString('user_id');

  static Future<void>? saveUserId(String id) async {
    await instance.setString('user_id', id);
    log('User id saved to localstorage $id');
  }

  static Future<void> saveToken(String token) async {
    await instance.setString("token", token);
    log("Token saved! $token");
  }

  static Future<void> clear() async {
    await instance.clear();
  }
  
}

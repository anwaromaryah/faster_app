import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? sharedPreferences;

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }


  static Future<bool> set<T>(String key, T value) async {
    if (sharedPreferences == null) {
      await init();
    }

    switch (T) {
      case String:
        return sharedPreferences!.setString(key, value as String);
      case int:
        return sharedPreferences!.setInt(key, value as int);
      case double:
        return sharedPreferences!.setDouble(key, value as double);
      case bool:
        return sharedPreferences!.setBool(key, value as bool);

      default:
      // Handle unsupported types gracefully (e.g., throw an exception)
        throw UnsupportedError('Type $T is not currently supported for SharedPreferences');
    }
  }


  static void removeValue(String key) {
    sharedPreferences!.remove(key);
  }

  static String? getString(String key) {
    return sharedPreferences!.getString(key);

  }
  //
  //
  static Future<dynamic> get<T>(String key) async {
    if (sharedPreferences == null) {
      await init();
    }

    final value = sharedPreferences!.get(key);

    if (value == null) {
      return null;
    }

    switch (T) {
      case String:
        return sharedPreferences!.getString(key);
      case int:
        return sharedPreferences!.getInt(key);
      case double:
        return sharedPreferences!.getDouble(key);
      case bool:
        return sharedPreferences!.getBool(key);

      default:
        print('Warning: Type $T is not currently supported for retrieval from SharedPreferences');
        return null;
    }
  }


}
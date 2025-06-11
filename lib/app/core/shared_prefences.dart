import 'package:shared_preferences/shared_preferences.dart';

/// Remove apenas as chaves especificadas da instância de SharedPreferences.
Future<void> removeSharedPrefsKeys(List<String> keys) async {
  final prefs = await SharedPreferences.getInstance();
  for (final key in keys) {
    await prefs.remove(key);
  }
}
import 'package:shared_preferences/shared_preferences.dart';
import 'package:special_data_flutter/services/storage.dart';

setup() async {
  final prefs = await SharedPreferences.getInstance();

  if (prefs.getBool('first_run') ?? true) {
    await secureStorage.deleteAll();

    prefs.setBool('first_run', false);
  }
}

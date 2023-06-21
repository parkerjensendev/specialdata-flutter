import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorage = SecureStorage.instance();

class SecureStorage {
  static FlutterSecureStorage? _instance;

  static FlutterSecureStorage instance() {
    _instance ??= const FlutterSecureStorage();
    return _instance!;
  }
}

String rememberMeKey = "rememberMe";
String biometricKey = "biometrics";
String usernameKey = "username";
String passwordKey = "password";

String trueValue = "yeppers";
String falseValue = "nope";

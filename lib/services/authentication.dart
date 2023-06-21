import 'package:local_auth/local_auth.dart';

abstract class ALocalAuthenticationService {
  Future<bool> canCheckBiometrics();
  Future<BiometricType> getFirstAvailableBiometric();
  Future<bool> authenticate(String reason, AuthenticationOptions options);
  Future<bool> isDeviceSupported();
}

class LocalAuthenticationService implements ALocalAuthenticationService {
  final localAuth = LocalAuthentication();

  @override
  Future<bool> authenticate(
      String reason, AuthenticationOptions options) async {
    await localAuth.stopAuthentication();
    return localAuth.authenticate(localizedReason: reason, options: options);
  }

  @override
  Future<bool> canCheckBiometrics() async {
    return localAuth.canCheckBiometrics;
  }

  @override
  Future<BiometricType> getFirstAvailableBiometric() async {
    return (await localAuth.getAvailableBiometrics()).first;
  }

  @override
  Future<bool> isDeviceSupported() async {
    return localAuth.isDeviceSupported();
  }
}

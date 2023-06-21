import 'package:local_auth/local_auth.dart';
import 'package:special_data_flutter/services/authentication.dart';
import 'package:special_data_flutter/services/get_it.dart';
import 'package:special_data_flutter/services/storage.dart';

abstract class ABiometricsService {
  Future<bool> areBiometricsDeviceAvailable();
  Future<bool> areBiometricsUserEnabled();
  Future<BiometricType> getBiometricType();
  Future<bool> verifyBiometricsForSignIn();
}

class BiometricsService implements ABiometricsService {
  @override
  Future<bool> areBiometricsDeviceAvailable() async {
    var canCheckBiometrics =
        await getIt<ALocalAuthenticationService>().canCheckBiometrics();
    var containsAuthKey = await secureStorage.containsKey(key: passwordKey);
    var containsUsernameKey = await secureStorage.containsKey(key: usernameKey);
    if (!canCheckBiometrics || !containsUsernameKey || !containsAuthKey) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Future<bool> areBiometricsUserEnabled() async {
    var biometrics = await secureStorage.read(key: biometricKey);
    if (biometrics != null && biometrics == trueValue) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<BiometricType> getBiometricType() async {
    return await getIt<ALocalAuthenticationService>()
        .getFirstAvailableBiometric();
  }

  @override
  Future<bool> verifyBiometricsForSignIn() async {
    var password = await secureStorage.read(key: passwordKey);
    var username = await secureStorage.read(key: usernameKey);
    if (username == null || password == null) {
      return false;
    }

    bool authenticationSuccessful = await getIt<ALocalAuthenticationService>()
        .authenticate("Authenticate to log in",
            const AuthenticationOptions(biometricOnly: true));

    return authenticationSuccessful;
  }
}

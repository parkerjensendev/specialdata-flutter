import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

abstract class AUserParseService {
  Future<ParseUser> signIn(String username, String password);
}

class UserParseService implements AUserParseService {
  @override
  Future<ParseUser> signIn(String username, String password) async {
    var user = ParseUser(username, password, username);
    var signInResponse = await user.login();
    if (signInResponse.success) {
      return signInResponse.result as ParseUser;
    }

    throw (signInResponse.error!);
  }
}

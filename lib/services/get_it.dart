import 'package:get_it/get_it.dart';
import 'package:special_data_flutter/parse/student_parse_service.dart';
import 'package:special_data_flutter/services/authentication.dart';

import '../parse/parse_service.dart';
import '../parse/user_parse_service.dart';

final getIt = GetIt.instance;

registerGetIt() {
  getIt.registerSingleton<AParseService>(ParseService());
  getIt.registerSingleton<AStudentParseService>(StudentParseService());
  getIt.registerSingleton<AUserParseService>(UserParseService());
  getIt.registerLazySingleton<ALocalAuthenticationService>(
      () => LocalAuthenticationService());
}

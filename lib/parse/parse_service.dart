import 'package:special_data_flutter/parse/student_parse_service.dart';
import 'package:special_data_flutter/parse/user_parse_service.dart';
import 'package:special_data_flutter/services/get_it.dart';

abstract class AParseService {
  late AUserParseService userParseService;
  late AStudentParseService studentParseService;
}

class ParseService implements AParseService {
  @override
  AUserParseService userParseService = getIt<AUserParseService>();

  @override
  AStudentParseService studentParseService = getIt<AStudentParseService>();
}

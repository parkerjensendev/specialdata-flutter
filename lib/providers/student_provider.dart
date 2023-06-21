import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:special_data_flutter/parse/parse_service.dart';
import 'package:special_data_flutter/parse/student_parse_service.dart';
import 'package:special_data_flutter/services/get_it.dart';

final studentsFutureProvider = FutureProvider.autoDispose<List<Student>>((ref) {
  return getIt<ParseService>().studentParseService.getAllStudents();
});

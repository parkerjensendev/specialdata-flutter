import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

abstract class AStudentParseService {
  Future<List<Student>> getAllStudents();
}

class StudentParseService implements AStudentParseService {
  @override
  Future<List<Student>> getAllStudents() async {
    var studentResponse = await Student().getAll();
    if (studentResponse.success) {
      return studentResponse.results as List<Student>;
    }

    throw (studentResponse.error!);
  }
}

class Student extends ParseObject implements ParseCloneable {
  Student() : super(_keyTableName);
  Student.clone() : this();

  /// Looks strangely hacky but due to Flutter not using reflection, we have to
  /// mimic a clone
  @override
  clone(Map<String, dynamic> map) => Student.clone()..fromJson(map);

  static const String _keyTableName = 'Student';
  static const String keyName = 'name';
  static const String keySchoolName = 'schoolName';
  static const String keyGrade = 'grade';
  static const String keyServices = 'services';

  String get name => get<String>(keyName)!;
  set name(String name) => set<String>(keyName, name);

  String get schoolName => get<String>(keySchoolName)!;
  set schoolName(String schoolName) => set<String>(keySchoolName, schoolName);

  String get grade => get<String>(keyGrade)!;
  set grade(String grade) => set<String>(keyGrade, grade);

  List<Object> get services => get<List<Object>>(keyServices)!;
  set services(List<Object> services) =>
      set<List<Object>>(keyServices, services);
}

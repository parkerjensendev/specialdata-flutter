import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:special_data_flutter/parse/student_parse_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:special_data_flutter/providers/student_provider.dart';

class StudentsPage extends ConsumerStatefulWidget {
  const StudentsPage({super.key});

  @override
  ConsumerState<StudentsPage> createState() => _StudentsPage();
}

class _StudentsPage extends ConsumerState<StudentsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Students'),
        ),
        body: Center(child: studentsWidget()));
  }

  Widget studentsWidget() {
    final studentsAsync = ref.watch(studentsFutureProvider);
    // use pattern matching to map the state to the UI
    return studentsAsync.when(
        loading: () => const CircularProgressIndicator(),
        error: (err, stack) => Text('Error: $err'),
        data: (students) => ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) => Column(
                  children: [
                    Text(students[index].name),
                    Text(students[index].grade)
                  ],
                )));
  }
}

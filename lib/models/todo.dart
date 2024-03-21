import 'package:todo/utils/constants.dart';

class Todo {
  String title;
  DateTime dateTime;

  Todo({required this.title, required this.dateTime});

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        title: json[Constants.title],
        dateTime: DateTime.parse(json[Constants.dateTime]),
      );

  Map<String, dynamic> toJson() {
    return {
      Constants.title: title,
      Constants.dateTime: dateTime.toIso8601String(),
    };
  }
}

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/utils/constants.dart';

class TodoRepository {
  late SharedPreferences sharedPreferences;

  Future<List<Todo>> getTodoList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString(Constants.todListKey) ?? '[]';
    final List jsonDecoded = jsonDecode(jsonString) as List;
    return jsonDecoded.map((e) => Todo.fromJson(e)).toList();
  }

  void saveTodoList(List<Todo> todos) {
    final String jsonString = json.encode(todos);
    sharedPreferences.setString(Constants.todListKey, jsonString);
  }

  void clearTodoList() {
    sharedPreferences.setString(Constants.todListKey, "[]");
  }

  Future<List<Todo>> getTodoListComplete() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString(Constants.todListCompleteKey) ?? '[]';
    final List jsonDecoded = jsonDecode(jsonString) as List;
    return jsonDecoded.map((e) => Todo.fromJson(e)).toList();
  }

  void saveTodoListComplete(List<Todo> todos) {
    final String jsonString = json.encode(todos);
    sharedPreferences.setString(Constants.todListCompleteKey, jsonString);
  }

  void clearTodoListComplete() {
     sharedPreferences.setString(Constants.todListCompleteKey, "[]");
   }
}

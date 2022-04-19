import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarefas/models/tudo.dart';
import 'package:tarefas/utils/constants.dart';

class TodoRepository {

late SharedPreferences sharedPreferences; 
  
  // TodoRepository() {

  //   SharedPreferences.getInstance().then((value) {
  //     sharedPreferences = value;
  //     print(sharedPreferences.getString('todo_list'));
  //   });

  // }

  Future<List<Todo>> getTodoList() async{

    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString(Constants.TODOLISTKEY)?? '[]';
    final List jsonDecoded = jsonDecode(jsonString) as List;
    return jsonDecoded.map((e) => Todo.fronJson(e)).toList();
  }

  void saveTodoList(List<Todo> todos) {
  final String jsonString = json.encode(todos);
  print(jsonString);
  sharedPreferences.setString(Constants.TODOLISTKEY, jsonString);

}

}
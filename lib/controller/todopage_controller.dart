import 'package:flutter/material.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/repositories/todo_repositories.dart';

class ToDoPageController {
  final TextEditingController toDoController = TextEditingController();
  final TextEditingController editToDoController = TextEditingController();
  final FocusNode toDoFocus = FocusNode();
  List<Todo> toDos = [];
  List<Todo> toDosComplete = [];
  String textField = "";
  String editTextField = "";
  final TodoRepository todoRepository = TodoRepository();
  Todo? deletedTodo;
  int? deletedTodoPos;

  changeToCompleted(Todo todo) {
    getTodoListComplete().then((value) {
      toDosComplete.add(todo);
      todoRepository.saveTodoListComplete(toDosComplete);
      toDos.remove(todo);
      todoRepository.saveTodoList(toDos);
    });
  }

  getTodoListComplete() async {
    List<Todo> list = await todoRepository.getTodoListComplete();
    toDosComplete.clear();
    toDosComplete = list;
  }

  editTodo(Todo todo) {
    Todo editTodo = Todo(
      title: editToDoController.text,
      dateTime: DateTime.now(),
    );
    toDos.removeWhere((element) => element.dateTime == todo.dateTime);
    toDos.add(editTodo);
    textField = "";
    editToDoController.clear();
    todoRepository.saveTodoList(toDos);
  }
}

import 'package:flutter/material.dart';
import 'package:todo/pages/todo_list_page.dart';

void main(){
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ToDoListPage(),
      theme: ThemeData(
        primaryColorDark: const Color(0xff000000),
        primaryColor: const Color(0xff05DDF8)
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:tarefas/models/tudo.dart';

class TodosListItem extends StatelessWidget {
  TodosListItem({ Key? key, required this.todo, required this.onDelete,}) : super(key: key);
  
  final Todo todo;
  final Function(Todo) onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(10),
   child: Slidable(
  endActionPane: ActionPane(
    extentRatio: 0.25,
    motion: StretchMotion(),
    children: [
        SlidableAction(
        spacing: 7,
        onPressed: onDelete(todo) ,
        backgroundColor: Color.fromARGB(255, 248, 6, 6),
        foregroundColor: Colors.white,
        icon: Icons.delete,
        label: 'Delete',
      ),
    ],
  ),
       child: Container(
         padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25),
        bottomLeft: Radius.circular(25)),
        color: Colors.teal.shade100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          DateFormat('dd/MM/yyyy - HH:mm / EEEE').format(todo.dateTime),
         style: TextStyle(
        fontSize: 14,
      ),
      ),
        Text(todo.title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      ),
      ],
    ),
  ),
   ),
  );
  }
}
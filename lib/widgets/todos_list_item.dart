import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:todo/models/todo.dart';

class TodosListItem extends StatelessWidget {
  const TodosListItem({
    Key? key,
    required this.todo,
    required this.onDelete,
    this.onEdit,
    this.onComplete,
  }) : super(key: key);

  final Todo todo;
  final Function(Todo) onDelete;
  final Function(Todo)? onEdit;
  final Function(Todo)? onComplete;

  @override
  Widget build(BuildContext context) {
    double size() {
      if (onEdit != null && onComplete != null) {
        return 0.75;
      } else if (onEdit != null || onComplete != null) {
        return 0.5;
      } else {
        return 0.25;
      }
    }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Slidable(
        endActionPane: ActionPane(
          extentRatio: size(),
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              spacing: 7,
              onPressed: (_) => onDelete(todo),
              backgroundColor: const Color.fromARGB(255, 248, 6, 6),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
            Visibility(
              visible: onEdit != null,
              child: SlidableAction(
                spacing: 7,
                onPressed: (_) => onEdit!(todo),
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                icon: Icons.edit,
                label: 'Editar',
              ),
            ),
            Visibility(
              visible: onComplete != null,
              child: SlidableAction(
                spacing: 7,
                onPressed: (_) => onComplete!(todo),
                backgroundColor: Colors.lightGreen,
                foregroundColor: Colors.white,
                icon: Icons.check,
                label: 'Concluir',
              ),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25), bottomLeft: Radius.circular(25)),
            color: Colors.teal.shade100,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                DateFormat('dd/MM/yyyy - HH:mm').format(todo.dateTime),
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
              Text(
                todo.title,
                style: const TextStyle(
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

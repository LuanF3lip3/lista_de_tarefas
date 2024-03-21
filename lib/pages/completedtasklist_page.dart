import 'package:flutter/material.dart';
import 'package:todo/controller/todopage_controller.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/widgets/todos_list_item.dart';

class CompletedTaskListPage extends StatefulWidget {
  const CompletedTaskListPage({super.key});

  @override
  State<CompletedTaskListPage> createState() => _CompletedTaskListPageState();
}

class _CompletedTaskListPageState extends State<CompletedTaskListPage> {
  final ToDoPageController controller = ToDoPageController();

  @override
  initState() {
    controller.getTodoListComplete().then((value) {
      setState(() {
        controller.toDosComplete;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tarefas Concluídas",
          style: TextStyle(
            fontSize: 25,
            color: Colors.black,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).primaryColorDark,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView(
              children: [
                for (Todo toDo in controller.toDosComplete)
                  TodosListItem(
                    todo: toDo,
                    onDelete: onDelete,
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
                Expanded(
                  child: Text('Voce tem ${controller.toDosComplete.length} tarefas concluidas'),
                ),
                ElevatedButton(
                  onPressed:
                      controller.toDosComplete.isEmpty ? null : showDeleteTodosConfirmationDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.all(14),
                  ),
                  child: Text(
                    'Limpar tudo',
                    style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void showDeleteTodosConfirmationDialog() {
    showShowDialog(
      title: const Text('Tem certeza?'),
      content: const Text('!!!!CUIDADO!!!!'),
      actions: [
        TextButton(
          onPressed: (() {
            setState(() {
              controller.toDosComplete.clear();
              controller.todoRepository.clearTodoListComplete();
            });
            Navigator.of(context).pop();
          }),
          child: const Text('Sim'),
        ),
        TextButton(
          onPressed: (() {
            Navigator.of(context).pop();
          }),
          child: const Text('Nao'),
        ),
      ],
    );
  }

  void onDelete(Todo todo) {
    Todo deleted = todo;
    int position = controller.toDosComplete.indexOf(todo);
    setState(() {
      controller.toDosComplete.remove(todo);
      controller.todoRepository.saveTodoListComplete(controller.toDosComplete);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Tarefa deletada com sucesso!!!!',
        ),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: "Desfazer",
          onPressed: () {
            setState(() {
              controller.toDosComplete.insert(position, deleted);
              controller.todoRepository.saveTodoListComplete(controller.toDosComplete);
            });
          },
        ),
      ),
    );
  }

  showShowDialog({Widget? title, Widget? content, List<Widget>? actions}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: title,
        content: content,
        actions: actions,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:todo/controller/todopage_controller.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/pages/completedtasklist_page.dart';
import 'package:todo/widgets/todos_list_item.dart';

class ToDoListPage extends StatefulWidget {
  const ToDoListPage({Key? key}) : super(key: key);

  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  final ToDoPageController controller = ToDoPageController();

  @override
  void initState() {
    super.initState();

    controller.todoRepository.getTodoList().then((value) {
      setState(() {
        controller.toDos = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Lista de Tarefas",
          style: TextStyle(
            fontSize: 25,
            color: Theme.of(context).primaryColorDark,
          ),
        ),
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 15),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const CompletedTaskListPage();
                  },
                ),
              );
            },
            icon: Icon(
              Icons.checklist_rtl,
              color: Theme.of(context).primaryColorDark,
              size: 35,
            ),
          ),
        ],
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          controller.textField = value;
                        });
                      },
                      controller: controller.toDoController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'adicione uma tarefa',
                        hintText: 'EX: Estudar',
                      ),
                      focusNode: controller.toDoFocus,
                      onTapOutside: (x) {
                        controller.toDoFocus.unfocus();
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: controller.textField.isEmpty
                        ? null
                        : () {
                            setState(() {
                              Todo newTodo = Todo(
                                title: controller.toDoController.text,
                                dateTime: DateTime.now(),
                              );
                              controller.toDos.add(newTodo);
                              controller.textField = "";
                            });
                            controller.toDoController.clear();
                            controller.todoRepository.saveTodoList(controller.toDos);
                          },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(14),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: Icon(
                      Icons.add,
                      size: 35,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 18,
              ),
              Expanded(
                child: ListView(
                  children: [
                    for (Todo toDo in controller.toDos)
                      TodosListItem(
                        todo: toDo,
                        onDelete: onDelete,
                        onEdit: onEdit,
                        onComplete: onComplete,
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('Voce tem ${controller.toDos.length} tarefas pendentes'),
                    ),
                    ElevatedButton(
                      onPressed:
                          controller.toDos.isEmpty ? null : showDeleteTodosConfirmationDialog,
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
        ),
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
              controller.toDos.clear();
              controller.todoRepository.clearTodoList();
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
    int position = controller.toDos.indexOf(todo);
    setState(() {
      controller.toDos.remove(todo);
      controller.todoRepository.saveTodoList(controller.toDos);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Tarefa deletada com sucesso!!!!',
          style: TextStyle(),
        ),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: "Desfazer",
          onPressed: () {
            setState(() {
              controller.toDos.insert(position, deleted);
              controller.todoRepository.saveTodoList(controller.toDos);
            });
          },
        ),
      ),
    );
  }

  void onEdit(Todo todo) {
    controller.editTextField = todo.title;
    controller.editToDoController.text = todo.title;
    showShowDialog(
      title: const Text('Editando...'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            onChanged: (value) {
              setState(() {
                controller.editTextField = value;
              });
            },
            controller: controller.editToDoController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Edite a tarefa',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: (() {
            Navigator.of(context).pop();
          }),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: (() {
            setState(() {
              controller.editTodo(todo);
            });
            Navigator.of(context).pop();
          }),
          child: const Text('Editar'),
        ),
      ],
    );
  }

  void onComplete(Todo todo) {
    showShowDialog(
      title: const Text('Deseja concluir a tarefa?'),
      actions: [
        TextButton(
          onPressed: (() {
            Navigator.of(context).pop();
          }),
          child: const Text('Não'),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              controller.changeToCompleted(todo);
            });
            Navigator.of(context).pop();
          },
          child: const Text('Sim'),
        ),
      ],
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

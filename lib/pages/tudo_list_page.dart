import 'package:flutter/material.dart';
import 'package:tarefas/models/tudo.dart';
import 'package:tarefas/widgets/todos_list_item.dart';

class ToDoListPage extends StatefulWidget {
  const ToDoListPage({ Key? key }) : super(key: key);

  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

final TextEditingController toDoController = TextEditingController();
List<Todo> ToDos = [];
bool textIsEnpty = false;


class _ToDoListPageState extends State<ToDoListPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: 
     Scaffold(
      body: Center(
        child:Expanded(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [ Text('Lista de Tarefas',
              style: TextStyle(fontSize: 30),),
                Row(children:[ Expanded(
                 child:TextField(

                   controller: toDoController,
                decoration: InputDecoration(
               border: OutlineInputBorder(),
               labelText: 'adicione uma tarefa',
               hintText:  'EX: Estudar',
              ),
            ), 
          ),
          SizedBox(width: 10,),
        ElevatedButton(onPressed: (){
          String text = toDoController.text;
          textIsEnpty ? null :
          setState(() {
            Todo newtodo = Todo(title: text, dateTime: DateTime.now(),);
          ToDos.add(newtodo);
          });
          toDoController.clear();
        }, 
        child: Icon(Icons.add,
        size: 35,
        color: Colors.black,
        ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(14),
          primary: Color(0xff00FF3E),
        ),
            ),
           ],
          ),
          SizedBox(height: 18,),
          Flexible(
            child:ListView(
            shrinkWrap: true,
            children: [
              for (Todo toDo in ToDos)
              TodosListItem(todo: toDo,
              onDelete: onDelete,
              ),
          SizedBox(height: 18,)
             ] 
            )
          ), 
          Row(
            children: [
              Expanded(
                child:Text('Voce nao tem ${ToDos.length} tarefas pendentes'),
              ),
            ElevatedButton(onPressed: 
              showDeleteTodosConfimationDialog, 
        child:Text('Limpar tudo',
        style: TextStyle(
          color: Colors.black,
              ),
            ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(14),
          primary: Color(0xff00FF3E),
        ),
            ),
            ],
          )
              ],
            )
          ),
        ),
      ),
     ),
    );
  }


  void showDeleteTodosConfimationDialog(){
    showDialog(context: context, builder: (context) => AlertDialog(
      title: Text('Tem certeza?'),
      content: Text('!!!!CUIDADO!!!!'),
      actions: [TextButton(onPressed: (() {
        setState(() {
        ToDos.clear();
        });
      Navigator.of(context).pop();
      }),
       child: Text('Sim'), 
       ),
       TextButton(onPressed: (() {
         Navigator.of(context).pop();
       }),
       child: Text('Nao'), 
       ),
       ],

    ));
  }


   void onDelete(Todo todo) {
      setState(() {
      ToDos.remove(todo);
      });
    }
    
}
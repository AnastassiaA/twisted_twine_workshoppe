import 'package:flutter/material.dart';
import 'package:twisted_twine_workshopppe/Controllers/todo_controller.dart';
import 'package:twisted_twine_workshopppe/Models/Models/todo_model.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  List<TodoModel> todoList = [];
  bool isLoading = true;
  bool isChanged = false;
  final controller = TextEditingController();

  getTodos() async {
    final todoData = await TodoController.getAllTodos();

    setState(() {
      todoList = todoData.map((e) => TodoModel.fromMap(e)).toList();
      isLoading = false;
    });
  }

  void deleteTodo({required TodoModel todo, required BuildContext context}) {
    TodoController.deleteTodo(todo.todoId!).then((value) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('To Do Deleted')));
    }).catchError((e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    });
  }

  void form(id) async {
    if (id != null) {
      final thisTodoType =
          todoList.firstWhere((element) => element.todoId == id);
      controller.text = thisTodoType.todo;
    }

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      autofocus: true,
                      controller: controller,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () async {
                                if (id == null) {
                                  await TodoController.createTodo(TodoModel(
                                    todo: controller.text,
                                  ));
                                }
                                if (id != null) {
                                  await TodoController.updateTodo(TodoModel(
                                    todoId: id,
                                    todo: controller.text,
                                  ));
                                }

                                controller.clear();

                                if (!mounted) return;
                                Navigator.pop(context);
                                refresh();
                              },
                              icon: const Icon(Icons.arrow_forward_outlined)),
                          border: InputBorder.none,
                          hintText: 'Add Todo'),
                    ),
                  ]),
            );
          });
        });
  }

  Future refresh() async {
    todoList.clear();
    getTodos();
  }

  @override
  void initState() {
    getTodos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("To Do"),
        actions: const [
          IconButton(onPressed: null, icon: Icon(Icons.sort)),
        ],
      ),
      body: ListView.builder(
          itemCount: todoList.length,
          itemBuilder: (context, index) {
            final todo = todoList[index];
            return GestureDetector(
              onDoubleTap: () {
                form(todo.todoId);
              },
              onLongPress: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Delete To Do?'),
                        
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(
                                context,
                              );
                            },
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              deleteTodo(todo: todo, context: context);
                              //todoList.removeAt(index);
                              refresh();
                              Navigator.pop(
                                context,
                              );
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      );
                    });
              },
              child: Card(
                child: ListTile(
                  leading: Checkbox(
                      value: todo.isComplete,
                      onChanged: (value) {
                        setState(() {
                          todo.isComplete = value!;

                          if (todo.isComplete == true) {
                            Future.delayed(const Duration(seconds: 8));
                            deleteTodo(todo: todo, context: context);

                            todoList.removeAt(index);
                          }
                        });
                      }),
                  title: Text(todo.todo),
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          form(null);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

import 'package:twisted_twine_workshopppe/Models/Const/todo_const.dart';

class TodoModel {
  final int? todoId;
  final String todo;
  bool? isComplete = false;

  TodoModel({this.todoId, required this.todo, this.isComplete});

  Map<String, dynamic> toMap() {
    return {
      TodoConst.todoId: todoId,
      TodoConst.todo: todo,
      TodoConst.isComplete: isComplete == true ? 1 : 0,
    };
  }

  factory TodoModel.fromMap(Map<String, dynamic> json) => TodoModel(
      todoId: json[TodoConst.todoId],
      todo: json[TodoConst.todo],
      isComplete: json[TodoConst.isComplete] == 0 ? false : true);
}

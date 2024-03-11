import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import '../Models/Const/todo_const.dart';
import '../Models/Models/todo_model.dart';
import 'database.dart';

class TodoController {
  static Future<int> createTodo(TodoModel todo) async {
    final db = await SQLHelper.db();

    final data = {
      TodoConst.todo: todo.todo,
      TodoConst.isComplete: todo.isComplete == true ? 1 : 0,
    };

    final id = await db.insert(TodoConst.tableName, data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllTodos() async {
    final db = await SQLHelper.db();
    return db.query(TodoConst.tableName, orderBy: TodoConst.todoId);
  }

  static Future<int> updateTodo(TodoModel todo) async {
    final db = await SQLHelper.db();

    final data = {
      TodoConst.todo: todo.todo,
      TodoConst.isComplete: todo.isComplete == true ? 1 : 0,
    };

    final result = await db.update(TodoConst.tableName, data,
        where: "${TodoConst.todoId} = ?", whereArgs: [todo.todoId]);

    return result;
  }

  static Future<void> deleteTodo(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete(TodoConst.tableName,
          where: "${TodoConst.todoId} = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}

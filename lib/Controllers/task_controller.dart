import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;

import '../Models/Const/task_const.dart';
import 'database.dart';
import '../Models/Models/task_model.dart';

class TaskController {


  static Future<int> createTask(TaskModel task) async {
    final db = await SQLHelper.db();

    final data  = {
      TaskConst.taskName: task.taskName,
      TaskConst.image: task.image,
      TaskConst.customer: task.customer,
      TaskConst.dateStarted: task.dateStarted!.toIso8601String(),
      TaskConst.dateCompleted: task.dateCompleted!.toIso8601String(),
      TaskConst.craftType: task.craftType,
      TaskConst.status: task.status,
      TaskConst.description: task.description,
      TaskConst.taskType: task.taskType,
      TaskConst.depositMade: task.depositMade,
    };

    final id = await db.insert(TaskConst.tableName, data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;

  }

  static Future<List<Map<String, dynamic>>> getAllTasksOfType(String type) async {
    final db = await SQLHelper.db();
    return db.query(TaskConst.tableName, where: "${TaskConst.taskType} = ?", whereArgs: [type], orderBy: TaskConst.taskNumber);
  }

  static Future<List<Map<String, dynamic>>> getAllTasks() async {
    final db = await SQLHelper.db();
    return db.query(TaskConst.tableName, orderBy: TaskConst.taskNumber);
  }

  static Future<List<Map<String, dynamic>>> getOneTask(int id) async {
    final db = await SQLHelper.db();
    return db.query(TaskConst.tableName,
        where: "${TaskConst.taskNumber} = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateTask(TaskModel task) async {
    final db = await SQLHelper.db();

    final data = {
      TaskConst.taskName : task.taskName,
      TaskConst.image : task.image,
      TaskConst.customer : task.customer,
      TaskConst.dateStarted : task.dateStarted!.toIso8601String(),
      TaskConst.dateCompleted : task.dateCompleted!.toIso8601String(),
      TaskConst.craftType : task.craftType,
      TaskConst.status : task.status,
      TaskConst.description : task.description,
      TaskConst.taskType: task.taskType,
      TaskConst.depositMade : task.depositMade,
    };

    final result = await db.update(TaskConst.tableName, data,
        where: "${TaskConst.taskNumber} = ?", whereArgs: [task.taskNumber]);
    return result;
  }

  // Delete
  static Future<void> deleteTask(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete(TaskConst.tableName,
          where: "${TaskConst.taskNumber} = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}

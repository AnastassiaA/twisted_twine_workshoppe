import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:twisted_twine_workshopppe/Models/Const/history_const.dart';
import 'package:twisted_twine_workshopppe/Models/Models/history_model.dart';
import 'database.dart';

class HistoryController {
  static Future<int> createHistory(HistoryModel history) async {
    final db = await SQLHelper.db();

    final data = {
      HistoryConst.name: history.name,
      HistoryConst.completionStatus: history.completionStatus,
      HistoryConst.craftType: history.craftType,
      HistoryConst.monthYear: history.monthYear!.toIso8601String(),
      HistoryConst.description: history.description
    };

    final id = await db.insert(HistoryConst.tableName, data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllHistory() async {
    final db = await SQLHelper.db();

    return db.query(HistoryConst.tableName, orderBy: HistoryConst.historyId);
  }

  static Future<List<Map<String, dynamic>>> getOneHistory(int id) async {
    final db = await SQLHelper.db();

    return db.query(HistoryConst.tableName,
        where: "${HistoryConst.historyId} =?",
        whereArgs: [id],
        limit: 1);
  } 

  static Future<int> updateHistory(HistoryModel history) async {
    final db = await SQLHelper.db();

    final data = {
      HistoryConst.name: history.name,
      HistoryConst.completionStatus: history.completionStatus,
      HistoryConst.craftType: history.craftType,
      HistoryConst.monthYear: history.monthYear!.toIso8601String(),
      HistoryConst.description: history.description
    };

    final result = await db.update(HistoryConst.tableName, data,
        where: "${HistoryConst.historyId} =?",
        whereArgs: [history.historyId]);

    return result;
  }

  static Future<void> deleteHistory(int id) async {
    final db = await SQLHelper.db();

    try {
      await db.delete(
        HistoryConst.tableName,
        where: "${HistoryConst.historyId} =?",
        whereArgs: [id],
      );
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}

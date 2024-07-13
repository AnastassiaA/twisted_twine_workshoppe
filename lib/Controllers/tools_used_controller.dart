import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import '../Models/Const/tools_used_const.dart';
import '../Models/Models/tools_used_model.dart';
import 'database.dart';

class ToolsUsedController {
  static Future<int> createToolsUsed(ToolsUsedModel tool) async {
    final db = await SQLHelper.db();

    final data = {
      ToolsUsedConst.taskNumber: tool.taskNumber,
      ToolsUsedConst.toolId: tool.toolId,
    };

    final id = await db.insert(ToolsUsedConst.tableName, data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllToolsUsed(int id) async {
    final db = await SQLHelper.db();

    return db.query(ToolsUsedConst.tableName,
        where: "${ToolsUsedConst.taskNumber} =?",
        whereArgs: [id],
        );
  }

  static Future<List<Map<String, dynamic>>> getOneTools(int id) async {
    final db = await SQLHelper.db();

    return db.query(ToolsUsedConst.tableName,
        where: "${ToolsUsedConst.toolUsedId} =?",
        whereArgs: [id],
        limit: 1);

  }

  static Future<int> updateToolsUsed(ToolsUsedModel tool) async {
    final db = await SQLHelper.db();

    final data = {
      ToolsUsedConst.taskNumber: tool.taskNumber,
      ToolsUsedConst.toolId: tool.toolId,
      };

    final result = await db.update(ToolsUsedConst.tableName, data,
        where: "${ToolsUsedConst.toolUsedId} =?",
        whereArgs: [tool.toolUsedId]);

    return result;
  }

  static Future<void> deleteToolsUsed(int id) async {
    final db = await SQLHelper.db();

    try {
      await db.delete(
        ToolsUsedConst.tableName,
        where: "${ToolsUsedConst.toolUsedId} =?",
        whereArgs: [id],
      );
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
   
}
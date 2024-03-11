import 'package:twisted_twine_workshopppe/Models/Const/tools_const.dart';
import 'package:twisted_twine_workshopppe/Models/Models/tools_model.dart';

import 'database.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;

class ToolsController {
  static Future<int> createTools(ToolsModel tool) async {
    final db = await SQLHelper.db();

    final data = {
      ToolsConst.toolName: tool.toolName,
      ToolsConst.image: tool.image
    };

    final id = await db.insert(ToolsConst.tableName, data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllTools() async {
    final db = await SQLHelper.db();

    return db.query(ToolsConst.tableName,
        orderBy: ToolsConst.toolsId);
  }

  static Future<List<Map<String, dynamic>>> getOneTools(int id) async {
    final db = await SQLHelper.db();

    return db.query(ToolsConst.tableName,
        where: "${ToolsConst.toolsId} =?",
        whereArgs: [id],
        limit: 1);
  }

  static Future<int> updateTools(ToolsModel tool) async {
    final db = await SQLHelper.db();

    final data = {
      ToolsConst.toolName: tool.toolName,
      ToolsConst.image: tool.image
      };

    final result = await db.update(ToolsConst.tableName, data,
        where: "${ToolsConst.toolsId} =?",
        whereArgs: [tool.toolsId]);

    return result;
  }

  static Future<void> deleteTools(int id) async {
    final db = await SQLHelper.db();

    try {
      await db.delete(
        ToolsConst.tableName,
        where: "${ToolsConst.toolsId} =?",
        whereArgs: [id],
      );
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
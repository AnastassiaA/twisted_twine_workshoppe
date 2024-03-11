import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:twisted_twine_workshopppe/Models/Const/crochet_hook_used_const.dart';
import 'package:twisted_twine_workshopppe/Models/Models/crochet_hook_used_model.dart';
import 'database.dart';

class CrochetHookUsedController {
  static Future<int> createHookUsed(CrochetHookUsedModel hook) async {
    final db = await SQLHelper.db();

    final data = {
      CrochetHookUsedConst.crochetHookId: hook.crochetHookId,
      CrochetHookUsedConst.taskNumber: hook.taskNumber
    };

    final id = await db.insert(CrochetHookUsedConst.tableName, data,
        conflictAlgorithm: sql.ConflictAlgorithm.ignore);

    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllHookUsed(int id) async {
    final db = await SQLHelper.db();

    return db.query(CrochetHookUsedConst.tableName,
        where: "${CrochetHookUsedConst.taskNumber} = ?",
        whereArgs: [id],
        orderBy: CrochetHookUsedConst.crochetHookUsedId);
  }

  static Future<List<Map<String, dynamic>>> getOneHookUsed(int id) async {
    final db = await SQLHelper.db();
    return db.query(CrochetHookUsedConst.tableName,
        where: "${CrochetHookUsedConst.crochetHookUsedId} = ?",
        whereArgs: [id]);
  }

  static Future<int> updateHookUsed(CrochetHookUsedModel hook) async {
    final db = await SQLHelper.db();

    final data = {
      CrochetHookUsedConst.crochetHookId: hook.crochetHookId,
      CrochetHookUsedConst.taskNumber: hook.taskNumber
    };

    final result = await db.update(CrochetHookUsedConst.tableName, data,
        where: "${CrochetHookUsedConst.crochetHookUsedId} = ?",
        whereArgs: [hook.crochetHookUsedId]);

    return result;
  }

  static Future<void> deleteHookUsed(int id) async {
    final db = await SQLHelper.db();

    try{
      await db.delete(CrochetHookUsedConst.tableName, where: "${CrochetHookUsedConst.crochetHookUsedId} = ?",whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  } 
}
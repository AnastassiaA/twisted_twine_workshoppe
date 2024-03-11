import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import '../Models/Const/crochet_thread_used_const.dart';
import '../Models/Models/crochet_thread_used_model.dart';
import 'database.dart';

class CrochetThreadUsedController {
  static Future<int> createThreadUsed(CrochetThreadUsedModel thread) async {
    final db = await SQLHelper.db();

    final data = {
      CrochetThreadUsedConst.crochetThreadnumber: thread.crochetThreadnumber,
      CrochetThreadUsedConst.taskNumber: thread.taskNumber,
      CrochetThreadUsedConst.amountUsed: thread.amountUsed,
    };

    final id = await db.insert(CrochetThreadUsedConst.tableName, data,
        conflictAlgorithm: sql.ConflictAlgorithm.rollback);

    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllThreadUsed(int id) async {
    final db = await SQLHelper.db();

    return db.query(CrochetThreadUsedConst.tableName,
        where: "${CrochetThreadUsedConst.taskNumber} = ?",
        whereArgs: [id],
        orderBy: CrochetThreadUsedConst.crochetThreadUsedid);
  }

  static Future<List<Map<String, dynamic>>> getOneThreadUsed(int id) async {
    final db = await SQLHelper.db();
    return db.query(CrochetThreadUsedConst.tableName,
        where: "${CrochetThreadUsedConst.crochetThreadUsedid} = ?",
        whereArgs: [id]);
  }

  static Future<int> updateThreadUsed(CrochetThreadUsedModel thread) async {
    final db = await SQLHelper.db();

    final data = {
      CrochetThreadUsedConst.crochetThreadnumber: thread.crochetThreadnumber,
      CrochetThreadUsedConst.taskNumber: thread.taskNumber,
      CrochetThreadUsedConst.amountUsed: thread.amountUsed,
    };

    final result = await db.update(CrochetThreadUsedConst.tableName, data,
        where: "${CrochetThreadUsedConst.crochetThreadUsedid} = ?",
        whereArgs: [thread.crochetThreadUsedid]);

    return result;
  }

  static Future<void> deleteThreadUsed(int id) async {
    final db = await SQLHelper.db();

    try{
      await db.delete(CrochetThreadUsedConst.tableName, where: "${CrochetThreadUsedConst.crochetThreadUsedid} = ?",whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }  
}

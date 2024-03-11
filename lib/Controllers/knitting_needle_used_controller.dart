import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:twisted_twine_workshopppe/Models/Const/knitting_needle_used_const.dart';
import 'package:twisted_twine_workshopppe/Models/Models/knitting_needle_used_model.dart';
import 'database.dart';

class KnittingNeedleUsedController {
  static Future<int> createNeedleUsed(KnittingNeedleUsedModel needle) async {
    final db = await SQLHelper.db();

    final data = {
      KnittingNeedleUsedConst.knittingNeedleId: needle.knittingNeedleId,
      KnittingNeedleUsedConst.taskNumber: needle.taskNumber
    };

    final id = await db.insert(KnittingNeedleUsedConst.tableName, data,
        conflictAlgorithm: sql.ConflictAlgorithm.ignore);

    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllNeedleUsed(int id) async {
    final db = await SQLHelper.db();

    return db.query(KnittingNeedleUsedConst.tableName,
        where: "${KnittingNeedleUsedConst.taskNumber} = ?",
        whereArgs: [id],
        orderBy: KnittingNeedleUsedConst.knittingNeedleUsedId);
  }

  static Future<List<Map<String, dynamic>>> getOneNeedleUsed(int id) async {
    final db = await SQLHelper.db();
    return db.query(KnittingNeedleUsedConst.tableName,
        where: "${KnittingNeedleUsedConst.knittingNeedleUsedId} = ?",
        whereArgs: [id]);
  }

  static Future<int> updateNeedleUsed(KnittingNeedleUsedModel needle) async {
    final db = await SQLHelper.db();

    final data = {
      KnittingNeedleUsedConst.knittingNeedleId: needle.knittingNeedleId,
      KnittingNeedleUsedConst.taskNumber: needle.taskNumber
    };

    final result = await db.update(KnittingNeedleUsedConst.tableName, data,
        where: "${KnittingNeedleUsedConst.knittingNeedleUsedId} = ?",
        whereArgs: [needle.knittingNeedleUsedId]);

    return result;
  }

  static Future<void> deleteNeedleUsed(int id) async {
    final db = await SQLHelper.db();

    try{
      await db.delete(KnittingNeedleUsedConst.tableName, where: "${KnittingNeedleUsedConst.knittingNeedleUsedId} = ?",whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  } 

}

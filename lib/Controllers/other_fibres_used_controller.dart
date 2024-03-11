import 'package:twisted_twine_workshopppe/Models/Const/other_fibres_used_const.dart';
import 'package:twisted_twine_workshopppe/Models/Models/other_fibres_used_model.dart';

import 'database.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;

class OtherFibresUsedController {
  static Future<int> createFibresUsed(OtherFibresUsedModel fibresUsed) async {
    final db = await SQLHelper.db();

    final data = {
      OtherFibresUsedConst.taskNumber: fibresUsed.taskNumber,
      OtherFibresUsedConst.otherFibresId: fibresUsed.otherFibresId,
      OtherFibresUsedConst.amount: fibresUsed.amount,
    };

    final id = await db.insert(OtherFibresUsedConst.tableName, data,
        conflictAlgorithm: sql.ConflictAlgorithm.rollback);

    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllFibresUsed(int id) async {
    final db = await SQLHelper.db();
    return db.query(OtherFibresUsedConst.tableName, where: "${OtherFibresUsedConst.taskNumber} = ?", whereArgs: [id],
    //id would be order number
        orderBy: OtherFibresUsedConst.otherFibresUsedId);
  }

  static Future<List<Map<String, dynamic>>> getOneFibresUsed(int id) async {
    final db = await SQLHelper.db();
    return db.query(OtherFibresUsedConst.tableName,
        where: "${OtherFibresUsedConst.otherFibresUsedId} = ?", whereArgs: [id]);
  }

  static Future<int> updateFibreUsed(OtherFibresUsedModel fibresUsed) async {
    final db = await SQLHelper.db();

    final data = {
    
      OtherFibresUsedConst.taskNumber: fibresUsed.taskNumber,
      OtherFibresUsedConst.otherFibresId: fibresUsed.otherFibresId,
      OtherFibresUsedConst.amount: fibresUsed.amount,
    
    };

    final result = await db.update(OtherFibresUsedConst.tableName, data,
    where: "${OtherFibresUsedConst.otherFibresUsedId} = ?", whereArgs: [fibresUsed.otherFibresUsedId]);

    return result;
  }

  static Future<void> deleteFibreUsed(int id) async {
    final db = await SQLHelper.db();

    try{
      await db.delete(OtherFibresUsedConst.tableName, where: "${OtherFibresUsedConst.otherFibresUsedId} = ?",whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
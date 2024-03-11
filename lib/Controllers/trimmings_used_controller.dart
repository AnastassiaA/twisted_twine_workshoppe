import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:twisted_twine_workshopppe/Models/Const/trimmings_used_const.dart';
import 'package:twisted_twine_workshopppe/Models/Models/trimmings_used_model.dart';
import 'database.dart';

class TrimmingsUsedController {
  static Future<int> createTrimmingsUsed(TrimmingsUsedModel trimmings) async {
    final db = await SQLHelper.db();

    final data = {
      TrimmingsUsedConst.trimmingId: trimmings.trimmingId,
      TrimmingsUsedConst.taskNumber: trimmings.taskNumber,
      TrimmingsUsedConst.amountUsed: trimmings.amountUsed,
    };

    final id = await db.insert(TrimmingsUsedConst.tableName, data,
        conflictAlgorithm: sql.ConflictAlgorithm.ignore);

    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllTrimmingsUsed(int id) async {
    final db = await SQLHelper.db();

    return db.query(
      TrimmingsUsedConst.tableName,
      where: "${TrimmingsUsedConst.taskNumber} = ?",
      whereArgs: [id],
      orderBy: TrimmingsUsedConst.trimmingsUsedId,
    );
  }

  static Future<List<Map<String, dynamic>>> getOneTrimmingsUsed(int id) async {
    final db = await SQLHelper.db();
    return db.query(TrimmingsUsedConst.tableName,
        where: "${TrimmingsUsedConst.trimmingsUsedId} = ?",
        whereArgs: [id]);
  }

  static Future<int> updateTrimmingsUsed(TrimmingsUsedModel trimmings) async {
    final db = await SQLHelper.db();

    final data = {
      TrimmingsUsedConst.trimmingId: trimmings.trimmingId,
      TrimmingsUsedConst.taskNumber: trimmings.taskNumber,
      TrimmingsUsedConst.amountUsed: trimmings.amountUsed,
    };

    final result = await db.update(TrimmingsUsedConst.tableName, data,
        where: "${TrimmingsUsedConst.trimmingsUsedId} = ?",
        whereArgs: [trimmings.trimmingsUsedId]);

    return result;
  }

  static Future<void> deleteTrimmingsUsed(int id) async {
    final db = await SQLHelper.db();

    try{
      await db.delete(TrimmingsUsedConst.tableName, where: "${TrimmingsUsedConst.trimmingsUsedId} = ?",whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}

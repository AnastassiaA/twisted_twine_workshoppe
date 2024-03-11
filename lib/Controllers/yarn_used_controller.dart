import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import '../Models/Const/yarn_used_const.dart';
import '../Models/Models/yarn_used_model.dart';
import 'database.dart';

class YarnUsedOrderController {
  static Future<int> createYarnUsed(YarnUsedOrderModel yarnUsed) async {
    final db = await SQLHelper.db();

    final data = {
      YarnUsedConst.yarnNumber: yarnUsed.thisYarnNumber,
      YarnUsedConst.taskNumber: yarnUsed.thisOrderNumber,
      YarnUsedConst.amountUsed: yarnUsed.amountUsed,
    };

    final id = await db.insert(YarnUsedConst.tableName, data,
        conflictAlgorithm: sql.ConflictAlgorithm.rollback);

    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllYarnUsed(int id) async {
    final db = await SQLHelper.db();
    return db.query(YarnUsedConst.tableName, where: "${YarnUsedConst.taskNumber} = ?", whereArgs: [id],
    //id would be order number
        orderBy: YarnUsedConst.yarnUsedNumber);
  }

  static Future<List<Map<String, dynamic>>> getOneYarnUsed(int id) async {
    final db = await SQLHelper.db();
    return db.query(YarnUsedConst.tableName,
        where: "${YarnUsedConst.yarnUsedNumber} = ?", whereArgs: [id]);
  }

  static Future<int> updateYarnUsed(YarnUsedOrderModel yarnUsed) async {
    final db = await SQLHelper.db();

    final data = {
      
      YarnUsedConst.taskNumber: yarnUsed.thisOrderNumber,
      YarnUsedConst.amountUsed: yarnUsed.amountUsed,
    };

    final result = await db.update(YarnUsedConst.tableName, data,
    where: "${YarnUsedConst.yarnUsedNumber} = ?", whereArgs: [yarnUsed.yarnUsedNumber]);

    return result;
  }

  static Future<void> deleteYarnUsed(int id) async {
    final db = await SQLHelper.db();

    try{
      await db.delete(YarnUsedConst.tableName, where: "${YarnUsedConst.yarnUsedNumber} = ?",whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}

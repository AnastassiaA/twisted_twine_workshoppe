import '../Models/Const/fabrics_used_const.dart';
import '../Models/Models/fabrics_used_model.dart';
import 'database.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;

class FabricUsedController {
  static Future<int> createFabricsUsed(FabricsUsedModel fabric) async {
    final db = await SQLHelper.db();

    final data = {
      FabricsUsedConst.fabricsId: fabric.fabricsId,
      FabricsUsedConst.taskNumber: fabric.taskNumber,
    };

    final id = await db.insert(FabricsUsedConst.tableName, data,
        conflictAlgorithm: sql.ConflictAlgorithm.rollback);

    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllFabricsUsed(int id) async {
    final db = await SQLHelper.db();
    return db.query(FabricsUsedConst.tableName, where: "${FabricsUsedConst.taskNumber} = ?", whereArgs: [id],
    //id would be order number
        orderBy: FabricsUsedConst.fabricsUsedId);
  }

  static Future<List<Map<String, dynamic>>> getOneFabricUsed(int id) async {
    final db = await SQLHelper.db();
    return db.query(FabricsUsedConst.tableName,
        where: "${FabricsUsedConst.fabricsUsedId} = ?", whereArgs: [id]);
  }

  static Future<int> updateFabricUsed(FabricsUsedModel fabric) async {
    final db = await SQLHelper.db();

    final data = {
       FabricsUsedConst.fabricsId: fabric.fabricsId,
      FabricsUsedConst.taskNumber: fabric.taskNumber,
    };

    final result = await db.update(FabricsUsedConst.tableName, data,
    where: "${FabricsUsedConst.fabricsUsedId} = ?", whereArgs: [fabric.fabricsUsedId]);

    return result;
  }

  static Future<void> deleteFabricUsed(int id) async {
    final db = await SQLHelper.db();

    try{
      await db.delete(FabricsUsedConst.tableName, where: "${FabricsUsedConst.fabricsUsedId} = ?",whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import '../Models/Const/knitting_needle_const.dart';
import '../Models/Models/knitting_needle_model.dart';
import 'database.dart';

class KnittingNeedleController {
  static Future<int> createKnittingNeedle(KnittingNeedleModel needle) async {
    final db = await SQLHelper.db();

    final data = {
      KnittingNeedleConst.knittingNeedleSize: needle.knittingNeedleSize,
      KnittingNeedleConst.image: needle.image,
      KnittingNeedleConst.knittingNeedleType: needle.knittingNeedleType
    };

    final id = await db.insert(KnittingNeedleConst.tableName, data,
        conflictAlgorithm: sql.ConflictAlgorithm.rollback);

    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllKnittingNeedles() async {
    final db = await SQLHelper.db();

    return db.query(KnittingNeedleConst.tableName,
        
        orderBy: KnittingNeedleConst.knittingNeedleId);
  }

  static Future<List<Map<String, dynamic>>> getOneKnittingNeedle(int id) async {
    final db = await SQLHelper.db();
    return db.query(KnittingNeedleConst.tableName,
        where: "${KnittingNeedleConst.knittingNeedleId} = ?",
        whereArgs: [id]);
  }

  static Future<int> updateKnittingNeedle(KnittingNeedleModel needle) async {
    final db = await SQLHelper.db();

    final data = {
      KnittingNeedleConst.knittingNeedleId: needle.knittingNeedleId,
      KnittingNeedleConst.knittingNeedleSize: needle.knittingNeedleSize,
      KnittingNeedleConst.image: needle.image,
      KnittingNeedleConst.knittingNeedleType: needle.knittingNeedleType
    };

    final result = await db.update(KnittingNeedleConst.tableName, data,
        where: "${KnittingNeedleConst.knittingNeedleId} = ?",
        whereArgs: [needle.knittingNeedleId]);

    return result;
  }

  static Future<void> deleteKnittingNeedle(int id) async {
    final db = await SQLHelper.db();

    try{
      await db.delete(KnittingNeedleConst.tableName, where: "${KnittingNeedleConst.knittingNeedleId} = ?",whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}

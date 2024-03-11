import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;

import '../Models/Const/knitting_needle_type_const.dart';
import '../Models/Models/knitting_needle_type_model.dart';
import 'database.dart';

class KnittingNeedleTypeController {
  static Future<int> createNeedleType(KnittingNeedleTypeModel type) async {
    final db = await SQLHelper.db();

    final data = {
      KnittingNeedleTypeConst.needleTypeName: type.needleTypeName
    };

    final id = await db.insert(KnittingNeedleTypeConst.tableName, data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllNeedleTypes() async {
    final db = await SQLHelper.db();

    return db.query(KnittingNeedleTypeConst.tableName,
        orderBy: KnittingNeedleTypeConst.needleTypeID);
  }

  static Future<List<Map<String, dynamic>>> getOneNeedleType(int id) async {
    final db = await SQLHelper.db();

    return db.query(KnittingNeedleTypeConst.tableName,
        where: "${KnittingNeedleTypeConst.needleTypeID} = ?",
        whereArgs: [id],
        limit: 1);
  }

  static Future<int> updateNeedleType(KnittingNeedleTypeModel type) async {
    final db = await SQLHelper.db();

    final data = {
      KnittingNeedleTypeConst.needleTypeName: type.needleTypeName
    };

    final result = await db.update(KnittingNeedleTypeConst.tableName, data,
        where: "${KnittingNeedleTypeConst.needleTypeID} = ?",
        whereArgs: [type.needleTypeID]);

    return result;
  }

  static Future<void> deleteNeedleType(int id) async {
    final db = await SQLHelper.db();

    try{
      await db.delete(KnittingNeedleTypeConst.tableName, where: "${KnittingNeedleTypeConst.needleTypeID} = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
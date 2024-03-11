import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;

import '../Models/Const/yarn_const.dart';
import '../Models/Models/yarn_model.dart';
import 'database.dart';

class YarnController {
  static Future<int> createYarn(YarnModel yarn) async {
    final db = await SQLHelper.db();

    final data = {
      YarnConst.yarnColor : yarn.yarnColor,
      YarnConst.image : yarn.image,
      YarnConst.brand : yarn.brand,
      YarnConst.material : yarn.material,
      YarnConst.size : yarn.size,
      YarnConst.availableWeight : yarn.availableWeight,
      YarnConst.pricePerGram : yarn.pricePerGram,
      YarnConst.reccHookNeedle : yarn.reccHookNeedle,
      YarnConst.cost : yarn.cost,
    };

    final id = await db.insert(YarnConst.tableName, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;  
  }

  static Future<List<Map<String, dynamic>>> getAllYarn() async {
    final db = await SQLHelper.db();

    return db.query(YarnConst.tableName, orderBy: YarnConst.yarnNumber);
  }

  static Future<List<Map<String, dynamic>>> getOneYarn(int id) async {
    final db = await SQLHelper.db();

    return db.query(YarnConst.tableName, where: "${YarnConst.yarnNumber} = ?",
    whereArgs: [id],
    limit: 1);
  }

  static Future<int> updateYarn(YarnModel yarn) async {
    final db = await SQLHelper.db();

    final data = {
      YarnConst.yarnColor : yarn.yarnColor,
      YarnConst.image : yarn.image,
      YarnConst.brand : yarn.brand,
      YarnConst.material : yarn.material,
      YarnConst.size : yarn.size,
      YarnConst.availableWeight : yarn.availableWeight,
      YarnConst.pricePerGram : yarn.pricePerGram,
      YarnConst.reccHookNeedle : yarn.reccHookNeedle,
      YarnConst.cost : yarn.cost,
    };

    final result = await db.update(YarnConst.tableName, data, where: "${YarnConst.yarnNumber} = ?",
    whereArgs: [yarn.yarnNumber]);

    return result;
  }

  static Future<void> deleteYarn(int id) async {
    final db = await SQLHelper.db();

    try{
      await db.delete(YarnConst.tableName, where: "${YarnConst.yarnNumber} = ?", whereArgs: [id]
      );
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
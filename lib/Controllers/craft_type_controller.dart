import 'package:flutter/rendering.dart';
import 'package:sqflite/sqflite.dart' as sql;

import '../Models/Const/craft_type_const.dart';
import '../Models/Models/craft_type_model.dart';
import 'database.dart';

class CraftTypeController {
  static Future<int> createCraftType(CraftTypeModel type) async {
    final db = await SQLHelper.db();

    final data = {
      CraftTypeConst.craftTypeName: type.craftTypeName,
    };

    final id = await db.insert(CraftTypeConst.tableName, data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllCraftTypes() async {
    final db = await SQLHelper.db();

    return db.query(CraftTypeConst.tableName,
        orderBy: CraftTypeConst.craftTypeNumber);
  }

  static Future<List<Map<String, dynamic>>> getOneCraftType(int id) async {
    final db = await SQLHelper.db();

    return db.query(CraftTypeConst.tableName,
        where: "${CraftTypeConst.craftTypeNumber} = ?",
        whereArgs: [id],
        limit: 1);
  }

  static Future<int> updateCraftType(CraftTypeModel type) async {
    final db = await SQLHelper.db();

    final data = {
      CraftTypeConst.craftTypeName: type.craftTypeName,
    };

    final result = await db.update(CraftTypeConst.tableName, data,
        where: "${CraftTypeConst.craftTypeNumber} = ?",
        whereArgs: [type.craftTypeNumber]);

    return result;
  }

  static Future<void> deleteCraftType(int id) async {
    final db = await SQLHelper.db();

    try{
      await db.delete(CraftTypeConst.tableName, where: "${CraftTypeConst.craftTypeNumber} = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}

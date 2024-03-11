import 'package:twisted_twine_workshopppe/Models/Const/crochet_hook_const.dart';
import 'package:twisted_twine_workshopppe/Models/Models/crochet_hook_model.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'database.dart';

class CrochetHookController {
  static Future<int> createCrochetHook(CrochetHookModel hook) async {
    final db = await SQLHelper.db();

    final data = {
      CrochetHookConst.image: hook.image,
      CrochetHookConst.crochetHookSize: hook.crochetHookSize,
    };

    final id = await db.insert(CrochetHookConst.tableName, data,
        conflictAlgorithm: sql.ConflictAlgorithm.rollback);

    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllCrochetHooks() async {
    final db = await SQLHelper.db();

    return db.query(CrochetHookConst.tableName,
        orderBy: CrochetHookConst.crochetHookId);
  }

  static Future<List<Map<String, dynamic>>> getOneCrochetHoook(int id) async {
    final db = await SQLHelper.db();
    return db.query(CrochetHookConst.tableName,
        where: "${CrochetHookConst.crochetHookId} = ?", whereArgs: [id]);
  }

  static Future<int> updateCrochetHook(CrochetHookModel hook) async {
    final db = await SQLHelper.db();

    final data = {
      CrochetHookConst.crochetHookId: hook.crochetHookId,
      CrochetHookConst.image: hook.image,
      CrochetHookConst.crochetHookSize: hook.crochetHookSize,
    };

    final result = await db.update(CrochetHookConst.tableName, data,
        where: "${CrochetHookConst.crochetHookId} = ?",
        whereArgs: [hook.crochetHookId]);

    return result;
  }

  static Future<void> deleteCrochetHook(int id) async {
    final db = await SQLHelper.db();

    try {
      await db.delete(CrochetHookConst.tableName,
          where: "${CrochetHookConst.crochetHookId} = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}

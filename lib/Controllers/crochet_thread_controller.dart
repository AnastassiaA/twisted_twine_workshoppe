import 'package:flutter/material.dart';

import 'package:sqflite/sqflite.dart' as sql;

import '../Models/Const/crochet_thread_const.dart';
import '../Models/Models/crochet_thread_model.dart';
import 'database.dart';

class CrochetThreadController {
  static Future<int> createCrochetThread(CrochetThreadModel thread) async {
    final db = await SQLHelper.db();

    final data = {
      CrochetThreadConst.crochetThreadColor: thread.crochetThreadColor,
      CrochetThreadConst.image: thread.image,
      CrochetThreadConst.brand: thread.brand,
      CrochetThreadConst.material: thread.material,
      CrochetThreadConst.size: thread.size,
      CrochetThreadConst.availableWeight: thread.availableWeight,
      CrochetThreadConst.pricePerGram: thread.pricePerGram,
      CrochetThreadConst.reccHookNeedle: thread.reccHookNeedle,
      CrochetThreadConst.cost: thread.cost,
    };

    final id = await db.insert(CrochetThreadConst.tableName, data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllCrochetThread() async {
    final db = await SQLHelper.db();

    return db.query(CrochetThreadConst.tableName,
        orderBy: CrochetThreadConst.crochetThreadid);
  }

  static Future<List<Map<String, dynamic>>> getOneCrochetThread(int id) async {
    final db = await SQLHelper.db();

    return db.query(CrochetThreadConst.tableName,
        where: "${CrochetThreadConst.crochetThreadid} =?",
        whereArgs: [id],
        limit: 1);
  }

  static Future<int> updateCrochetThread(CrochetThreadModel thread) async {
    final db = await SQLHelper.db();

    final data = {
      CrochetThreadConst.crochetThreadColor: thread.crochetThreadColor,
      CrochetThreadConst.image: thread.image,
      CrochetThreadConst.brand: thread.brand,
      CrochetThreadConst.material: thread.material,
      CrochetThreadConst.size: thread.size,
      CrochetThreadConst.availableWeight: thread.availableWeight,
      CrochetThreadConst.pricePerGram: thread.pricePerGram,
      CrochetThreadConst.reccHookNeedle: thread.reccHookNeedle,
      CrochetThreadConst.cost: thread.cost,
    };

    final result = await db.update(CrochetThreadConst.tableName, data,
        where: "${CrochetThreadConst.crochetThreadid} =?",
        whereArgs: [thread.crochetThreadid]);

    return result;
  }

  static Future<void> deleteCrochetThread(int id) async {
    final db = await SQLHelper.db();

    try {
      await db.delete(
        CrochetThreadConst.tableName,
        where: "${CrochetThreadConst.crochetThreadid} =?",
        whereArgs: [id],
      );
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}

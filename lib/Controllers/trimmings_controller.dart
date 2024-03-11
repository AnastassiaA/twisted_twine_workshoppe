import 'package:flutter/material.dart';

import 'package:sqflite/sqflite.dart' as sql;
import 'package:twisted_twine_workshopppe/Models/Const/trimmings_const.dart';
import 'package:twisted_twine_workshopppe/Models/Models/trimmings_model.dart';
import 'database.dart';

class TrimmingsController {
  static Future<int> createTrimmings(TrimmingsModel trimmings) async {
    final db = await SQLHelper.db();

    final data = {
      TrimmingsConst.trimmingsName: trimmings.trimmingsName,
      TrimmingsConst.image: trimmings.image,
      TrimmingsConst.amount: trimmings.amount,
    };

    final id = await db.insert(TrimmingsConst.tableName, data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllTrimmings() async {
    final db = await SQLHelper.db();

    return db.query(TrimmingsConst.tableName,
        orderBy: TrimmingsConst.trimmingsId);
  }

  static Future<List<Map<String, dynamic>>> getOneTrimming(int id) async {
    final db = await SQLHelper.db();

    return db.query(TrimmingsConst.tableName,
        where: "${TrimmingsConst.trimmingsId} =?",
        whereArgs: [id],
        limit: 1);
  }

  static Future<int> updateTrimmings(TrimmingsModel trimmings) async {
    final db = await SQLHelper.db();

    final data = {
      TrimmingsConst.trimmingsName: trimmings.trimmingsName,
      TrimmingsConst.image: trimmings.image,
      TrimmingsConst.amount: trimmings.amount,
    };

    final result = await db.update(TrimmingsConst.tableName, data,
        where: "${TrimmingsConst.trimmingsId} =?",
        whereArgs: [trimmings.trimmingsId]);

    return result;
  }

  static Future<void> deleteTrimmings(int id) async {
    final db = await SQLHelper.db();

    try {
      await db.delete(
        TrimmingsConst.tableName,
        where: "${TrimmingsConst.trimmingsId} =?",
        whereArgs: [id],
      );
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
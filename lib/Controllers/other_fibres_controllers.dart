import 'package:flutter/material.dart';

import 'package:sqflite/sqflite.dart' as sql;
import 'package:twisted_twine_workshopppe/Models/Const/other_fibres_const.dart';
import 'package:twisted_twine_workshopppe/Models/Models/other_fibres_model.dart';
import 'database.dart';

class OtherFibresController {
  static Future<int> createOtherFibres(OtherFibresModel fibres) async {
    final db = await SQLHelper.db();

    final data = {
      OtherFibresConst.fibreName: fibres.fibreName,
      OtherFibresConst.image: fibres.image,
      OtherFibresConst.amount: fibres.amount,
      OtherFibresConst.description: fibres.description,
    };

    final id = await db.insert(OtherFibresConst.tableName, data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllOtherFibres() async {
    final db = await SQLHelper.db();

    return db.query(OtherFibresConst.tableName,
        orderBy: OtherFibresConst.fibreId);
  }

  static Future<List<Map<String, dynamic>>> getOneOtherFibre(int id) async {
    final db = await SQLHelper.db();

    return db.query(OtherFibresConst.tableName,
        where: "${OtherFibresConst.fibreId} =?",
        whereArgs: [id],
        limit: 1);
  }

  static Future<int> updateOtherFibres(OtherFibresModel fibres) async {
    final db = await SQLHelper.db();

    final data = {
      OtherFibresConst.fibreName: fibres.fibreName,
      OtherFibresConst.image: fibres.image,
      OtherFibresConst.amount: fibres.amount,
      OtherFibresConst.description: fibres.description,
    };

    final result = await db.update(OtherFibresConst.tableName, data,
        where: "${OtherFibresConst.fibreId} =?",
        whereArgs: [fibres.fibreId]);

    return result;
  }

  static Future<void> deleteOtherFibres(int id) async {
    final db = await SQLHelper.db();

    try {
      await db.delete(
        OtherFibresConst.tableName,
        where: "${OtherFibresConst.fibreId} =?",
        whereArgs: [id],
      );
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}

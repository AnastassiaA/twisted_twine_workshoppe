import 'package:flutter/material.dart';

import 'package:sqflite/sqflite.dart' as sql;
import 'package:twisted_twine_workshopppe/Models/Const/fabrics_const.dart';
import 'package:twisted_twine_workshopppe/Models/Models/fabrics_model.dart';
import 'database.dart';

class FabricController {
  static Future<int> createFabrics(FabricsModel fabric) async {
    final db = await SQLHelper.db();

    final data = {
      FabricConst.fabricName: fabric.fabricName,
      FabricConst.image: fabric.image,
      FabricConst.description: fabric.description,
    };

    final id = await db.insert(FabricConst.tableName, data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllFabrics() async {
    final db = await SQLHelper.db();

    return db.query(FabricConst.tableName,
        orderBy: FabricConst.fabricId);
  }

  static Future<List<Map<String, dynamic>>> getOneFabric(int id) async {
    final db = await SQLHelper.db();

    return db.query(FabricConst.tableName,
        where: "${FabricConst.fabricId} =?",
        whereArgs: [id],
        limit: 1);
  }

  static Future<int> updateFabrics(FabricsModel fabric) async {
    final db = await SQLHelper.db();

    final data = {
      FabricConst.fabricName: fabric.fabricName,
      FabricConst.image: fabric.image,
      FabricConst.description: fabric.description,
    };

    final result = await db.update(FabricConst.tableName, data,
        where: "${FabricConst.fabricId} =?",
        whereArgs: [fabric.fabricId]);

    return result;
  }

  static Future<void> deleteFabric(int id) async {
    final db = await SQLHelper.db();

    try {
      await db.delete(
        FabricConst.tableName,
        where: "${FabricConst.fabricId} =?",
        whereArgs: [id],
      );
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
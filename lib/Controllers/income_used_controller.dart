import 'package:twisted_twine_workshopppe/Models/Const/income_used_const.dart';
import 'package:twisted_twine_workshopppe/Models/Models/income_used_model.dart';

import 'database.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;

class IncomeUsedController {
  static Future<int> createIncomeUsed(IncomeUsedModel income) async {
    final db = await SQLHelper.db();

    final data = {
      IncomeUsedConst.incomeId: income.incomeId,
      IncomeUsedConst.taskNumber: income.taskNumber,
      IncomeUsedConst.amount: income.amount,
          };

    final id = await db.insert(IncomeUsedConst.tableName, data,
        conflictAlgorithm: sql.ConflictAlgorithm.rollback);

    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllIncomeUsed(int id) async {
    final db = await SQLHelper.db();
    return db.query(IncomeUsedConst.tableName, where: "${IncomeUsedConst.taskNumber} = ?", whereArgs: [id],
    //id would be order number
        orderBy: IncomeUsedConst.incomeUsedId);
  }

  static Future<List<Map<String, dynamic>>> getOneIncomeUsed(int id) async {
    final db = await SQLHelper.db();
    return db.query(IncomeUsedConst.tableName,
        where: "${IncomeUsedConst.incomeUsedId} = ?", whereArgs: [id]);
  }

  static Future<int> updateIncomeUsed(IncomeUsedModel income) async {
    final db = await SQLHelper.db();

    final data = {
      IncomeUsedConst.incomeId: income.incomeId,
      IncomeUsedConst.taskNumber: income.taskNumber,
      IncomeUsedConst.amount: income.amount,
      };

    final result = await db.update(IncomeUsedConst.tableName, data,
    where: "${IncomeUsedConst.incomeUsedId} = ?", whereArgs: [income.incomeUsedId]);

    return result;
  }

  static Future<void> deleteIncomeUsed(int id) async {
    final db = await SQLHelper.db();

    try{
      await db.delete(IncomeUsedConst.tableName, where: "${IncomeUsedConst.incomeUsedId} = ?",whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:twisted_twine_workshopppe/Models/Models/income_model.dart';
import '../Models/Const/income_const.dart';
import 'database.dart';

class IncomeController {
  static Future<int> createIncome(IncomeModel income) async {
    final db = await SQLHelper.db();

    final data = {
      IncomeConst.incomeDescription: income.incomeDescription,
      IncomeConst.date: income.date.toIso8601String(),
      IncomeConst.incomeType: income.incomeType,
      IncomeConst.amount: income.amount,
      IncomeConst.taskName: income.taskName,
      IncomeConst.disbursedFrom: income.disbursedFrom,
      IncomeConst.receiptImage: income.receiptImage
    };

    final id = await db.insert(IncomeConst.tableName, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;  
  }

  static Future<List<Map<String, dynamic>>> getAllIncome() async {
    final db = await SQLHelper.db();

    return db.query(IncomeConst.tableName, orderBy: IncomeConst.incomeId);
  }

  static Future<List<Map<String, dynamic>>> getOneIncome(int id) async {
    final db = await SQLHelper.db();

    return db.query(IncomeConst.tableName, where: "${IncomeConst.incomeId} = ?",
    whereArgs: [id],
    limit: 1);
  }

  static Future<int> updateIncome(IncomeModel income) async {
    final db = await SQLHelper.db();

    final data = {
      IncomeConst.incomeDescription: income.incomeDescription,
      IncomeConst.date: income.date.toIso8601String(),
      IncomeConst.incomeType: income.incomeType,
      IncomeConst.amount: income.amount,
      IncomeConst.taskName: income.taskName,
      IncomeConst.disbursedFrom: income.disbursedFrom,
      IncomeConst.receiptImage: income.receiptImage
    };

    final result = await db.update(IncomeConst.tableName, data, where: "${IncomeConst.incomeId} = ?",
    whereArgs: [income.incomeId]);

    return result;
  }

  static Future<void> deleteIncome(int id) async {
    final db = await SQLHelper.db();

    try{
      await db.delete(IncomeConst.tableName, where: "${IncomeConst.incomeId} = ?", whereArgs: [id]
      );
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
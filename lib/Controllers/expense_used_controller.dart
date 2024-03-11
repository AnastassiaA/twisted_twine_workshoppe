import 'package:twisted_twine_workshopppe/Models/Const/expense_used_const.dart';
import 'package:twisted_twine_workshopppe/Models/Models/expense_used_model.dart';

import 'database.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;

class ExpenseUsedController {
  static Future<int> createExpenseUsed(ExpenseUsedModel expense) async {
    final db = await SQLHelper.db();

    final data = {
      ExpenseUsedConst.expenseId: expense.expenseId,
      ExpenseUsedConst.taskNumber: expense.taskNumber,
      ExpenseUsedConst.expenseCost: expense.expenseCost,
    };

    final id = await db.insert(ExpenseUsedConst.tableName, data,
        conflictAlgorithm: sql.ConflictAlgorithm.rollback);

    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllExpenseUsed(int id) async {
    final db = await SQLHelper.db();
    return db.query(ExpenseUsedConst.tableName, where: "${ExpenseUsedConst.taskNumber} = ?", whereArgs: [id],
    //id would be order number
        orderBy: ExpenseUsedConst.expenseUsedId);
  }

  static Future<List<Map<String, dynamic>>> getOneExpenseUsed(int id) async {
    final db = await SQLHelper.db();
    return db.query(ExpenseUsedConst.tableName,
        where: "${ExpenseUsedConst.expenseUsedId} = ?", whereArgs: [id]);
  }

  static Future<int> updateExpenseUsed(ExpenseUsedModel expense) async {
    final db = await SQLHelper.db();

    final data = {
      ExpenseUsedConst.expenseId: expense.expenseId,
      ExpenseUsedConst.taskNumber: expense.taskNumber,
      ExpenseUsedConst.expenseCost: expense.expenseCost,
    };

    final result = await db.update(ExpenseUsedConst.tableName, data,
    where: "${ExpenseUsedConst.expenseUsedId} = ?", whereArgs: [expense.expenseUsedId]);

    return result;
  }

  static Future<void> deleteExpenseUsed(int id) async {
    final db = await SQLHelper.db();

    try{
      await db.delete(ExpenseUsedConst.tableName, where: "${ExpenseUsedConst.expenseUsedId} = ?",whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
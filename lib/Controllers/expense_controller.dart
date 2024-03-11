import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:twisted_twine_workshopppe/Models/Const/expense_const.dart';
import 'package:twisted_twine_workshopppe/Models/Models/expense_model.dart';
import 'database.dart';

class ExpenseController {
  static Future<int> createExpense(ExpenseModel expense) async {
    final db = await SQLHelper.db();

    final data = {
      ExpenseConst.expenseDescription: expense.expenseDescription,
      ExpenseConst.date: expense.date.toIso8601String(),
      ExpenseConst.expenseType: expense.expenseType,
      ExpenseConst.amount: expense.amount,
      ExpenseConst.taskName: expense.taskName,
      ExpenseConst.paidTo: expense.paidTo,
      ExpenseConst.receiptImage: expense.receiptImage
    };

    final id = await db.insert(ExpenseConst.tableName, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;  
  }

  static Future<List<Map<String, dynamic>>> getAllExpenses() async {
    final db = await SQLHelper.db();

    return db.query(ExpenseConst.tableName, orderBy: ExpenseConst.id);
  }

  static Future<List<Map<String, dynamic>>> getOneExpense(int id) async {
    final db = await SQLHelper.db();

    return db.query(ExpenseConst.tableName, where: "${ExpenseConst.id} = ?",
    whereArgs: [id],
    limit: 1);
  }

  static Future<int> updateExpense(ExpenseModel expense) async {
    final db = await SQLHelper.db();

    final data = {
      ExpenseConst.expenseDescription: expense.expenseDescription,
      ExpenseConst.date: expense.date.toIso8601String(),
      ExpenseConst.expenseType: expense.expenseType,
      ExpenseConst.amount: expense.amount,
      ExpenseConst.taskName: expense.taskName,
      ExpenseConst.paidTo: expense.paidTo,
      ExpenseConst.receiptImage: expense.receiptImage
    };

    final result = await db.update(ExpenseConst.tableName, data, where: "${ExpenseConst.id} = ?",
    whereArgs: [expense.expenseId]);

    return result;
  }

  static Future<void> deleteExpense(int id) async {
    final db = await SQLHelper.db();

    try{
      await db.delete(ExpenseConst.tableName, where: "${ExpenseConst.id} = ?", whereArgs: [id]
      );
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
import 'package:twisted_twine_workshopppe/Models/Const/task_const.dart';
import '../Models/Const/expense_const.dart';
import '../Models/Const/income_const.dart';
import 'database.dart';

class HomePageController {

  //sans incoming
  static Future<List> allIncome() async {
    final db = await SQLHelper.db();

    final income = await db.rawQuery('SELECT SUM (${IncomeConst.amount}) as income FROM ${IncomeConst.tableName} WHERE ${IncomeConst.incomeType} NOT LIKE "%transfer in%"');
    return income.toList();
  } 

  //sans outgoing
  static Future<List> allExpense() async {
    final db = await SQLHelper.db();

    final expense = await db.rawQuery('SELECT SUM (${ExpenseConst.amount}) as expense FROM ${ExpenseConst.tableName} WHERE ${ExpenseConst.expenseType} NOT LIKE "%transfer out%"');
    return expense.toList();
  } 

  static Future<List> allPendingComms() async {
    final db = await SQLHelper.db();

    final pending = await db.rawQuery('SELECT COUNT (*) as pendingcount FROM ${TaskConst.tableName} WHERE ${TaskConst.taskType} LIKE "%commission%" AND ${TaskConst.status} LIKE "%pending%"');
    return pending.toList();
  }

  static Future<List> allCurrentComms() async {
    final db = await SQLHelper.db();

    final current = await db.rawQuery('SELECT COUNT (*) as currentcount FROM ${TaskConst.tableName} WHERE ${TaskConst.taskType} LIKE "%commission%" AND ${TaskConst.status} LIKE "%in progress%"');
    return current.toList();
  }

  static Future<List> allIncoming() async {
    final db = await SQLHelper.db();

    final incoming = await db.rawQuery('SELECT SUM (${IncomeConst.amount}) as incoming FROM ${IncomeConst.tableName} WHERE ${IncomeConst.incomeType} LIKE "%transfer in%"');
    return incoming.toList();  
  }

  static Future<List> allOutgoing() async {
    final db = await SQLHelper.db();
  
    final outgoing = await db.rawQuery('SELECT SUM(${ExpenseConst.amount}) as outgoing FROM ${ExpenseConst.tableName} WHERE ${ExpenseConst.expenseType} LIKE "%transfer out%"');
    return outgoing.toList();
  }

}
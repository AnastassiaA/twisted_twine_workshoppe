import 'package:twisted_twine_workshopppe/Models/Const/expense_used_const.dart';

class ExpenseUsedModel {
  final int? expenseUsedId;
  final int expenseId;
  final int taskNumber;
  final double? expenseCost;

  ExpenseUsedModel(
      {this.expenseUsedId,
      required this.taskNumber,
      required this.expenseId, this.expenseCost});

  Map<String, dynamic> toMap() {
    return {
      ExpenseUsedConst.expenseUsedId: expenseUsedId,
      ExpenseUsedConst.expenseId: expenseId,
      ExpenseUsedConst.taskNumber: taskNumber,
      ExpenseUsedConst.expenseCost: expenseCost
    };
  }

  factory ExpenseUsedModel.fromMap(Map<String, dynamic> json) =>
      ExpenseUsedModel(
        expenseUsedId: json[ExpenseUsedConst.expenseUsedId],
        expenseId: json[ExpenseUsedConst.expenseId],
        taskNumber: json[ExpenseUsedConst.taskNumber],
        expenseCost: json[ExpenseUsedConst.expenseCost],
      );
}

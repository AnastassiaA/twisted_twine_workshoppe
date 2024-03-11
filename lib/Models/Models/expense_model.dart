import 'package:twisted_twine_workshopppe/Models/Const/expense_const.dart';

class ExpenseModel {
  final int? expenseId;
  final String expenseDescription;
  final DateTime date;
  final String expenseType;
  final double amount;
  final String paidTo;
  final String? receiptImage;
  final String? taskName;

  ExpenseModel(
      {this.expenseId,
      required this.expenseDescription,
      required this.date,
      required this.expenseType,
      required this.amount,
      required this.paidTo,
      this.receiptImage,
      this.taskName,});

  Map<String, dynamic> toMap() {
    return {
      ExpenseConst.id: expenseId,
      ExpenseConst.expenseDescription: expenseDescription,
      ExpenseConst.date: date.toIso8601String(),
      ExpenseConst.expenseType: expenseType,
      ExpenseConst.amount: amount,
      ExpenseConst.paidTo: paidTo,
      ExpenseConst.receiptImage: receiptImage,
      ExpenseConst.taskName: taskName
    };
  }

  factory ExpenseModel.fromMap(Map<String, dynamic> json) => ExpenseModel(
        expenseId: json[ExpenseConst.id],
        expenseDescription: json[ExpenseConst.expenseDescription],
        date: DateTime.parse(json[ExpenseConst.date]) ,
        expenseType: json[ExpenseConst.expenseType],
        amount: json[ExpenseConst.amount],
        paidTo: json[ExpenseConst.paidTo],
        receiptImage: json[ExpenseConst.receiptImage],
        taskName: json[ExpenseConst.taskName]      
      );
}

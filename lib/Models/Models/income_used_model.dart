import 'package:twisted_twine_workshopppe/Models/Const/income_used_const.dart';

class IncomeUsedModel {
  final int? incomeUsedId;
  final int incomeId;
  final int taskNumber;
  final double amount;

  IncomeUsedModel(
      {this.incomeUsedId,
      required this.incomeId,
      required this.taskNumber,
      required this.amount});

  Map<String, dynamic> toMap() {
    return {
      IncomeUsedConst.incomeUsedId: incomeUsedId,
      IncomeUsedConst.incomeId: incomeId,
      IncomeUsedConst.taskNumber: taskNumber,
      IncomeUsedConst.amount: amount,
    };
  }

  factory IncomeUsedModel.fromMap(Map<String, dynamic> json) => IncomeUsedModel(
        incomeUsedId: json[IncomeUsedConst.incomeUsedId],
        incomeId: json[IncomeUsedConst.incomeId],
        taskNumber: json[IncomeUsedConst.taskNumber],
        amount: json[IncomeUsedConst.amount],
      );
}

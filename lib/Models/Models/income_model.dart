import 'package:twisted_twine_workshopppe/Models/Const/income_const.dart';

class IncomeModel {
  final int? incomeId;
  final String incomeDescription;
  final DateTime date;
  final String incomeType;
  final double amount;
  final String taskName;
  final String disbursedFrom;
  final String? receiptImage;

  IncomeModel(
      {this.incomeId,
      required this.incomeDescription,
      required this.date,
      required this.incomeType,
      required this.amount,
      required this.taskName,
      required this.disbursedFrom,
      this.receiptImage});

  Map<String, dynamic> toMap() {
    return {
      IncomeConst.incomeId: incomeId,
      IncomeConst.incomeDescription: incomeDescription,
      IncomeConst.date: date.toIso8601String(),
      IncomeConst.incomeType: incomeType,
      IncomeConst.amount: amount,
      IncomeConst.taskName: taskName,
      IncomeConst.disbursedFrom: disbursedFrom,
      IncomeConst.receiptImage: receiptImage
    };
  }

  factory IncomeModel.fromMap(Map<String, dynamic> json) => IncomeModel(
      incomeId: json[IncomeConst.incomeId],
      incomeDescription: json[IncomeConst.incomeDescription],
      date: DateTime.parse(json[IncomeConst.date]),
      incomeType: json[IncomeConst.incomeType],
      amount: json[IncomeConst.amount],
      taskName: json[IncomeConst.taskName],
      disbursedFrom: json[IncomeConst.disbursedFrom],
      receiptImage: json[IncomeConst.receiptImage]);
}

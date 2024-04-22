import 'package:twisted_twine_workshopppe/Models/Const/history_const.dart';

class HistoryModel {
  final int? historyId;
  final String name;
  final bool completionStatus; //boolean
  final String craftType;
  final DateTime? monthYear;
  final String description;

  HistoryModel(
      {this.historyId,
      required this.name,
      required this.completionStatus,
      required this.craftType,
      this.monthYear,
      required this.description});

  Map<String, dynamic> toMap() {
    return {
      HistoryConst.historyId: historyId,
      HistoryConst.name: name,
      HistoryConst.completionStatus: completionStatus == true ? 1 : 0,
      HistoryConst.craftType: craftType,
      HistoryConst.monthYear: monthYear!.toIso8601String(),
      HistoryConst.description: description
    };
  }

  factory HistoryModel.fromMap(Map<String, dynamic> json) => HistoryModel(
        historyId: json[HistoryConst.historyId],
        name: json[HistoryConst.name],
        completionStatus: json[HistoryConst.completionStatus] == 1 ? true: false,
        craftType: json[HistoryConst.craftType],
        monthYear: DateTime.parse(json[HistoryConst.monthYear]),
        description: json[HistoryConst.description],
      );
}

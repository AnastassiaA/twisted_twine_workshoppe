import 'package:twisted_twine_workshopppe/Models/Const/rows_const.dart';

class RowModel {
  int? rowId;
  int rowCount;
  int taskNumber;

  RowModel({
    this.rowId,
    required this.rowCount,
    required this.taskNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      RowsConst.rowId: rowId,
      RowsConst.rowCount: rowCount,
      RowsConst.taskNumber: taskNumber,
    };
  }

  factory RowModel.fromMap(Map<String, dynamic> json) => 
  RowModel(
    rowId: json[RowsConst.rowId],
    rowCount: json[RowsConst.rowCount], 
    taskNumber: json[RowsConst.taskNumber]);
}

import 'package:twisted_twine_workshopppe/Models/Const/fabrics_used_const.dart';

class FabricsUsedModel {
  final int? fabricsUsedId;
  final int fabricsId;
  final int taskNumber;

  FabricsUsedModel({
    this.fabricsUsedId,
    required this.fabricsId,
    required this.taskNumber
  });

  Map<String, dynamic> toMap() {
    return {
      FabricsUsedConst.fabricsUsedId: fabricsUsedId,
      FabricsUsedConst.fabricsId: fabricsId,
      FabricsUsedConst.taskNumber: taskNumber
    };
  }

  factory FabricsUsedModel.fromMap(Map<String, dynamic> json) =>
    FabricsUsedModel(
      fabricsUsedId: json[FabricsUsedConst.fabricsUsedId],
      fabricsId: json[FabricsUsedConst.fabricsId], 
      taskNumber: json[FabricsUsedConst.taskNumber]);

}
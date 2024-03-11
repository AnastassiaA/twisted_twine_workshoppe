import '../Const/knitting_needle_used_const.dart';

class KnittingNeedleUsedModel {
  final int? knittingNeedleUsedId;
  final int taskNumber;
  final int knittingNeedleId;

  KnittingNeedleUsedModel({
    this.knittingNeedleUsedId,
    required this.taskNumber,
    required this.knittingNeedleId,
  });

  Map<String, dynamic> toMap() {
    return {
      KnittingNeedleUsedConst.knittingNeedleUsedId: knittingNeedleUsedId,
      KnittingNeedleUsedConst.taskNumber: taskNumber,
      KnittingNeedleUsedConst.knittingNeedleId: knittingNeedleId,
    };
  }

  factory KnittingNeedleUsedModel.fromMap(Map<String, dynamic> json) => KnittingNeedleUsedModel(
    knittingNeedleUsedId: json[KnittingNeedleUsedConst.knittingNeedleUsedId],
    taskNumber: json[KnittingNeedleUsedConst.taskNumber], 
    knittingNeedleId: json[KnittingNeedleUsedConst.knittingNeedleId]);
}
import 'package:twisted_twine_workshopppe/Models/Const/crochet_hook_used_const.dart';

class CrochetHookUsedModel {
  final int? crochetHookUsedId;
  final int taskNumber;
  final int crochetHookId;

  CrochetHookUsedModel({
    this.crochetHookUsedId,
    required this.taskNumber,
    required this.crochetHookId,
  });

  Map<String, dynamic> toMap() {
    return{
      CrochetHookUsedConst.crochetHookUsedId: crochetHookUsedId,
      CrochetHookUsedConst.taskNumber: taskNumber,
      CrochetHookUsedConst.crochetHookId: crochetHookId,
    };
  }

  factory CrochetHookUsedModel.fromMap(Map<String, dynamic> json) =>
  CrochetHookUsedModel(
    crochetHookUsedId: json[CrochetHookUsedConst.crochetHookUsedId],
    taskNumber: json[CrochetHookUsedConst.taskNumber], 
    crochetHookId: json[CrochetHookUsedConst.crochetHookId]);
}
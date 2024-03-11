import '../Const/crochet_thread_used_const.dart';

class CrochetThreadUsedModel {
  final int? crochetThreadUsedid;
  final int taskNumber;
  final int crochetThreadnumber;
  final double? amountUsed; 

  CrochetThreadUsedModel({
    this.crochetThreadUsedid,
    required this.taskNumber,
    required this.crochetThreadnumber,
    this.amountUsed
  });

  Map<String, dynamic> toMap() {
    return {
      CrochetThreadUsedConst.crochetThreadUsedid: crochetThreadUsedid,
      CrochetThreadUsedConst.taskNumber: taskNumber,
      CrochetThreadUsedConst.crochetThreadnumber: crochetThreadnumber,
      CrochetThreadUsedConst.amountUsed: amountUsed
    };
  }

  factory CrochetThreadUsedModel.fromMap(Map<String, dynamic> json) => CrochetThreadUsedModel(
    taskNumber: json[CrochetThreadUsedConst.taskNumber], 
    crochetThreadnumber: json[CrochetThreadUsedConst.crochetThreadnumber],
    crochetThreadUsedid: json[CrochetThreadUsedConst.crochetThreadUsedid],
    amountUsed: json[CrochetThreadUsedConst.amountUsed]
    );
}
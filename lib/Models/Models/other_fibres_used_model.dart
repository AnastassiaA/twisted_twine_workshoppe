import 'package:twisted_twine_workshopppe/Models/Const/other_fibres_used_const.dart';

class OtherFibresUsedModel {
  final int? otherFibresUsedId;
  final int taskNumber;
  final double? amount;
  final int otherFibresId;

  OtherFibresUsedModel(
      {this.otherFibresUsedId,
      required this.taskNumber,
      this.amount,
      required this.otherFibresId});

  Map<String, dynamic> toMap() {
    return {
      OtherFibresUsedConst.otherFibresUsedId: otherFibresUsedId,
      OtherFibresUsedConst.taskNumber: taskNumber,
      OtherFibresUsedConst.amount: amount,
      OtherFibresUsedConst.otherFibresId: otherFibresId
    };
  }

  factory OtherFibresUsedModel.fromMap(Map<String, dynamic> json) =>
      OtherFibresUsedModel(
          otherFibresUsedId: json[OtherFibresUsedConst.otherFibresUsedId],
          taskNumber: json[OtherFibresUsedConst.taskNumber],
          amount: json[OtherFibresUsedConst.amount],
          otherFibresId: json[OtherFibresUsedConst.otherFibresId]);
}

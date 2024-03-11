import 'package:twisted_twine_workshopppe/Models/Const/trimmings_used_const.dart';

class TrimmingsUsedModel {
  final int? trimmingsUsedId;
  final int trimmingId;
  final int taskNumber;
  final int? amountUsed;

  TrimmingsUsedModel(
      {this.trimmingsUsedId,
      required this.trimmingId,
      required this.taskNumber,
      this.amountUsed});

  Map<String, dynamic> toMap() {
    return {
      TrimmingsUsedConst.trimmingsUsedId: trimmingsUsedId,
      TrimmingsUsedConst.trimmingId: trimmingId,
      TrimmingsUsedConst.taskNumber: taskNumber,
      TrimmingsUsedConst.amountUsed: amountUsed,
    };
  }

  factory TrimmingsUsedModel.fromMap(Map<String, dynamic> json) =>
      TrimmingsUsedModel(
          trimmingsUsedId: json[TrimmingsUsedConst.trimmingsUsedId],
          trimmingId: json[TrimmingsUsedConst.trimmingId],
          taskNumber: json[TrimmingsUsedConst.taskNumber],
          amountUsed: json[TrimmingsUsedConst.amountUsed]);
}

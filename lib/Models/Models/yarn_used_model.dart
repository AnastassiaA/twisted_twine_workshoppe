

import '../Const/yarn_used_const.dart';

class YarnUsedOrderModel {
  final int? yarnUsedNumber;
  final int? thisOrderNumber;
  final int thisYarnNumber;
  final double? amountUsed;

  YarnUsedOrderModel({
    this.yarnUsedNumber,
    this.thisOrderNumber,
    required this.thisYarnNumber,
    this.amountUsed,
  });

  Map<String, dynamic> toMap() {
    return {
      YarnUsedConst.yarnUsedNumber: yarnUsedNumber,
      YarnUsedConst.taskNumber: thisOrderNumber,
      YarnUsedConst.yarnNumber: thisYarnNumber,
      YarnUsedConst.amountUsed: amountUsed,
    };
  }

  factory YarnUsedOrderModel.fromMap(Map<String, dynamic> json) =>
      YarnUsedOrderModel(
        yarnUsedNumber: json[YarnUsedConst.yarnUsedNumber],
        thisOrderNumber: json[YarnUsedConst.taskNumber],
        thisYarnNumber: json[YarnUsedConst.yarnNumber],
        amountUsed: json[YarnUsedConst.amountUsed],
      );
}



import '../Const/knitting_needle_type_const.dart';

class KnittingNeedleTypeModel {
  final int? needleTypeID;
  final String needleTypeName;

  KnittingNeedleTypeModel(
    {
      this.needleTypeID,
      required this.needleTypeName
    }
  );

  Map<String, dynamic> toMap() {
    return {
      KnittingNeedleTypeConst.needleTypeID: needleTypeID,
      KnittingNeedleTypeConst.needleTypeName: needleTypeName
    };
  }

  factory KnittingNeedleTypeModel.fromMap(Map<String, dynamic> json) => KnittingNeedleTypeModel(
    needleTypeID: json[KnittingNeedleTypeConst.needleTypeID],
    needleTypeName: json[KnittingNeedleTypeConst.needleTypeName]);
}
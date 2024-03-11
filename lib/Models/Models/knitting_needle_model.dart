

import '../Const/knitting_needle_const.dart';

class KnittingNeedleModel {
  final int? knittingNeedleId;
  final String knittingNeedleSize;
  final String image;
  final String knittingNeedleType;

  KnittingNeedleModel(
      {this.knittingNeedleId,
      required this.knittingNeedleSize,
      required this.image,
      required this.knittingNeedleType});

  Map<String, dynamic> toMap() {
    return {
      KnittingNeedleConst.knittingNeedleId: knittingNeedleId,
      KnittingNeedleConst.knittingNeedleSize: knittingNeedleSize,
      KnittingNeedleConst.image: image,
      KnittingNeedleConst.knittingNeedleType: knittingNeedleType
    };
  }

  factory KnittingNeedleModel.fromMap(Map<String, dynamic> json) =>
      KnittingNeedleModel(
        knittingNeedleId: json[KnittingNeedleConst.knittingNeedleId],
        knittingNeedleSize: json[KnittingNeedleConst.knittingNeedleSize],
        image: json[KnittingNeedleConst.image],
        knittingNeedleType: json[KnittingNeedleConst.knittingNeedleType],
      );
}

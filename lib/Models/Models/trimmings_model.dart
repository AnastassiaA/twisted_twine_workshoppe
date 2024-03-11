import 'package:twisted_twine_workshopppe/Models/Const/trimmings_const.dart';

class TrimmingsModel {
  final int? trimmingsId;
  final String image;
  final String trimmingsName;
  final int amount;

  TrimmingsModel({
    this.trimmingsId,
    required this.image,
    required this.trimmingsName,
    required this.amount
  });

  Map<String, dynamic> toMap() {
    return {
      TrimmingsConst.trimmingsId: trimmingsId,
      TrimmingsConst.image: image,
      TrimmingsConst.trimmingsName: trimmingsName,
      TrimmingsConst.amount: amount,
    };
  }

  factory TrimmingsModel.fromMap(Map<String, dynamic> json) =>
    TrimmingsModel(
      trimmingsId: json[TrimmingsConst.trimmingsId],
      image: json[TrimmingsConst.image], 
      trimmingsName: json[TrimmingsConst.trimmingsName], 
      amount: json[TrimmingsConst.amount]);
}
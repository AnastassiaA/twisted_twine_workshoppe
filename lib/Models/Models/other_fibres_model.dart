import 'package:twisted_twine_workshopppe/Models/Const/other_fibres_const.dart';

class OtherFibresModel {
  final int? fibreId;
  final String fibreName;
  final String image;
  final double amount;
  final String description;

  OtherFibresModel(
      {this.fibreId,
      required this.fibreName,
      required this.image,
      required this.amount,
      required this.description});

  Map<String, dynamic> toMap() {
    return {
      OtherFibresConst.fibreId: fibreId,
      OtherFibresConst.fibreName: fibreName,
      OtherFibresConst.image: image,
      OtherFibresConst.amount: amount,
      OtherFibresConst.description: description,
    };
  }

  factory OtherFibresModel.fromMap(Map<String, dynamic> json) =>
      OtherFibresModel(
          fibreId: json[OtherFibresConst.fibreId],
          fibreName: json[OtherFibresConst.fibreName],
          image: json[OtherFibresConst.image],
          amount: json[OtherFibresConst.amount],
          description: json[OtherFibresConst.description]);
}

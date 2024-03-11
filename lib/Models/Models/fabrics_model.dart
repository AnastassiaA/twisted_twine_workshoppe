import 'package:twisted_twine_workshopppe/Models/Const/fabrics_const.dart';

class FabricsModel {
  final int? fabricId;
  final String fabricName;
  final String image;
  final String description;

  FabricsModel(
      {this.fabricId,
      required this.fabricName,
      required this.image,
      required this.description});

  Map<String, dynamic> toMap() {
    return {
      FabricConst.fabricId: fabricId,
      FabricConst.fabricName: fabricName,
      FabricConst.image: image,
      FabricConst.description: description,
    };
  }

  factory FabricsModel.fromMap(Map<String, dynamic> json) => FabricsModel(
      fabricId: json[FabricConst.fabricId],
      fabricName: json[FabricConst.fabricName],
      image: json[FabricConst.image],
      description: json[FabricConst.description]);
}

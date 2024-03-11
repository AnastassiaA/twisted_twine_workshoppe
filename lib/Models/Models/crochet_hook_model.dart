import 'package:twisted_twine_workshopppe/Models/Const/crochet_hook_const.dart';

class CrochetHookModel {
  final int? crochetHookId;
  final String image;
  final String crochetHookSize;

  CrochetHookModel({
    this.crochetHookId,
    required this.image,
    required this.crochetHookSize,
  });

  Map<String, dynamic> toMap() {
    return {
      CrochetHookConst.crochetHookId: crochetHookId,
      CrochetHookConst.image: image,
      CrochetHookConst.crochetHookSize: crochetHookSize,
    };
  }

  factory CrochetHookModel.fromMap(Map<String, dynamic> json) =>
    CrochetHookModel(
      crochetHookId: json[CrochetHookConst.crochetHookId],
      image: json[CrochetHookConst.image],
      crochetHookSize: json[CrochetHookConst.crochetHookSize]
      );
}
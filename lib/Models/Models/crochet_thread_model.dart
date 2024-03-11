

import '../Const/crochet_thread_const.dart';

class CrochetThreadModel {
  final int? crochetThreadid;
  final String crochetThreadColor;
  final String image;
  final String brand;
  final String material;
  final String size;
  final double availableWeight;
  final double pricePerGram;
  final String reccHookNeedle;
  final double cost;

  CrochetThreadModel(
      {this.crochetThreadid,
      required this.crochetThreadColor,
      required this.image,
      required this.brand,
      required this.material,
      required this.size,
      required this.availableWeight,
      required this.pricePerGram,
      required this.reccHookNeedle,
      required this.cost});

  Map<String, dynamic> toMap() {
    return {
      CrochetThreadConst.crochetThreadid: crochetThreadid,
      CrochetThreadConst.crochetThreadColor: crochetThreadColor,
      CrochetThreadConst.image: image,
      CrochetThreadConst.brand: brand,
      CrochetThreadConst.material: material,
      CrochetThreadConst.size: size,
      CrochetThreadConst.availableWeight: availableWeight,
      CrochetThreadConst.pricePerGram: pricePerGram,
      CrochetThreadConst.reccHookNeedle: reccHookNeedle,
      CrochetThreadConst.cost: cost,
    };
  }

  factory CrochetThreadModel.fromMap(Map<String, dynamic> json) => CrochetThreadModel(
    crochetThreadid: json[CrochetThreadConst.crochetThreadid],
    crochetThreadColor: json[CrochetThreadConst.crochetThreadColor], 
    image: json[CrochetThreadConst.image], 
    brand: json[CrochetThreadConst.brand], 
    material: json[CrochetThreadConst.material], 
    size: json[CrochetThreadConst.size], 
    availableWeight: json[CrochetThreadConst.availableWeight], 
    pricePerGram: json[CrochetThreadConst.pricePerGram], 
    reccHookNeedle: json[CrochetThreadConst.reccHookNeedle], 
    cost: json[CrochetThreadConst.cost]);
}

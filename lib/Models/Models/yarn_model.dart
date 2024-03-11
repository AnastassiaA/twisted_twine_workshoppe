

import '../Const/yarn_const.dart';

class YarnModel {
  final int? yarnNumber;
  final String yarnColor;
  final String image;
  final String brand;
  final String material;
  final String size;
  final double availableWeight;
  final double pricePerGram;
  final String reccHookNeedle;
  final double cost;

  YarnModel(
      {this.yarnNumber,
      required this.yarnColor,
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
      YarnConst.yarnNumber:yarnNumber,
      YarnConst.yarnColor: yarnColor,
      YarnConst.image: image,
      YarnConst.brand: brand,
      YarnConst.material: material,
      YarnConst.size: size,
      YarnConst.availableWeight: availableWeight,
      YarnConst.pricePerGram: pricePerGram,
      YarnConst.reccHookNeedle: reccHookNeedle,
      YarnConst.cost: cost,
    };
  }

  factory YarnModel.fromMap(Map<String, dynamic> json) => YarnModel(
        yarnNumber: json[YarnConst.yarnNumber],
        yarnColor: json[YarnConst.yarnColor],
        image: json[YarnConst.image],
        brand: json[YarnConst.brand],
        material: json[YarnConst.material],
        size: json[YarnConst.size],
        availableWeight: json[YarnConst.availableWeight],
        pricePerGram: json[YarnConst.pricePerGram],
        reccHookNeedle: json[YarnConst.reccHookNeedle],
        cost: json[YarnConst.cost],
      );
}


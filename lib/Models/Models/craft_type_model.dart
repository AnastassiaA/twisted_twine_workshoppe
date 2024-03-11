
import '../Const/craft_type_const.dart';

class CraftTypeModel {
  final int? craftTypeNumber;
  final String craftTypeName;

  CraftTypeModel({this.craftTypeNumber, required this.craftTypeName});

  Map<String, dynamic> toMap() {
    return {
    CraftTypeConst.craftTypeNumber: craftTypeNumber, 
    CraftTypeConst.craftTypeName: craftTypeName};
  }

  factory CraftTypeModel.fromMap(Map<String, dynamic> json) => CraftTypeModel(
        craftTypeNumber: json[CraftTypeConst.craftTypeNumber],
        craftTypeName: json[CraftTypeConst.craftTypeName],
      );
}

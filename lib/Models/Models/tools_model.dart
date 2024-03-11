   import 'package:twisted_twine_workshopppe/Models/Const/tools_const.dart';

class ToolsModel {
  final int? toolsId;
  final String toolName;
  final String? image;

  ToolsModel({
    this.toolsId,
    required this.toolName,
    this.image
  });

  Map<String, dynamic> toMap() {
    return {
      ToolsConst.toolsId: toolsId,
      ToolsConst.toolName: toolName,
      ToolsConst.image: image,
    };
  }

  factory ToolsModel.fromMap(Map<String, dynamic> json) => 
    ToolsModel(
      toolsId: json[ToolsConst.toolsId],
      toolName: json[ToolsConst.toolName],
      image: json[ToolsConst.image]);
  }
   
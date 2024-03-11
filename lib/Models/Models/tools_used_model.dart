import 'package:twisted_twine_workshopppe/Models/Const/tools_used_const.dart';

class ToolsUsedModel {
  final int? toolUsedId;
  final int toolId;
  final int taskNumber;

  ToolsUsedModel(
      {this.toolUsedId, required this.toolId, required this.taskNumber});

  Map<String, dynamic> toMap() {
    return {
      ToolsUsedConst.toolUsedId: toolUsedId,
      ToolsUsedConst.toolId: toolId,
      ToolsUsedConst.taskNumber: taskNumber
    };
  }

  factory ToolsUsedModel.fromMap(Map<String, dynamic> json) => ToolsUsedModel(
        toolUsedId: json[ToolsUsedConst.toolUsedId],
        toolId: json[ToolsUsedConst.toolId],
        taskNumber: json[ToolsUsedConst.taskNumber],
      );
}

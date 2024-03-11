import 'package:twisted_twine_workshopppe/Models/Const/idea_const.dart';

class IdeaModel {
  final int? recordId;
  final String image;
  final String ideaName;
  final String description;

  IdeaModel({
    this.recordId,
    required this.image,
    required this.ideaName,
    required this.description
  });

  Map<String, dynamic> toMap() {
    return{
      IdeaConst.recordId: recordId,
      IdeaConst.image: image,
      IdeaConst.ideaName: ideaName,
      IdeaConst.description: description,
    };
  }

  factory IdeaModel.fromMap(Map<String, dynamic> json) => IdeaModel(
    recordId: json[IdeaConst.recordId],
    image: json[IdeaConst.image], 
    ideaName: json[IdeaConst.ideaName], 
    description: json[IdeaConst.description]);
}
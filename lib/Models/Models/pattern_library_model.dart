
import 'package:twisted_twine_workshopppe/Models/Const/pattern_library_const.dart';

class PatternLibraryModel {
  final int? patternId;
  final String patternName;
  final String patternType;
  final String patternLink;

  PatternLibraryModel({
    this.patternId,
    required this.patternName,
    required this.patternType,
    required this.patternLink,
  });

  Map<String, dynamic> toMap() {
    return {
      PatternLibraryConst.patternId: patternId,
      PatternLibraryConst.patternName: patternName,
      PatternLibraryConst.patternType: patternType,
      PatternLibraryConst.patternLink: patternLink,
    };
  }

  factory PatternLibraryModel.fromMap(Map<String, dynamic> json) =>
      PatternLibraryModel(
          patternName: json[PatternLibraryConst.patternName],
          patternType: json[PatternLibraryConst.patternType],
          patternId: json[PatternLibraryConst.patternId],
          patternLink: json[PatternLibraryConst.patternLink]);
}

import 'package:sqflite/sqflite.dart' as sql;
import 'package:twisted_twine_workshopppe/Models/Models/pattern_library_model.dart';
import '../Models/Const/pattern_library_const.dart';
import 'database.dart';
import 'package:flutter/material.dart';

class PatternLibraryController {
  static Future<int> createPattern(PatternLibraryModel pattern) async {
        final db = await SQLHelper.db();

    final data = {
      PatternLibraryConst.patternName: pattern.patternName,
      PatternLibraryConst.patternType: pattern.patternType,
      PatternLibraryConst.patternLink: pattern.patternLink,
    };

    final id = await db.insert(PatternLibraryConst.tableName, data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllPatterns() async {
        final db = await SQLHelper.db();

        return db.query(PatternLibraryConst.tableName,
        orderBy: PatternLibraryConst.patternId);

  }

  //static Future<int> updatePattern() async {}

  static Future<void> deletePattern(int id) async {
        final db = await SQLHelper.db();
   try {
      await db.delete(PatternLibraryConst.tableName,
          where: "${PatternLibraryConst.patternId} = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    } 
  }
}
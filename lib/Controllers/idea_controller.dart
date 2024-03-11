import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:twisted_twine_workshopppe/Models/Models/idea_model.dart';
import '../Models/Const/idea_const.dart';
import 'database.dart';

class IdeaController {
  static Future<int> createIdea(IdeaModel idea) async {
    final db = await SQLHelper.db();

    final data = {
      IdeaConst.recordId: idea.recordId,
      IdeaConst.image: idea.image,
      IdeaConst.ideaName: idea.ideaName,
      IdeaConst.description: idea.description,
    };

    final id = await db.insert(IdeaConst.tableName, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllIdeas() async {
    final db = await SQLHelper.db();
    return db.query(IdeaConst.tableName, orderBy: IdeaConst.recordId);
  }

  static Future<int> updateIdea(IdeaModel idea) async {
    final db = await SQLHelper.db();

    final data = {
      IdeaConst.recordId: idea.recordId,
      IdeaConst.image: idea.image,
      IdeaConst.ideaName: idea.ideaName,
      IdeaConst.description: idea.description,
    };

    final result = await db.update(IdeaConst.tableName, data,
        where: "${IdeaConst.recordId} = ?", whereArgs: [idea.recordId]);
    return result;
  }

  static Future<void> deleteIdea(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete(IdeaConst.tableName,
          where: "${IdeaConst.recordId} = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
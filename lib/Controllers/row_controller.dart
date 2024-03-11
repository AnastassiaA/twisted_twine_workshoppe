import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:twisted_twine_workshopppe/Models/Const/rows_const.dart';
import 'package:twisted_twine_workshopppe/Models/Models/row_model.dart';
import 'database.dart';

class RowController {
  static Future<int> createRowRecord(RowModel row) async {
    final db = await SQLHelper.db();

    final data = {
      RowsConst.rowId: row.rowId,
      RowsConst.rowCount: row.rowCount,
      RowsConst.taskNumber: row.taskNumber,
    };

    final id = await db.insert(RowsConst.tableName, data,
        conflictAlgorithm: sql.ConflictAlgorithm.rollback);

    return id;
  }

  static Future<List<Map<String, dynamic>>> getAllRowRecords() async {
    final db = await SQLHelper.db();
    return db.query(RowsConst.tableName,
        
        //id would be task number
        orderBy: RowsConst.rowId);
  }

  static Future<List<Map<String, dynamic>>> getOneRowRecord(int id) async {
    final db = await SQLHelper.db();
    return db.query(RowsConst.tableName,
        where: "${RowsConst.rowId} = ?", whereArgs: [id]);
  }

  static Future<int> updateRowRecord(RowModel row) async {
    final db = await SQLHelper.db();

    final data = {
      RowsConst.rowCount: row.rowCount,
      RowsConst.taskNumber: row.taskNumber,
    };

    final result = await db.update(RowsConst.tableName, data,
        where: "${RowsConst.rowId} = ?", whereArgs: [row.rowId]);

    return result;
  }

  static Future<void> deleteRowRecord(int id) async {
    final db = await SQLHelper.db();

    try {
      await db.delete(RowsConst.tableName,
          where: "${RowsConst.rowId} = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}

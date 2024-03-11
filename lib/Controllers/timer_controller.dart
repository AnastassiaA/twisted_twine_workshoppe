import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:twisted_twine_workshopppe/Models/Const/timer_const.dart';
import 'package:twisted_twine_workshopppe/Models/Models/timer_model.dart';
import 'database.dart';

class TimerController {
  static Future<int> createTime(TimerModel time) async {
    final db = await SQLHelper.db();

    final data = {
      TimerConst.taskNumber: time.taskNumber,
      TimerConst.commissionName: time.commissionName,
      TimerConst.startDateTime: time.startDateTime.toIso8601String(),
      TimerConst.endDateTime: time.endDateTime.toIso8601String(),
      TimerConst.amountTime: time.amountTime.inSeconds.toInt(),
      TimerConst.description: time.description,
    };

    final id = await db.insert(TimerConst.tableName, data,
        conflictAlgorithm: sql.ConflictAlgorithm.rollback);

    return id;
  }

  static Future<List<Map<String, dynamic>>> getLastestTimers() async {
    final db = await SQLHelper.db();

    return db.query(TimerConst.tableName,
        limit: 5, orderBy: TimerConst.endDateTime);
  }

  static Future<List<Map<String, dynamic>>> getAllTimers() async {
    final db = await SQLHelper.db();

    return db.query(TimerConst.tableName, orderBy: TimerConst.timeSlotId);
  }

  static Future<int> updateTime(TimerModel time) async {
    final db = await SQLHelper.db();

    final data = {
      TimerConst.taskNumber: time.taskNumber,
      TimerConst.commissionName: time.commissionName,
      TimerConst.startDateTime: time.startDateTime.toIso8601String(),
      TimerConst.endDateTime: time.endDateTime.toIso8601String(),
      TimerConst.amountTime: time.amountTime.inSeconds.toInt(),
      TimerConst.description: time.description,
    };

    final result = await db.update(TimerConst.tableName, data,
        where: "${TimerConst.timeSlotId} = ?", whereArgs: [time.timeSlotId]);

    return result;
  }

  static Future<void> deleteTime(int id) async {
    final db = await SQLHelper.db();

    try {
      await db.delete(TimerConst.tableName,
          where: "${TimerConst.timeSlotId} = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  static Future<List> sumAllTimes(int id) async {
    final db = await SQLHelper.db();

    final total = await db.rawQuery(
        'SELECT SUM(${TimerConst.amountTime}) as total FROM ${TimerConst.tableName} WHERE ${TimerConst.taskNumber} LIKE $id');
    return total.toList();
  }
}

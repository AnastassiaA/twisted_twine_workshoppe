import 'package:flutter/rendering.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'database.dart';


class BackupAndRestoreController {
  //backup to local storage
  //could return a date time when backup is complete

  //backup to google drive

  //restore from local storage

  //restore from google drive

  //wipe the app
  static Future<void> deleteDatabase() async {
    final path = await SQLHelper.getDBPath();

    print(path);
    
    try {
      await sql.databaseFactory.deleteDatabase(path);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }

    //do i need to delete the file path too?
    //await File(path).delete();
  }
}

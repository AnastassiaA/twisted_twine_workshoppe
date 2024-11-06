import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:twisted_twine_workshopppe/Controllers/backup_and_restore_controller.dart';
import 'package:twisted_twine_workshopppe/Controllers/database.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

import '../../Models/Const/database_name_const.dart';

class BackupAndRestorePage extends StatefulWidget {
  const BackupAndRestorePage({super.key});

  @override
  State<BackupAndRestorePage> createState() => _BackupAndRestorePageState();
}

class _BackupAndRestorePageState extends State<BackupAndRestorePage> {

  final Directory dir = Directory('/storage/emulated/0/Download');

    exportDatabaseToDownloads() async {
    var externalStatus = await Permission.manageExternalStorage.status;

    if (!externalStatus.isGranted) {
      await Permission.manageExternalStorage.request();
    } else {
      String dbPath = join(await sql.getDatabasesPath(), '${DatabaseName.databaseName}.db');

      //var somethingelse = await Directory(dbPath).exists();

      //somethingelse ? 
      print(dbPath);
      // : print('DATABASE DOESNT EXIST');

      final Directory?downloadsDir = await getDownloadsDirectory();

      var something = await Directory(downloadsDir!.path).exists();

      if (something) {
        File databaseFile = File(dbPath);

        final File copyDatabaseFile = await databaseFile.copy(downloadsDir.path);
        
        //await copyDatabaseFile.exists() == true ? print
        
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Backup and Restore"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: exportDatabaseToDownloads,
                child: const Text("Backup to Local Storage")),
            ElevatedButton(
                onPressed: () {}, child: const Text("Backup to Google Drive")),
            ElevatedButton(
                onPressed: () {},
                child: const Text("Restore from Local Storage")),
            ElevatedButton(
                onPressed: () {},
                child: const Text("Restore from Google Drive")),
            ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: const Text("Are you sure?"),
                          actions: [
                            ElevatedButton(
                              onPressed: () async {
                                Navigator.pop(
                                  context,
                                );
                              },
                              child: const Text("No"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // BackupAndRestoreController.deleteDatabase();
                                // Navigator.pop(
                                //   context,
                                // );
                              },
                              child: const Text("Yes"),
                            ),
                          ],
                        );
                      });
                },
                child: const Text("Wipe the App"))
          ],
        ),
      ),
    );
  }
}


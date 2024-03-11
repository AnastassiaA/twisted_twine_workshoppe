import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:twisted_twine_workshopppe/Controllers/database.dart';

class BackupAndRestorePage extends StatelessWidget {
  const BackupAndRestorePage({super.key});

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
                onPressed: () {}, child: const Text("Backup to Local Storage")),
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
                                 //await SQLHelper.deleteDatabase();
                                // Navigator.pop(
                                //   context,
                                // );
                              },
                              child: const Text("No"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(
                                  context,
                                );
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

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:saf/saf.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:open_filex/open_filex.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

import '../Animations/expandable_fab_class.dart';
import '../../Models/Models/pattern_library_model.dart';
import 'package:twisted_twine_workshopppe/Controllers/pattern_library_controller.dart';

//brainstorming how avoid adding duplicates to the pattern library
//get list from database
//contains()
//how does the sort() function hold up with long lists?

class PatternLibraryPage extends StatefulWidget {
  const PatternLibraryPage({super.key});

  @override
  State<PatternLibraryPage> createState() => _PatternLibraryPageState();
}

class _PatternLibraryPageState extends State<PatternLibraryPage> {
  late Saf saf;
  List<String> _paths = [];
  List<PatternLibraryModel> patternList = [];
  bool isLoading = true;
  bool isPatternLibraryEmpty = false;
  bool isSuccessful = false;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  getAllPatternsFromDatabase() async {
    final patternData = await PatternLibraryController.getAllPatterns();
    setState(() {
      if (patternData.isEmpty) {
        isPatternLibraryEmpty == true;
      } else {
        patternList =
            patternData.map((e) => PatternLibraryModel.fromMap(e)).toList();
        isLoading = false;
      }
    });
  }

  Future<bool> getAllPatternsFromStorage() async {
    String folderPath = 'Andoid/';

    saf = Saf(folderPath);

    //different permmissions are required for different android sdk version
    // AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    // final info = androidInfo.version.sdkInt;
    // print("its sdk version $info");

    bool? isGranted = await saf.getDirectoryPermission(
        grantWritePermission: false, isDynamic: true);

    if (isGranted != null && isGranted == true) {
      List<String>? paths = await saf.getFilesPath();

      setState(() {
        _paths = paths!;

        if (_paths.isNotEmpty) {
          isSuccessful = true;
          print("path list isnt empty");
        }
      });

      print('permission GRANTED');
    } else {
      print("permission DENIED");
    }

    return isSuccessful;
  }

  @override
  void initState() {
    super.initState();
    getAllPatternsFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    Widget scanAnimation = const Column(
      children: [Text('Please wait'), CircularProgressIndicator()],
    );

    Widget buildScreen = ListView.builder(
        itemCount: _paths.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(_paths[index]),
            ),
          );
        });

    return Scaffold(
      appBar: AppBar(
        actions: [
          isPatternLibraryEmpty
              ? Container()
              : TextButton(
                  onPressed: getAllPatternsFromStorage,
                  child: const Text("Scan"))
        ],
      ),
      body: isPatternLibraryEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Scan for Patterns"),
                  ElevatedButton(
                    onPressed: () {
                      getAllPatternsFromStorage();

                      if (isSuccessful) {
                        setState  (() {
                          buildScreen;
                        });
                      }
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            )
          // FutureBuilder(
          //     future: getAllPatternsFromStorage(),
          //     builder: (BuildContext context, AsyncSnapshot snapshot) {
          //       if (snapshot.connectionState == ConnectionState.waiting) {
          //         return const Center(
          //           child: Column(
          //             children: [
          //               Text('Loading Patterns'),
          //               CircularProgressIndicator(),
          //             ],
          //           ),
          //         );
          //       } else if (snapshot.hasError) {
          //         return const Text('there\'s an error');
          //       } else {
          //         return ListView.builder(
          //             itemCount: snapshot.data.length,
          //             itemBuilder: (context, index) {});
          //       }
          //     },
          //   )
          : ListView.builder(
              itemCount: patternList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(patternList[index].patternLink),
                  ),
                );
              }),

      // print(folderPath);

      // final elements = await Directory(folderPath!)
      //     .list(recursive: true, followLinks: false)
      //     //.map((event) => event as File)
      //     //.asyncMap((event) => event.toString())
      //     .toList();

      // print(elements);

      // for(var thing in elements) {
      //   final split = thing.path.split('0/');
      //   print(split[1]);
      //   //print(thing.path.endsWith('.pdf'));
      //   //thing.path.endsWith('.pdf');
      // }

      //---------------------------------------------------------------

      // List<String> getPatternsFromStorage(path) async {
      //   final elements = await Directory(path!)
      //     .list(recursive: true,)
      //     //.map((event) => event as File)
      //     .asyncMap((event) => event.toString())
      //     .toList();

      // }

      // //get the path for the first folder [Patterns]
      // //do the recursion to get a list of items in the folder,
      // //if the path ends with a file name, add to list for screen

      // getPatternsFromStorage(folderPath);

      //----------------------------------------------------------------------
      // if (internalStoragePermissionGranted == true) {

      //   if (path != null) {
      //     //entities =
      //     //await dir.list(recursive: true).toList();
      //     //Directory(path)
      //     //.listSync(recursive: true, followLinks: false);
      //     //  print('there are ${entities.length} items');
      //     // print(entities);

      //     // for (var entity in entities) {
      //     //   if (entity.path.endsWith('.pdf')) {
      //     //     files.add(entity);
      //     //   }
      //     // }
      //     final bytes = await Directory(path)
      //         .list(recursive: true)
      //         .where((event) => event.path.endsWith('.pdf'))
      //         .map((event) => event as File)
      //         .asyncMap((event) => event.readAsBytes())
      //         .toList();

      //     for (var element in bytes) {
      //       files.add(element);
      //     }

      //     print('there are ${files.length} pdf files');
      //   }
      // }

      //next: somehow grabbing everything in this path...
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import '../../Controllers/yarn_controller.dart';
import '../../Models/Models/yarn_model.dart';
import '../Forms/add_yarn.dart';

class YarnPage extends StatefulWidget {
  const YarnPage({super.key});

  @override
  State<YarnPage> createState() => _YarnPageState();
}

class _YarnPageState extends State<YarnPage> {
  List<YarnModel> yarnList = [];
  bool isLoading = true;

  getAllYarn() async {
    final yarnData = await YarnController.getAllYarn();

    setState(() {
      yarnList = yarnData.map((e) => YarnModel.fromMap(e)).toList();
      isLoading = false;
    });
  }

  @override
  void initState() {
    getAllYarn();
    super.initState();
  }

  Future refresh() async {
    yarnList.clear();
    getAllYarn();
  }

  void deleteYarn(
      {required YarnModel yarn, required BuildContext context}) async {
    YarnController.deleteYarn(yarn.yarnNumber!).then((value) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Deleted')));
    }).catchError((e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    });
    getAllYarn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yarn"),
        actions: const [
          Tooltip(
            message: 'Long press a commission to delete',
            child: Icon(
              Icons.help,

            ),
            
          ),
          IconButton(onPressed: null, icon: Icon(Icons.sort)),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: yarnList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: GestureDetector(
                    onDoubleTap: () {
                      //edit
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            Image.memory(base64Decode(yarnList[index].image))
                                .image,
                      ),
                      title: Text(yarnList[index].yarnColor),
                      subtitle: Text('${yarnList[index].material} '
                          '${yarnList[index].size}'),
                      trailing: Text('${yarnList[index].availableWeight} g'),
                      onLongPress: () {
                        //dialog box - delete
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => ))
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddYarn()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

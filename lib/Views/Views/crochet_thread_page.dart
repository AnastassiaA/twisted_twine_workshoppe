import 'dart:convert';

import 'package:flutter/material.dart';

import '../../Controllers/crochet_thread_controller.dart';
import '../../Models/Models/crochet_thread_model.dart';
import '../Forms/add_crochet_thread.dart';

class CrochetThreadPage extends StatefulWidget {
  const CrochetThreadPage({super.key});

  @override
  State<CrochetThreadPage> createState() => _CrochetThreadPageState();
}

class _CrochetThreadPageState extends State<CrochetThreadPage> {
  List<CrochetThreadModel> threadList = [];
  bool isLoading = true;

  getAllThread() async {
    final threadData = await CrochetThreadController.getAllCrochetThread();

    setState(() {
      threadList =
          threadData.map((e) => CrochetThreadModel.fromMap(e)).toList();
      isLoading = false;
    });
  }

  @override
  void initState() {
    getAllThread();
    super.initState();
  }

  Future refresh() async {
    threadList.clear();
    getAllThread();
  }

  void deleteThread(
      {required CrochetThreadModel thread,
      required BuildContext context}) async {
    CrochetThreadController.deleteCrochetThread(thread.crochetThreadid!)
        .then((value) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Deleted')));
    }).catchError((e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    });
    getAllThread();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crochet Thread"),
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
              itemCount: threadList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: GestureDetector(
                    onDoubleTap: () {
                      //edit
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: Image.memory(
                          base64Decode(threadList[index].image),
                        ).image,
                      ),
                      title: Text(threadList[index].crochetThreadColor),
                      subtitle: Text('${threadList[index].material}'
                          '${threadList[index].size}'),
                      trailing: Text('${threadList[index].availableWeight} g'),
                      onTap: () {
                        //dialog box - delete
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => ))
                      },
                    ),
                  ),
                );
              }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCrochetThread()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:twisted_twine_workshopppe/Controllers/crochet_hook_controller.dart';
import 'package:twisted_twine_workshopppe/Controllers/crochet_hook_used_controllers.dart';
import 'package:twisted_twine_workshopppe/Models/Models/crochet_hook_model.dart';

import '../../../Models/Models/crochet_hook_used_model.dart';

class CrochetHookUsedPage extends StatefulWidget {
  final int taskNumber;
  const CrochetHookUsedPage(this.taskNumber, {super.key});

  @override
  State<CrochetHookUsedPage> createState() => _CrochetHookUsedPageState();
}

class _CrochetHookUsedPageState extends State<CrochetHookUsedPage> {
  List<CrochetHookUsedModel> hookUsedList = [];
  List<CrochetHookModel> hookList = [];
  bool isLoading = true;
  List<CrochetHookModel> showHookList = [];

  getAllHooks() async {
    final showHookData = await CrochetHookController.getAllCrochetHooks();

    setState(() {
      showHookList =
          showHookData.map((e) => CrochetHookModel.fromMap(e)).toList();
    });
  }

  getAllHooksUsed() async {
    final hookUsedData =
        await CrochetHookUsedController.getAllHookUsed(widget.taskNumber);

    hookUsedList =
        hookUsedData.map((e) => CrochetHookUsedModel.fromMap(e)).toList();

    for (int index = 0; index < hookUsedList.length; index++) {
      final hookData = await CrochetHookController.getOneCrochetHoook(
          hookUsedList[index].crochetHookId);

      hookList.add(
          hookData.map((e) => CrochetHookModel.fromMap(e)).toList().single);
    }

    setState(() {
      hookList;
      hookUsedList;
      isLoading = false;
    });
  }

  @override
  void initState() {
    getAllHooks();
    getAllHooksUsed();
    super.initState();
  }

  Future refresh() async {
    hookList.clear();
    hookUsedList.clear();
    getAllHooksUsed();
  }

  showHookListModal() async {
    showModalBottomSheet(
      context: context,
      builder: (_) => ListView.builder(
        itemCount: showHookList.length,
        itemBuilder: ((context, index) {
          return Card(
            child: ListTile(
              dense: true,
              leading: CircleAvatar(
                backgroundImage:
                    Image.memory(base64Decode(showHookList[index].image)).image,
              ),
              title: Text(showHookList[index].crochetHookSize),
              onTap: () {
                setState(() {
                  hookList.add(showHookList[index]);
                  hookUsedList.add(CrochetHookUsedModel(
                    taskNumber: widget.taskNumber,
                    crochetHookId: showHookList[index].crochetHookId!,
                  ));
                });

                if (!mounted) return;
                Navigator.pop(context);
              },
            ),
          );
        }),
      ),
    );
  }

  Future<void> _updateHooksUsed() async {
    for (int index = 0; index < hookUsedList.length; index++) {
      if (hookUsedList[index].crochetHookUsedId != null) {
        CrochetHookUsedModel hookUsed = CrochetHookUsedModel(
            crochetHookUsedId: hookUsedList[index].crochetHookUsedId,
            taskNumber: widget.taskNumber,
            crochetHookId: hookUsedList[index].crochetHookId);

        await CrochetHookUsedController.updateHookUsed(hookUsed);
      } else {
        CrochetHookUsedModel hookUsed = CrochetHookUsedModel(
            taskNumber: widget.taskNumber,
            crochetHookId: hookUsedList[index].crochetHookId);

        await CrochetHookUsedController.createHookUsed(hookUsed);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crochet Hook'),
        actions: [
          const Tooltip(
            message: 'Long press a commission to delete',
            child: Icon(
              Icons.help,

            ),
            
          ),
          IconButton(
              onPressed: () async {
                await _updateHooksUsed();
                //refresh();
              },
              icon: const Icon(Icons.save)),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: hookList.length,
                itemBuilder: ((context, index) {
                  final hook = hookList[index].crochetHookSize;
                  return Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (direction) {
                      setState(() {
                        if (hookUsedList[index].crochetHookUsedId != null) {
                          CrochetHookUsedController.deleteHookUsed(
                              hookUsedList[index].crochetHookUsedId!);
                        }

                        hookList.removeAt(index);
                        hookUsedList.removeAt(index);
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("$hook hook dismissed")));
                    },
                    background: Container(
                      color: Colors.pinkAccent,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                          title: Text(hookList[index].crochetHookSize)),
                    ),
                  );
                }),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showHookListModal();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

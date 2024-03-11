import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../Controllers/crochet_thread_controller.dart';
import '../../../Controllers/crochet_thread_used_controller.dart';
import '../../../Models/Models/crochet_thread_model.dart';
import '../../../Models/Models/crochet_thread_used_model.dart';

class CrochetThreadUsedPage extends StatefulWidget {
  final int taskNumber;
  const CrochetThreadUsedPage(this.taskNumber, {super.key});

  @override
  State<CrochetThreadUsedPage> createState() => _CrochetThreadUsedPageState();
}

class _CrochetThreadUsedPageState extends State<CrochetThreadUsedPage> {
  List<CrochetThreadUsedModel> threadUsedList = [];
  List<String> threadList = [];
  bool isLoading = true;
  List<CrochetThreadModel> showThreadList = [];
  List<double> weightUsedCount = [];

  getAllThread() async {
    final showThreadData = await CrochetThreadController.getAllCrochetThread();

    setState(() {
      showThreadList =
          showThreadData.map((e) => CrochetThreadModel.fromMap(e)).toList();
    });
  }

  getAllThreadUsed() async {
    final threadUsedData =
        await CrochetThreadUsedController.getAllThreadUsed(widget.taskNumber);

    threadUsedList =
        threadUsedData.map((e) => CrochetThreadUsedModel.fromMap(e)).toList();

    for (int index = 0; index < threadUsedList.length; index++) {
      final threaddata = await CrochetThreadController.getOneCrochetThread(
          threadUsedList[index].crochetThreadnumber);

      threadList.add(threaddata
          .map((e) => CrochetThreadModel.fromMap(e).crochetThreadColor)
          .toList()
          .single);

      weightUsedCount.add(threadUsedList[index].amountUsed!);
    }

    setState(() {
      threadList;
      threadUsedList;
      weightUsedCount;
      isLoading = false;
    });
  }

  @override
  void initState() {
    getAllThread();
    getAllThreadUsed();
    super.initState();
  }

  Future refresh() async {
    threadList.clear();
    threadUsedList.clear();
    weightUsedCount.clear();
    getAllThreadUsed();
  }

  showThreadListModal() async {
    showModalBottomSheet(
      context: context,
      builder: (_) => ListView.builder(
        itemCount: showThreadList.length,
        itemBuilder: (((context, index) {
          return Card(
            child: ListTile(
              dense: true,
              leading: CircleAvatar(
                backgroundImage:
                    Image.memory(base64Decode(showThreadList[index].image))
                        .image,
              ),
              title: Text(showThreadList[index].crochetThreadColor),
              subtitle: Text('${showThreadList[index].material}'
                  '${showThreadList[index].size}'),
              trailing: Text('${showThreadList[index].availableWeight} g'),
              onTap: () {
                setState(() {
                  threadList.add(showThreadList[index].crochetThreadColor);
                  threadUsedList.add(
                    CrochetThreadUsedModel(
                        taskNumber: widget.taskNumber,
                        crochetThreadnumber:
                            showThreadList[index].crochetThreadid!),
                  );

                  weightUsedCount.add(0.0);
                });

                if (!mounted) return;
                Navigator.pop(context);
              },
            ),
          );
        })),
      ),
    );
  }

  Future<void> _updateThreadUsed() async {
    for (int index = 0; index < threadUsedList.length; index++) {
      if (threadUsedList[index].crochetThreadUsedid != null) {
        CrochetThreadUsedModel threadUsed = CrochetThreadUsedModel(
            crochetThreadUsedid: threadUsedList[index].crochetThreadUsedid,
            taskNumber: widget.taskNumber,
            crochetThreadnumber: threadUsedList[index].crochetThreadnumber,
            amountUsed: weightUsedCount[index]);

        await CrochetThreadUsedController.updateThreadUsed(threadUsed);
      } else {
        CrochetThreadUsedModel threadUsed = CrochetThreadUsedModel(
            taskNumber: widget.taskNumber,
            crochetThreadnumber: threadUsedList[index].crochetThreadnumber,
            amountUsed: weightUsedCount[index]);

        await CrochetThreadUsedController.createThreadUsed(threadUsed);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crochet Thread'),
        actions: [
          IconButton(
              onPressed: () async {
                await _updateThreadUsed();
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
                  itemCount: threadList.length,
                  itemBuilder: (context, index) {
                    final thread = threadList[index];
                    return Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.startToEnd,
                        onDismissed: (direction) {
                          setState(() {
                            if (threadUsedList[index].crochetThreadUsedid !=
                                null) {
                              CrochetThreadUsedController.deleteThreadUsed(
                                  threadUsedList[index].crochetThreadUsedid!);
                            }

                            threadList.removeAt(index);
                            threadUsedList.removeAt(index);
                            weightUsedCount.removeAt(index);
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("$thread dismissed")));
                        },
                        background: Container(color: Colors.pinkAccent),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              ListTile(
                                title: Text(threadList[index]),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  child: Row(children: [
                                    IconButton(
                                        onPressed: () {
                                          weightUsedCount[index] -= 0.1;
                                          setState(
                                            () => weightUsedCount[index],
                                          );
                                        },
                                        icon: const Icon(Icons.remove)),
                                    Text(
                                        '${double.parse(weightUsedCount[index].toStringAsFixed(1))} g'),
                                    IconButton(
                                        onPressed: () {
                                          weightUsedCount[index] += 0.1;
                                          setState(
                                            () => weightUsedCount[index],
                                          );
                                        },
                                        icon: const Icon(Icons.add)),
                                  ]),
                                ),
                              ),
                            ],
                          ),
                        ));
                  }),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showThreadListModal();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

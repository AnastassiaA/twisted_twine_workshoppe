import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:twisted_twine_workshopppe/Controllers/trimmings_controller.dart';
import 'package:twisted_twine_workshopppe/Controllers/trimmings_used_controller.dart';
import 'package:twisted_twine_workshopppe/Models/Models/trimmings_model.dart';
import 'package:twisted_twine_workshopppe/Models/Models/trimmings_used_model.dart';

class TrimmingsUsedPage extends StatefulWidget {
  final int taskNumber;
  const TrimmingsUsedPage(this.taskNumber, {super.key});

  @override
  State<TrimmingsUsedPage> createState() => _TrimmingsUsedPageState();
}

class _TrimmingsUsedPageState extends State<TrimmingsUsedPage> {
  List<TrimmingsUsedModel> trimmingsUsedList = [];
  List<String> trimmingsList = [];
  bool isLoading = true;
  List<TrimmingsModel> showTrimmingsList = [];
  List<int> amountUsedCount = [];

  getAllTrimmings() async {
    final showTrimmingsData = await TrimmingsController.getAllTrimmings();

    setState(() {
      showTrimmingsList =
          showTrimmingsData.map((e) => TrimmingsModel.fromMap(e)).toList();
    });
  }

  getAllTrimmingsUsed() async {
    final trimmingsUsedData =
        await TrimmingsUsedController.getAllTrimmingsUsed(widget.taskNumber);

    trimmingsUsedList =
        trimmingsUsedData.map((e) => TrimmingsUsedModel.fromMap(e)).toList();

    for (int index = 0; index < trimmingsUsedList.length; index++) {
      final trimmingsData = await TrimmingsController.getOneTrimming(
          trimmingsUsedList[index].trimmingId);

      trimmingsList.add(trimmingsData
          .map((e) => TrimmingsModel.fromMap(e).trimmingsName)
          .toList()
          .single);

      amountUsedCount.add(trimmingsUsedList[index].amountUsed!);
    }

    setState(() {
      trimmingsList;
      trimmingsUsedList;
      amountUsedCount;
      isLoading = false;
    });
  }

  @override
  void initState() {
    getAllTrimmings();
    getAllTrimmingsUsed();
    super.initState();
  }

  Future refresh() async {
    trimmingsList.clear();
    trimmingsUsedList.clear();
    amountUsedCount.clear();
    getAllTrimmingsUsed();
  }

  showTrimmingsListModal() async {
    showModalBottomSheet(
      context: context,
      builder: (_) => ListView.builder(
          itemCount: showTrimmingsList.length,
          itemBuilder: ((context, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Card(
                child: ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    backgroundImage: Image.memory(
                            base64Decode(showTrimmingsList[index].image))
                        .image,
                  ),
                  title: Text(showTrimmingsList[index].trimmingsName),
                  trailing: Text('${showTrimmingsList[index].amount}'),
                  onTap: () {
                    setState(() {
                      trimmingsList.add(showTrimmingsList[index].trimmingsName);

                      trimmingsUsedList.add(TrimmingsUsedModel(
                        trimmingId: showTrimmingsList[index].trimmingsId!,
                        taskNumber: widget.taskNumber,
                      ));

                      amountUsedCount.add(0);
                    });

                    if (!mounted) return;
                    Navigator.pop(
                      context,
                    );
                  },
                ),
              ),
            );
          })),
    );
  }

  Future<void> _updateTrimmingsUsed() async {
    for (int index = 0; index < trimmingsUsedList.length; index++) {
      if (trimmingsUsedList[index].trimmingsUsedId != null) {
        //if the yarn used was already saved
        //edit the record

        TrimmingsUsedModel trimmings = TrimmingsUsedModel(
            trimmingsUsedId: trimmingsUsedList[index].trimmingsUsedId,
            taskNumber: widget.taskNumber,
            trimmingId: trimmingsUsedList[index].trimmingId,
            amountUsed: amountUsedCount[index]);
        await TrimmingsUsedController.updateTrimmingsUsed(trimmings);
      } else {
        //add this new record

        TrimmingsUsedModel trimmings = TrimmingsUsedModel(
            taskNumber: widget.taskNumber,
            trimmingId: trimmingsUsedList[index].trimmingId,
            amountUsed: amountUsedCount[index]);
        await TrimmingsUsedController.createTrimmingsUsed(trimmings);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trimmings Used'),
        actions: [
          const Tooltip(
            message: 'Long press a commission to delete',
            child: Icon(
              Icons.help,
              color: Colors.grey,
            ),
            
          ),
          IconButton(
              onPressed: () async {
                await _updateTrimmingsUsed();
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
                  itemCount: trimmingsList.length,
                  itemBuilder: (context, index) {
                    final trimming = trimmingsList[index];
                    return Dismissible(
                      //key: Key(yarn),
                      key: UniqueKey(),
                      direction: DismissDirection.startToEnd,
                      onDismissed: (direction) {
                        setState(() {
                          if (trimmingsUsedList[index].trimmingsUsedId !=
                              null) {
                            TrimmingsUsedController.deleteTrimmingsUsed(
                                trimmingsUsedList[index].trimmingsUsedId!);
                          }

                          trimmingsList.removeAt(index);
                          trimmingsUsedList.removeAt(index);
                          amountUsedCount.removeAt(index);
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("$trimming dismissed")));
                      },
                      background: Container(color: Colors.pinkAccent),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ListTile(
                              title: Text(trimmingsList[index]),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          amountUsedCount[index] -= 1;
                                          setState(
                                            () => amountUsedCount[index],
                                          );
                                        },
                                        icon: const Icon(Icons.remove)),
                                    Text('${amountUsedCount[index]}'),
                                    IconButton(
                                        onPressed: () {
                                          amountUsedCount[index] += 1;
                                          setState(
                                            () => amountUsedCount[index],
                                          );
                                        },
                                        icon: const Icon(Icons.add)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showTrimmingsListModal();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

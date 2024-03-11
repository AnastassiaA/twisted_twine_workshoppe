 import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:twisted_twine_workshopppe/Controllers/other_fibres_controllers.dart';
import 'package:twisted_twine_workshopppe/Controllers/other_fibres_used_controller.dart';
import 'package:twisted_twine_workshopppe/Models/Models/other_fibres_model.dart';
import 'package:twisted_twine_workshopppe/Models/Models/other_fibres_used_model.dart';

class OtherFibresUsedPage extends StatefulWidget {
  final int taskNumber;
  const OtherFibresUsedPage(this.taskNumber, {super.key});

  @override
  State<OtherFibresUsedPage> createState() => _OtherFibresUsedPageState();
}

class _OtherFibresUsedPageState extends State<OtherFibresUsedPage> {
  List<OtherFibresUsedModel> fibreUsedList = [];
  List<String> fibreList = [];
  bool isLoading = true;
  List<OtherFibresModel> showFibreList = [];
  List<double> amountUsedCount = [];

  getAllFibres() async {
    final showFibreData = await OtherFibresController.getAllOtherFibres();

    setState(() {
      showFibreList =
          showFibreData.map((e) => OtherFibresModel.fromMap(e)).toList();
    });
  }

  getAllFibresUsed() async {
    final fibreUsedData =
        await OtherFibresUsedController.getAllFibresUsed(widget.taskNumber);

    fibreUsedList =
        fibreUsedData.map((e) => OtherFibresUsedModel.fromMap(e)).toList();

    for (int index = 0; index < fibreUsedList.length; index++) {
      final fibreData = await OtherFibresController.getOneOtherFibre(
          fibreUsedList[index].otherFibresId);

      fibreList.add(fibreData
          .map((e) => OtherFibresModel.fromMap(e).fibreName)
          .toList()
          .single);

      amountUsedCount.add(fibreUsedList[index].amount!);
    }

    setState(() {
      fibreList;
      fibreUsedList;
      amountUsedCount;
      isLoading = false;
    });
  }

  @override
  void initState() {
    getAllFibres();
    getAllFibresUsed();
    super.initState();
  }

  // Future refresh() async {
  //   fibreList.clear();
  //   fibreUsedList.clear();
  //   amountUsedCount.clear();
  //   getAllFibresUsed();
  // }

  showFibreListModal() async {
    showModalBottomSheet(
        context: context,
        builder: (_) => ListView.builder(
              itemCount: showFibreList.length,
              itemBuilder: ((context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Card(
                    child: ListTile(
                      dense: true,
                      leading: CircleAvatar(
                        backgroundImage: Image.memory(
                                base64Decode(showFibreList[index].image))
                            .image,
                      ),
                      title: Text(showFibreList[index].fibreName),
                      subtitle: Text(showFibreList[index].description),
                      trailing: Text("${showFibreList[index].amount}"),
                      onTap: () {
                        setState(() {
                          fibreList.add(showFibreList[index].fibreName);
                          fibreUsedList.add(OtherFibresUsedModel(
                            taskNumber: widget.taskNumber,
                            otherFibresId: showFibreList[index].fibreId!,
                          ));
                          amountUsedCount.add(0.0);
                        });

                        if (!mounted) return;
                        Navigator.pop(
                          context,
                        );
                      },
                    ),
                  ),
                );
              }),
            ));
  }

  Future<void> _updateFibreUsed() async {
    for (int index = 0; index < fibreUsedList.length; index++) {
      if (fibreUsedList[index].otherFibresUsedId != null) {
        OtherFibresUsedModel fibreUsed = OtherFibresUsedModel(
            otherFibresUsedId: fibreUsedList[index].otherFibresUsedId,
            taskNumber: widget.taskNumber,
            otherFibresId: fibreUsedList[index].otherFibresId,
            amount: amountUsedCount[index]);

        await OtherFibresUsedController.updateFibreUsed(fibreUsed);
      } else {
        OtherFibresUsedModel fibreUsed = OtherFibresUsedModel(
            taskNumber: widget.taskNumber,
            otherFibresId: fibreUsedList[index].otherFibresId,
            amount: amountUsedCount[index]);

        await OtherFibresUsedController.createFibresUsed(fibreUsed);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Other Fibres Used'),
        actions: [
          IconButton(
              onPressed: () async {
                await _updateFibreUsed();
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
                  itemCount: fibreList.length,
                  itemBuilder: (context, index) {
                    final yarn = fibreList[index];
                    return Dismissible(
                      //key: Key(yarn),
                      key: UniqueKey(),
                      direction: DismissDirection.startToEnd,
                      onDismissed: (direction) {
                        setState(() {
                          if (fibreUsedList[index].otherFibresUsedId != null) {
                            OtherFibresUsedController.deleteFibreUsed(
                                fibreUsedList[index].otherFibresUsedId!);
                          }

                          fibreList.removeAt(index);
                          fibreUsedList.removeAt(index);
                          amountUsedCount.removeAt(index);
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("$yarn dismissed")));
                      },
                      background: Container(color: Colors.pinkAccent),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ListTile(
                              title: Text(fibreList[index]),
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
                                          amountUsedCount[index] -= 0.1;
                                          setState(
                                            () => amountUsedCount[index],
                                          );
                                        },
                                        icon: const Icon(Icons.remove)),
                                    Text(
                                        '${double.parse(amountUsedCount[index].toStringAsFixed(1))} g'),
                                    IconButton(
                                        onPressed: () {
                                          amountUsedCount[index] += 0.1;
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
          showFibreListModal();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

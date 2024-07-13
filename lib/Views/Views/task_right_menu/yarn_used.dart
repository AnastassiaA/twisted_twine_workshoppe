
  import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../Controllers/yarn_controller.dart';
import '../../../Controllers/yarn_used_controller.dart';
import '../../../Models/Models/yarn_model.dart';
import '../../../Models/Models/yarn_used_model.dart';

class YarnUsedPage extends StatefulWidget {
  final int taskNumber;
  const YarnUsedPage(this.taskNumber, {super.key});

  @override
  State<YarnUsedPage> createState() => _YarnUsedPageState();
}

class _YarnUsedPageState extends State<YarnUsedPage> {
  List<YarnUsedOrderModel> yarnUsedList = [];
  List<String> yarnList = [];
  bool isLoading = true;
  List<YarnModel> showYarnList = [];
  List<double> weightUsedCount = [];

  getAllYarn() async {
    final showYarnData = await YarnController.getAllYarn();

    setState(() {
      showYarnList = showYarnData.map((e) => YarnModel.fromMap(e)).toList();
    });
  }

  getAllYarnUsed() async {
    //get the list of ids for the yarn used for the particular order
    final yarnUsedData =
        await YarnUsedOrderController.getAllYarnUsed(widget.taskNumber);
    //maps this list to the model and adds the result to a new list
    yarnUsedList =
        yarnUsedData.map((e) => YarnUsedOrderModel.fromMap(e)).toList();
    //get the yarn from the yarn list that matches each of the ids from the yarnUsedList

    for (int index = 0; index < yarnUsedList.length; index++) {
      final yarnData =
          await YarnController.getOneYarn(yarnUsedList[index].thisYarnNumber);

      yarnList.add(
          yarnData.map((e) => YarnModel.fromMap(e).yarnColor).toList().single);

      weightUsedCount.add(yarnUsedList[index].amountUsed!);
    }
    setState(() {
      yarnList;
      yarnUsedList;
      weightUsedCount;
      isLoading = false;
    });
  }

  @override
  void initState() {
    getAllYarn();
    getAllYarnUsed();
    super.initState();
  }

  Future refresh() async {
    yarnList.clear();
    yarnUsedList.clear();
    weightUsedCount.clear();
    getAllYarnUsed();
  }

  showYarnListModal() async {
    showModalBottomSheet(
      context: context,
      builder: (_) => ListView.builder(
          itemCount: showYarnList.length,
          itemBuilder: ((context, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Card(
                child: ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    backgroundImage:
                        Image.memory(base64Decode(showYarnList[index].image))
                            .image,
                  ),
                  title: Text(showYarnList[index].yarnColor),
                  subtitle: Text('${showYarnList[index].material} '
                      '${showYarnList[index].size}'),
                  trailing: Text('${showYarnList[index].availableWeight} g'),
                  onTap: () {
                    setState(() {
                      yarnList.add(showYarnList[index].yarnColor);

                      yarnUsedList.add(
                        YarnUsedOrderModel(
                          thisOrderNumber: widget.taskNumber,
                          thisYarnNumber: showYarnList[index].yarnNumber!,

                          //amountUsed: 0.0;
                          //or dont have amountUsed at all but instead
                        ),
                      );

                      weightUsedCount.add(0.0);
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

  Future<void> _updateYarnUsed() async {
    for (int index = 0; index < yarnUsedList.length; index++) {
      if (yarnUsedList[index].yarnUsedNumber != null) {
        //if the yarn used was already saved
        //edit the record

        YarnUsedOrderModel yarnUsed = YarnUsedOrderModel(
            yarnUsedNumber: yarnUsedList[index].yarnUsedNumber,
            thisOrderNumber: widget.taskNumber,
            thisYarnNumber: yarnUsedList[index].thisYarnNumber,
            amountUsed: weightUsedCount[index]);

        await YarnUsedOrderController.updateYarnUsed(yarnUsed);
      } else {
        //add this new record
        YarnUsedOrderModel yarnUsed = YarnUsedOrderModel(
          thisOrderNumber: widget.taskNumber,
          thisYarnNumber: yarnUsedList[index].thisYarnNumber,
          amountUsed: weightUsedCount[index],
        );

        await YarnUsedOrderController.createYarnUsed(yarnUsed);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yarn Used'),
        actions: [
          const Tooltip(
            message: '',
            child: Icon(
              Icons.help,
              
            ),
            
          ),
          IconButton(
              onPressed: () async {
                await _updateYarnUsed();
                refresh();
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
                  itemCount: yarnList.length,
                  itemBuilder: (context, index) {
                    final yarn = yarnList[index];
                    return Dismissible(
                      //key: Key(yarn),
                      key: UniqueKey(),
                      direction: DismissDirection.startToEnd,
                      onDismissed: (direction) {
                        setState(() {
                          if (yarnUsedList[index].yarnUsedNumber != null) {
                            YarnUsedOrderController.deleteYarnUsed(
                                yarnUsedList[index].yarnUsedNumber!);
                          }

                          yarnList.removeAt(index);
                          yarnUsedList.removeAt(index);
                          weightUsedCount.removeAt(index);
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
                              title: Text(yarnList[index]),
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
          showYarnListModal();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

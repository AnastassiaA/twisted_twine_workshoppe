import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:twisted_twine_workshopppe/Controllers/fabric_controller.dart';
import 'package:twisted_twine_workshopppe/Controllers/fabrics_used_controller.dart';
import 'package:twisted_twine_workshopppe/Models/Models/fabrics_model.dart';
import 'package:twisted_twine_workshopppe/Models/Models/fabrics_used_model.dart';

class FabricsUsedPage extends StatefulWidget {
  final int taskNumber;
  const FabricsUsedPage(this.taskNumber, {super.key});

  @override
  State<FabricsUsedPage> createState() => _FabricsUsedPageState();
}

class _FabricsUsedPageState extends State<FabricsUsedPage> {
  List<FabricsUsedModel> fabricUsedList = [];
  List<FabricsModel> fabricList = [];
  bool isLoading = true;
  List<FabricsModel> showFabricList = [];

  getAllFabrics() async {
    final showFabricData = await FabricController.getAllFabrics();

    setState(() {
      showFabricList =
          showFabricData.map((e) => FabricsModel.fromMap(e)).toList();
    });
  }

  getAllFabricsUsed() async {
    final fabricUsedData =
        await FabricUsedController.getAllFabricsUsed(widget.taskNumber);

    fabricUsedList =
        fabricUsedData.map((e) => FabricsUsedModel.fromMap(e)).toList();

    for (int index = 0; index < fabricUsedList.length; index++) {
      final fabricData =
          await FabricController.getOneFabric(fabricUsedList[index].fabricsId);

      fabricList
          .add(fabricData.map((e) => FabricsModel.fromMap(e)).toList().single);
    }

    setState(() {
      fabricList;
      fabricUsedList;
      isLoading = false;
    });
  }

  @override
  void initState() {
    getAllFabrics();
    getAllFabricsUsed();
    super.initState();
  }

  Future refresh() async {
    fabricList.clear();
    fabricUsedList.clear();
    getAllFabricsUsed();
  }

  showFabricListModal() async {
    showModalBottomSheet(
        context: context,
        builder: (_) => ListView.builder(
              itemCount: showFabricList.length,
              itemBuilder: ((context, index) {
                return Card(
                  child: ListTile(
                    dense: true,
                    leading: CircleAvatar(
                      backgroundImage: Image.memory(
                              base64Decode(showFabricList[index].image))
                          .image,
                    ),
                    title: Text(showFabricList[index].fabricName),
                    subtitle: Text(showFabricList[index].description),
                    onTap: (() {
                      setState(() {
                        fabricList.add(showFabricList[index]);
                        fabricUsedList.add(FabricsUsedModel(
                            fabricsId: showFabricList[index].fabricId!,
                            taskNumber: widget.taskNumber));
                      });

                      if (!mounted) return;
                      Navigator.pop(context);
                    }),
                  ),
                );
              }),
            ));
  }

  Future<void> _updateFabricsUsed() async {
    for (int index = 0; index < fabricUsedList.length; index++) {
      if (fabricUsedList[index].fabricsUsedId != null) {
        FabricsUsedModel fabric = FabricsUsedModel(
            fabricsUsedId: fabricUsedList[index].fabricsUsedId,
            fabricsId: fabricUsedList[index].fabricsId,
            taskNumber: widget.taskNumber);

        await FabricUsedController.updateFabricUsed(fabric);
      } else {
        FabricsUsedModel fabric = FabricsUsedModel(
            fabricsId: fabricUsedList[index].fabricsId,
            taskNumber: widget.taskNumber);

        await FabricUsedController.createFabricsUsed(fabric);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fabrics Used'),
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
                await _updateFabricsUsed();
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
                itemCount: fabricList.length,
                itemBuilder: ((context, index) {
                  final needle = fabricList[index].fabricName;
                  return Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (direction) {
                      setState(() {
                        if (fabricUsedList[index].fabricsUsedId != null) {
                          FabricUsedController.deleteFabricUsed(
                              fabricUsedList[index].fabricsUsedId!);
                        }
                        fabricList.removeAt(index);
                        fabricUsedList.removeAt(index);
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("$needle fabric dismissed")));
                    },
                    background: Container(
                      color: Colors.pinkAccent,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          ListTile(title: Text(fabricList[index].fabricName)),
                    ),
                  );
                }),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showFabricListModal();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

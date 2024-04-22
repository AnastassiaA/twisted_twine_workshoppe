import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:twisted_twine_workshopppe/Controllers/knitting_needle_controller.dart';
import 'package:twisted_twine_workshopppe/Controllers/knitting_needle_used_controller.dart';
import 'package:twisted_twine_workshopppe/Models/Models/knitting_needle_model.dart';
import 'package:twisted_twine_workshopppe/Models/Models/knitting_needle_used_model.dart';

class KnittingNeedleUsedPage extends StatefulWidget {
  final int taskNumber;
  const KnittingNeedleUsedPage(this.taskNumber, {super.key});

  @override
  State<KnittingNeedleUsedPage> createState() => _KnittingNeedleUsedPageState();
}

class _KnittingNeedleUsedPageState extends State<KnittingNeedleUsedPage> {
  List<KnittingNeedleUsedModel> needleUsedList = [];
  List<KnittingNeedleModel> needleList = [];
  bool isLoading = true;
  List<KnittingNeedleModel> showNeedleList = [];

  getAllNeedles() async {
    final showNeedleData =
        await KnittingNeedleController.getAllKnittingNeedles();

    setState(() {
      showNeedleList =
          showNeedleData.map((e) => KnittingNeedleModel.fromMap(e)).toList();
    });
  }

  getAllNeedlesUsed() async {
    final needleUsedData =
        await KnittingNeedleUsedController.getAllNeedleUsed(widget.taskNumber);

    needleUsedList =
        needleUsedData.map((e) => KnittingNeedleUsedModel.fromMap(e)).toList();

    for (int index = 0; index < needleUsedList.length; index++) {
      final needleData = await KnittingNeedleController.getOneKnittingNeedle(
          needleUsedList[index].knittingNeedleId);

      needleList.add(needleData
          .map((e) => KnittingNeedleModel.fromMap(e))
          .toList()
          .single);
    }

    setState(() {
      needleList;
      needleUsedList;
      isLoading = false;
    });
  }

  @override
  void initState() {
    getAllNeedles();
    getAllNeedlesUsed();
    super.initState();
  }

  Future refresh() async {
    needleList.clear;
    needleUsedList.clear();
    getAllNeedlesUsed();
  }

  showNeedleListModal() async {
    showModalBottomSheet(
      context: context,
      builder: (_) => ListView.builder(
        itemCount: showNeedleList.length,
        itemBuilder: ((context, index) {
          return Card(
            child: ListTile(
              dense: true,
              leading: CircleAvatar(
                backgroundImage:
                    Image.memory(base64Decode(showNeedleList[index].image))
                        .image,
              ),
              title: Text(showNeedleList[index].knittingNeedleSize),
              subtitle: Text(showNeedleList[index].knittingNeedleType),
              onTap: () {
                setState(() {
                  needleList.add(showNeedleList[index]);
                  needleUsedList.add(KnittingNeedleUsedModel(
                      taskNumber: widget.taskNumber,
                      knittingNeedleId:
                          showNeedleList[index].knittingNeedleId!));
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

  Future<void> _updateNeedlesUsed() async {
    for (int index = 0; index < needleUsedList.length; index++) {
      if (needleUsedList[index].knittingNeedleUsedId != null) {
        KnittingNeedleUsedModel needleUsed = KnittingNeedleUsedModel(
            knittingNeedleUsedId: needleUsedList[index].knittingNeedleUsedId,
            taskNumber: widget.taskNumber,
            knittingNeedleId: needleUsedList[index].knittingNeedleId);

        await KnittingNeedleUsedController.updateNeedleUsed(needleUsed);
      } else {
        KnittingNeedleUsedModel needleUsed = KnittingNeedleUsedModel(
            taskNumber: widget.taskNumber,
            knittingNeedleId: needleUsedList[index].knittingNeedleId);

        await KnittingNeedleUsedController.createNeedleUsed(needleUsed);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Knitting Needle'),
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
                await _updateNeedlesUsed();
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
                itemCount: needleList.length,
                itemBuilder: ((context, index) {
                  final needle = needleList[index].knittingNeedleSize;
                  return Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (direction) {
                      setState(() {
                        if (needleUsedList[index].knittingNeedleUsedId !=
                            null) {
                          KnittingNeedleUsedController.deleteNeedleUsed(
                              needleUsedList[index].knittingNeedleUsedId!);
                        }

                        needleList.removeAt(index);
                        needleUsedList.removeAt(index);
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("$needle needle dismissed")));
                    },
                    background: Container(
                      color: Colors.pinkAccent,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                          title: Text('${needleList[index].knittingNeedleType}'
                              '\t'
                              '${needleList[index].knittingNeedleSize}')),
                    ),
                  );
                }),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showNeedleListModal();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

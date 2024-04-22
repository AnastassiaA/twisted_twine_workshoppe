import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:twisted_twine_workshopppe/Controllers/tools_controller.dart';
import 'package:twisted_twine_workshopppe/Controllers/tools_used_controller.dart';
import 'package:twisted_twine_workshopppe/Models/Models/tools_used_model.dart';

import '../../../Models/Models/tools_model.dart';

class ToolsUsedPage extends StatefulWidget {
  final int taskNumber;
  const ToolsUsedPage(this.taskNumber, {super.key});

  @override
  State<ToolsUsedPage> createState() => _ToolsUsedPageState();
}

class _ToolsUsedPageState extends State<ToolsUsedPage> {
  List<ToolsUsedModel> toolsUsedList = [];
  List<String> toolsList = [];
  bool isLoading = true;
  List<ToolsModel> showToolsList = [];

  getAllTools() async {
    final showToolsData = await ToolsController.getAllTools();

    setState(() {
      showToolsList = showToolsData.map((e) => ToolsModel.fromMap(e)).toList();
    });
  }

  getAllToolsUsed() async {
    final toolsUsedData =
        await ToolsUsedController.getAllToolsUsed(widget.taskNumber);

    toolsUsedList =
        toolsUsedData.map((e) => ToolsUsedModel.fromMap(e)).toList();

    for (int index = 0; index < toolsUsedList.length; index++) {
      final toolsData =
          await ToolsController.getOneTools(toolsUsedList[index].toolId);

      toolsList.add(
          toolsData.map((e) => ToolsModel.fromMap(e).toolName).toList().single);
    }

    setState(() {
      toolsUsedList;
      toolsList;
      isLoading = false;
    });
  }

  @override
  void initState() {
    getAllTools();
    getAllToolsUsed();
    super.initState();
  }

  Future refresh() async {
    toolsList.clear();
    toolsUsedList.clear();
    getAllToolsUsed();
  }

  showTrimmingsListModal() async {
    showModalBottomSheet(
      context: context,
      builder: (_) => ListView.builder(
          itemCount: showToolsList.length,
          itemBuilder: ((context, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Card(
                child: ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    backgroundImage:
                        Image.memory(base64Decode(showToolsList[index].image!))
                            .image,
                  ),
                  title: Text(showToolsList[index].toolName),
                  onTap: () {
                    setState(() {
                      toolsList.add(showToolsList[index].toolName);

                      toolsUsedList.add(ToolsUsedModel(
                          toolId: showToolsList[index].toolsId!,
                          taskNumber: widget.taskNumber));
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

  Future<void> _updateToolsUsed() async {
    for (int index = 0; index < toolsUsedList.length; index++) {
      if (toolsUsedList[index].toolUsedId != null) {
        ToolsUsedModel tools = ToolsUsedModel(
            toolUsedId: toolsUsedList[index].toolUsedId,
            toolId: toolsUsedList[index].toolId,
            taskNumber: widget.taskNumber);

        await ToolsUsedController.updateToolsUsed(tools);
      } else {
        ToolsUsedModel tools = ToolsUsedModel(
            toolId: toolsUsedList[index].toolId, taskNumber: widget.taskNumber);

        await ToolsUsedController.createToolsUsed(tools);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tools Used'),
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
                await _updateToolsUsed();
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
                  itemCount: toolsList.length,
                  itemBuilder: (context, index) {
                    final tool = toolsList[index];
                    return Dismissible(
                      //key: Key(yarn),
                      key: UniqueKey(),
                      direction: DismissDirection.startToEnd,
                      onDismissed: (direction) {
                        setState(() {
                          if (toolsUsedList[index].toolUsedId != null) {
                            ToolsUsedController.deleteToolsUsed(
                                toolsUsedList[index].toolUsedId!);
                          }

                          toolsList.removeAt(index);
                          toolsUsedList.removeAt(index);
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("$tool dismissed")));
                      },
                      background: Container(color: Colors.pinkAccent),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(toolsList[index]),
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

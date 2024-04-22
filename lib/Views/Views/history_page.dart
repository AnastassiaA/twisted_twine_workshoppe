import 'dart:convert';
import 'dart:io';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:twisted_twine_workshopppe/Controllers/history_controller.dart';

import '../../Controllers/craft_type_controller.dart';
import '../../Models/Models/craft_type_model.dart';
import '../../Models/Models/history_model.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<HistoryModel> historyList = [];
  List<DropdownMenuItem<String>> craftTypeList = [];

  bool isLoading = true;

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final monthYearController = TextEditingController();

  String craftType = '';
  bool completionStatus = false;

  getAllHistory() async {
    final historyData = await HistoryController.getAllHistory();

    setState(() {
      historyList = historyData.map((e) => HistoryModel.fromMap(e)).toList();
      isLoading = false;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getAllHistory();
    super.initState();
    CraftTypeController.getAllCraftTypes().then((value) {
      value.map((e) {
        return getDropDown(CraftTypeModel.fromMap(e).craftTypeName);
      }).forEach((element) {
        craftTypeList.add(element);
      });
      setState(() {});
    });
  }

  DropdownMenuItem<String> getDropDown(String item) {
    return DropdownMenuItem(value: item, child: Text(item));
  }

  Future refresh() async {
    historyList.clear();
    getAllHistory();
  }

  void _form(int? id) async {
    if (id != null) {
      final thisHistory =
          historyList.firstWhere((element) => element.historyId == id);
      nameController.text = thisHistory.name;
      completionStatus = thisHistory.completionStatus;
      craftType = thisHistory.craftType;
      monthYearController.text = thisHistory.monthYear.toString();
      descriptionController.text = thisHistory.description;
    }

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Center(
                      child: Text(
                        'History',
                      ),
                    ),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Title'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Checkbox(
                          value: completionStatus,
                          onChanged: (value) {
                            setState(() {
                              completionStatus = !completionStatus;
                            });
                          },
                        ),
                        const Text("Was it completed?")
                      ],
                    ),  
                    //CRAFT TYPE DROPDOWN MENU
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: DropdownButtonFormField(
                          hint: const Text('Craft Type'),
                          items: craftTypeList,
                          onChanged: (String? value) {
                            setState(() {
                              craftType = value!;
                            });
                          }),
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    DateTimePicker(
                      controller: monthYearController,
                      initialValue: null,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      dateLabelText: 'When did you start it?',
                      onChanged: (val) => print(val),
                      validator: (val) {
                        return null;
                      },
                      onSaved: (val) => print(val),
                    ),
                    ElevatedButton(
                        child:
                            Text(id == null ? 'ADD HISTORY' : 'UPDATE HISTORY'),
                        onPressed: () async {
                          if (id == null) {
                            await HistoryController.createHistory(HistoryModel(
                                name: nameController.text,
                                completionStatus: completionStatus,
                                craftType: craftType,
                                monthYear:
                                    DateTime.parse(monthYearController.text),
                                description: descriptionController.text));
                          }
                          if (id != null) {
                            await HistoryController.createHistory(HistoryModel(
                                historyId: id,
                                name: nameController.text,
                                completionStatus: completionStatus,
                                craftType: craftType,
                                monthYear:
                                    DateTime.parse(monthYearController.text),
                                description: descriptionController.text));
                          }

                          if (!mounted) return;
                          Navigator.pop(
                            context,
                          );
                          refresh();
                        })
                  ]),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
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
              itemCount: historyList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    isThreeLine: true,
                    title: Text(historyList[index].name),
                    subtitle: Text('${historyList[index].monthYear}'
                        '\n'
                        '${historyList[index].craftType}'
                        '${historyList[index].description}'),
                    trailing: historyList[index].completionStatus == true
                        ? const Icon(Icons.check)
                        : null,
                  ),
                );
              }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _form(null);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

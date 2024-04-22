import 'dart:convert';

import 'package:flutter/material.dart';

import '../../Controllers/task_controller.dart';
import '../../Models/Models/task_model.dart';
import '../Cards/task_card.dart';
import '../Forms/add_commission_form.dart';

class CommissionsPage extends StatefulWidget {
  const CommissionsPage({super.key});

  @override
  State<CommissionsPage> createState() => _CommissionsPageState();
}

class _CommissionsPageState extends State<CommissionsPage> {
  List<TaskModel> commissionsList = [];
  //List<int> rowList = []; //list of task numbers from rows
  bool isLoading = true;

  getAllCommissions() async {
    final commissionsData =
        await TaskController.getAllTasksOfType('commission');

    setState(() {
      commissionsList =
          commissionsData.map((e) => TaskModel.fromMap(e)).toList();
      isLoading = false;
    });
  }

  @override
  void initState() {
    getAllCommissions();
    super.initState();
  }

  Future refresh() async {
    commissionsList.clear();
    getAllCommissions();
  }

  void deleteCommissions(
      {required TaskModel commission, required BuildContext context}) async {
    TaskController.deleteTask(commission.taskNumber!).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${commission.taskName} deleted')));
    }).catchError((e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    });
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    List<PopupMenuEntry> popUpMenuList = [
      PopupMenuItem(
        child: InkWell(
          onTap: () {},
          child: const Row(
            children: [
              Text("Filter by"),
            ],
          ),
        ),
      ),
      PopupMenuItem(
        value: "Name",
        child: InkWell(
          onTap: () {
            Navigator.pop(context, "Name");
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => EditOrder(widget.model),
            //   ),
            // );
          },
          child: const Row(
            children: [
              Text("Name"),
            ],
          ),
        ),
      ),
      PopupMenuItem(
        value: "Start Date",
        child: InkWell(
          onTap: () {
            Navigator.pop(context, "Start Date");
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => EditOrder(widget.model),
            //   ),
            // );
          },
          child: const Row(
            children: [
              Text("Start Date"),
            ],
          ),
        ),
      ),
    ];
    return Scaffold(
      appBar: AppBar( 
        title: const Text("Commissions"),
        actions: [
          const Tooltip(
            message: 'Long press to delete' '\n\n' 'Tap to see more details',
            child: Icon(
              Icons.help,
            ),
            
          ),
          PopupMenuButton(
              icon: const Icon(
                Icons.sort,
                color: Colors.grey,
              ),
              itemBuilder: (context) {
                return popUpMenuList;
              }),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: commissionsList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[350],
                      radius: 30,
                      backgroundImage: Image.memory(
                              base64Decode(commissionsList[index].image))
                          .image,
                    ),
                    title: Text(commissionsList[index].taskName),
                    subtitle: Text(commissionsList[index].customer),
                    trailing: Text(commissionsList[index].status),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Tasks(commissionsList[index]),
                        ),
                      );
                      //generateRowRecords();
                    },
                    onLongPress: () => showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Delete '
                                '"'
                                '${commissionsList[index].taskName}'
                                '"'),
                            content: const Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Are you sure?'),
                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(
                                    context,
                                  );
                                },
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                  onPressed: () async {
                                    // final result = await OrderController()
                                    //     .deleteOrder(
                                    //         _ordersList[index].orderNumber);
                                    deleteCommissions(
                                        commission: commissionsList[index],
                                        context: context);

                                    if (!mounted) return;

                                    Navigator.pop(
                                      context,
                                    );
                                    //getAllOrders();
                                    refresh();
                                  },
                                  child: const Text('Delete')),
                            ],
                          );
                        }),
                  ),
                );
              }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCommissionForm()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

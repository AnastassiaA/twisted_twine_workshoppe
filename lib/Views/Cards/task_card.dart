import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:twisted_twine_workshopppe/Controllers/timer_controller.dart';
import 'package:twisted_twine_workshopppe/Views/Views/task_right_menu/fabrics_used.dart';
import 'package:twisted_twine_workshopppe/Views/Views/task_right_menu/other_fibres_used.dart';
import 'package:twisted_twine_workshopppe/Views/Views/task_right_menu/pricing_caculator.dart';
import 'package:twisted_twine_workshopppe/Views/Views/task_right_menu/trimmings_used.dart';
import '../../Models/Models/task_model.dart';
import '../Forms/edit_commission.dart';
import '../Forms/edit_project_form.dart';
import '../Views/task_right_menu/crochet_hook_used.dart';
import '../Views/task_right_menu/crochet_thread_used.dart';
import '../Views/task_right_menu/expense_and_deposit_used.dart';
import '../Views/task_right_menu/knitting_needle_used.dart';
import '../Views/task_right_menu/row_counter_widget.dart';
import '../Views/task_right_menu/tools_used.dart';
import '../Views/task_right_menu/yarn_used.dart';

class Tasks extends StatefulWidget {
  final TaskModel model;
  const Tasks(this.model, {Key? key}) : super(key: key);

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  Duration totalTime = const Duration();

  Future total(int id) async {
    final result = (await TimerController.sumAllTimes(id))[0]['total'];

    setState(() {
      if (result != null) {
        totalTime = Duration(seconds: result);
      }
    });
  }

  @override
  void initState() {
    total(widget.model.taskNumber!);
    super.initState();
  }

  Widget showDate() {
    switch (widget.model.status) {
      case "Pending":
        return Container();

      case "In Progress":
        return ListTile(
            leading: const Icon(Icons.date_range_rounded),
            title: Text(
                "Started: ${(DateFormat.yMMMd().format(widget.model.dateStarted!)).toString()}"));

      case "Complete":
        return Column(
          children: [
            ListTile(
                leading: const Icon(Icons.date_range_rounded),
                title: Text(
                    "Started: ${(DateFormat.yMMMd().format(widget.model.dateStarted!)).toString()}")),
            ListTile(
                leading: const Icon(Icons.date_range_rounded),
                title: Text(
                    "Completed: ${(DateFormat.yMMMd().format(widget.model.dateCompleted!)).toString()}"))
          ],
        );

      case "On Hold":
        return ListTile(
            leading: const Icon(Icons.date_range_rounded),
            title: Text(
                "Started: ${(DateFormat.yMMMd().format(widget.model.dateStarted!)).toString()}"));

      case "Dropped":
        return Container();

      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<PopupMenuEntry> popUpMenuList = [
      PopupMenuItem(
        value: "Edit this",
        child: InkWell(
          onTap: () {
            Navigator.pop(context, "Edit this");

            switch (widget.model.taskType) {
              case 'project':
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProject(widget.model),
                  ),
                );
                break;

              case 'commission':
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditOrder(widget.model),
                  ),
                );
                break;
              default:
                return;
            }
          },
          child: const Row(
            children: [
              Icon(Icons.edit),
              SizedBox(width: 5),
              Text("Edit this"),
            ],
          ),
        ),
      ),
      PopupMenuItem(
        value: "Yarn Used",
        child: InkWell(
          onTap: () {
            Navigator.pop(context, "Yarn Used");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => YarnUsedPage(widget.model.taskNumber!),
              ),
            );
          },
          child: const Row(
            children: [
              Icon(Icons.grass_rounded),
              SizedBox(width: 5),
              Text("Yarn Used"),
            ],
          ),
        ),
      ),
      PopupMenuItem(
        value: "Crochet Thread Used",
        child: InkWell(
          onTap: () {
            Navigator.pop(context, "Crochet Thread Used");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CrochetThreadUsedPage(widget.model.taskNumber!),
              ),
            );
          },
          child: const Row(
            children: [
              Icon(Icons.grass),
              SizedBox(width: 5),
              Text("Crochet Thread Used"),
            ],
          ),
        ),
      ),
      PopupMenuItem(
        value: "Knitting Needles Used",
        child: InkWell(
          onTap: () {
            Navigator.pop(context, "Knitting Needles Used");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    KnittingNeedleUsedPage(widget.model.taskNumber!),
              ),
            );
          },
          child: const Row(
            children: [
              Icon(Icons.auto_awesome_rounded),
              SizedBox(width: 5),
              Text("Knitting Needles Used"),
            ],
          ),
        ),
      ),
      PopupMenuItem(
        value: "Crochet Hook Used",
        child: InkWell(
          onTap: () {
            Navigator.pop(context, "Crochet Hook Used");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CrochetHookUsedPage(widget.model.taskNumber!),
              ),
            );
          },
          child: const Row(
            children: [
              Icon(Icons.auto_awesome),
              SizedBox(width: 5),
              Text("Crochet Hook Used"),
            ],
          ),
        ),
      ),
      PopupMenuItem(
        value: "Other Fibres Used",
        child: InkWell(
          onTap: () {
            Navigator.pop(context, "Other Fibres Used");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    OtherFibresUsedPage(widget.model.taskNumber!),
              ),
            );
          },
          child: const Row(
            children: [
              Icon(Icons.grass_sharp),
              SizedBox(width: 5),
              Text("Other Fibres Used"),
            ],
          ),
        ),
      ),
      PopupMenuItem(
        value: "Fabrics Used",
        child: InkWell(
          onTap: () {
            Navigator.pop(context, "Fabrics Used");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FabricsUsedPage(widget.model.taskNumber!),
              ),
            );
          },
          child: const Row(
            children: [
              Icon(Icons.grass_sharp),
              SizedBox(width: 5),
              Text("Fabrics Used"),
            ],
          ),
        ),
      ),
      PopupMenuItem(
        value: "Trimmings Used",
        child: InkWell(
          onTap: () {
            Navigator.pop(context, "Trimmings Used");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    TrimmingsUsedPage(widget.model.taskNumber!),
              ),
            );
          },
          child: const Row(
            children: [
              Icon(Icons.content_cut),
              SizedBox(width: 5),
              Text("Trimmings Used"),
            ],
          ),
        ),
      ),
      PopupMenuItem(
        value: "Tools Used",
        child: InkWell(
          onTap: () {
            Navigator.pop(context, "Tools Used");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ToolsUsedPage(widget.model.taskNumber!),
              ),
            );
          },
          child: const Row(
            children: [
              Icon(Icons.build),
              SizedBox(width: 5),
              Text("Tools Used"),
            ],
          ),
        ),
      ),
      PopupMenuItem(
        value: "Expenses and Deposits",
        child: InkWell(
          onTap: () {
            Navigator.pop(context, "Expenses and Deposits");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ExpenseDepositUsedPage(widget.model.taskNumber!),
              ),
            );
          },
          child: const Row(
            children: [
              Icon(Icons.receipt_long_rounded),
              SizedBox(width: 5),
              Text("Expenses and Deposits"),
            ],
          ),
        ),
      ),
      PopupMenuItem(
        value: "Pricing Calculator",
        child: InkWell(
          onTap: () {
            Navigator.pop(context, "Pricing Calculator");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PricingCalculator(widget.model.taskNumber!),
              ),
            );
          },
          child: const Row(
            children: [
              Icon(Icons.calculate_outlined),
              SizedBox(width: 5),
              Text("Pricing Calculator"),
            ],
          ),
        ),
      ),
    ];

    String twoDigits(int n) => n.toString().padLeft(2, '0');

    return Scaffold(
      //extendBodyBehindAppBar: true,
      appBar: AppBar(
        //backgroundColor: Colors.transparent,
        title: Text(widget.model.taskName),
        actions: [
          TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RowCounter(widget.model.taskNumber!),
                  ),
                );
              },
              icon: const Icon(Icons.swap_vert),
              label: const Text('Rows')),
          PopupMenuButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.grey,
              ),
              itemBuilder: (context) {
                return popUpMenuList;
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10.0),
              decoration: BoxDecoration(
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.5,
              child: Image.memory(
                base64Decode(widget.model.image),
                fit: BoxFit.cover,
              ),
            ),
            Row(
              children: [
                //Text('Row Number: ${widget.model.rowNumber.toString()}'),
                Text(
                    'Total time: ${twoDigits(totalTime.inHours.remainder(60))} hr'
                    ' '
                    '${twoDigits(totalTime.inMinutes.remainder(60))} min'
                    ' '
                    '${twoDigits(totalTime.inSeconds.remainder(60))} sec'),
              ],
            ),
            showDate(),
            ListTile(
                leading: const Icon(Icons.contacts_rounded),
                title: Text(widget.model.customer)),
            ListTile(title: Text('Craft Type: ${widget.model.craftType}')),
            ListTile(title: Text('Status: ${widget.model.status}')),
            ListTile(
                title: Text('Description' '\n' '${widget.model.description}')),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:twisted_twine_workshopppe/Controllers/row_controller.dart';
import 'package:twisted_twine_workshopppe/Models/Models/row_model.dart';

class RowCounter extends StatefulWidget {
  int taskNumber;
  RowCounter(this.taskNumber, {super.key});

  @override
  State<RowCounter> createState() => _CounterState();
}

class _CounterState extends State<RowCounter> {
  List<RowModel> rowList = [];
  RowModel row = RowModel(rowId: null, rowCount: 0, taskNumber: 0);

  getRowCount() async {
    final rowData = await RowController.getAllRowRecords();

    rowList = rowData.map((e) => RowModel.fromMap(e)).toList();

    row = rowList.firstWhere(
        (element) => element.taskNumber == widget.taskNumber,
        orElse: () => row =
            RowModel(rowId: null, rowCount: 0, taskNumber: widget.taskNumber));

    setState(() {
      row;
      rowList.clear();
    });
  }

  @override
  void initState() {
    getRowCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //int rowCount = widget.row.rowCount;
    return Scaffold(
        appBar: AppBar(
          actions: const [
            Tooltip(
            message: 'Long press a commission to delete',
            child: Icon(
              Icons.help,
              color: Colors.grey,
            ),
            
          ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                Color(0xffe7d0f5),
                Color(0xffefdff9),
              ])),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Row Counter",
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.w600),
              ),
              GestureDetector(
                onLongPress: () => showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Clear Counter?'),
                        actions: [
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  row.rowCount = 0;
                          
                                  if (!mounted) return;
                                  Navigator.pop(context);
                                });
                              },
                              child: const Text('OK'),
                            ),
                          ),
                        ],
                      );
                    }),
                child: Text(
                  '${row.rowCount}',
                  style: const TextStyle(fontSize: 180),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      row.rowCount -= 1;
                      setState(
                        () => row.rowCount,
                      );
                    },
                    icon: const Icon(Icons.do_disturb_on_outlined),
                    iconSize: 90,
                  ),
                  TextButton(
                    onPressed: () async {
                      if (row.rowId != null) {
                        await RowController.updateRowRecord(RowModel(
                            rowId: row.rowId,
                            rowCount: row.rowCount,
                            taskNumber: row.taskNumber));
                      } else {
                        await RowController.createRowRecord(RowModel(
                            rowCount: row.rowCount,
                            taskNumber: row.taskNumber));
                      }
                      // if (!mounted) return;
                      // Navigator.pop(context);
                    },
                    child: const Text(
                      "SAVE",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      row.rowCount += 1;
                      setState(
                        () => row.rowCount,
                      );
                    },
                    icon: const Icon(Icons.add_circle_outline),
                    iconSize: 90,
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}

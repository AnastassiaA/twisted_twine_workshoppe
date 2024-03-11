import 'dart:async';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:twisted_twine_workshopppe/Controllers/timer_controller.dart';
import 'package:twisted_twine_workshopppe/Models/Models/timer_model.dart';

import '../../Controllers/task_controller.dart';
import '../../Models/Models/task_model.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  Duration duration = const Duration();
  Duration time = const Duration();
  Timer? timer;

  int taskNumber = 0;
  String commissionName = '';
  final Stopwatch stopWatch = Stopwatch();

  List<DropdownMenuItem<String>> commissionList = [];
  String commName = '';
  bool isSelected = false;

  late DateTime startDateTime;
  late DateTime endDateTime;
  DropdownMenuItem<String> getDropDown(int id, String taskName) {
    return DropdownMenuItem(
        value: ("$id" ". " "$taskName"), child: Text("$id" ". " "$taskName"));
  }

  void start() {
    stopWatch.start();
    startDateTime = DateTime.now();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      const addSeconds = 1;

      setState(() {
        final seconds = duration.inSeconds + addSeconds;

        duration = Duration(seconds: seconds);
      });
    });
  }

  void stop() {
    timer?.cancel();
    stopWatch.stop();
    endDateTime = DateTime.now();
    time = duration;
    duration = Duration.zero;
    stopWatch.reset();

    Future.delayed(const Duration(seconds: 4));
  }

  @override
  void initState() {
    super.initState();
    TaskController.getAllTasks().then((value) {
      value.map((e) {
        return getDropDown(
          TaskModel.fromMap(e).taskNumber!,
          TaskModel.fromMap(e).taskName,
        );
      }).forEach((element) {
        commissionList.add(element);
      });
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    final hours = twoDigits(duration.inHours.remainder(60));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Timer"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TimerList()),
              );
            },
            icon: const Icon(
              Icons.menu,
              color: Colors.grey,
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            DropdownButtonFormField(
                iconSize: 40,
                padding: const EdgeInsets.all(12.0),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xffe7d0f5),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Color(0xffe7d0f5), width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xffe7d0f5)),
                      borderRadius: BorderRadius.circular(16)),
                ),
                hint: const Text('Task List'),
                items: commissionList,
                onChanged: (String? value) {
                  setState(() {
                    commName = value!;
                    isSelected = true;

                    taskNumber = int.parse(commName.split('. ')[0]);
                    commissionName = commName.split('. ')[1];
                  });
                }),
            Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                  //border: Border(),
                  borderRadius: BorderRadius.circular(200),
                  color: const Color(0xffe7d0f5),
                  boxShadow: [
                    const BoxShadow(
                        offset: Offset(10, 10),
                        color: Colors.black38,
                        blurRadius: 15),
                    BoxShadow(
                        offset: const Offset(-10, -10),
                        color: Colors.white.withOpacity(0.85),
                        blurRadius: 15)
                  ]),
              child: Center(
                child: Text(
                  //result,
                  '$hours:$minutes:$seconds',
                  style: const TextStyle(fontSize: 50.0),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (stopWatch.isRunning) {
                    stop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddTimerDuration(TimerModel(
                                taskNumber: taskNumber,
                                commissionName: commissionName,
                                startDateTime: startDateTime,
                                endDateTime: endDateTime,
                                amountTime: time))));

                    setState(() {});
                  } else {
                    if (isSelected != true) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content:
                                  const Text("Select a commission/project"),
                              actions: [
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      duration = Duration.zero;
                                      Navigator.pop(
                                        context,
                                      );
                                    },
                                    child: const Text("OK"),
                                  ),
                                )
                              ],
                            );
                          });
                    } else {
                      start();
                    }
                  }
                });
              },
              child: stopWatch.isRunning
                  ? const Text(
                      "Stop",
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    )
                  : const Text(
                      "Start",
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class TimerList extends StatefulWidget {
  const TimerList({super.key});

  @override
  State<TimerList> createState() => _TimerListState();
}

class _TimerListState extends State<TimerList> {
  List<TimerModel> timeList = [];
  bool isLoading = true;

  getAllTimers() async {
    final timeData = await TimerController.getAllTimers();

    setState(() {
      timeList = timeData.map((e) => TimerModel.fromMap(e)).toList();
      isLoading = false;
    });

    // else {

    //   setState(() {
    //     isLoading = false;

    //   const SnackBar(content: Text("None found"));
    //   });

    // }
  }

  @override
  initState() {
    getAllTimers();
    super.initState();
  }

  Future refresh() async {
    timeList.clear();
    getAllTimers();
  }

  void deleteTime(
      {required TimerModel time, required BuildContext context}) async {
    TimerController.deleteTime(time.timeSlotId!).then((value) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Deleted')));
    }).catchError((e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    });
    getAllTimers();
  }

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(title: const Text("Times"), actions: const [
        IconButton(onPressed: null, icon: Icon(Icons.sort)),
        // IconButton(
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //             builder: (context) => AddTimerDuration(TimerModel(
        //                 taskNumber: null,
        //                 commissionName: commissionName,
        //                 startDateTime: startDateTime,
        //                 endDateTime: endDateTime,
        //                 amountTime: amountTime))),
        //       );
        //     },
        //     icon: const Icon(Icons.add)),
      ]),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: timeList.length,
              itemBuilder: ((context, index) {
                return Card(
                  child: GestureDetector(
                    onDoubleTap: () {
                      showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Delete '
                                    '"'
                                    'Time Slot'
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
                                    onPressed: () {
                                      deleteTime(
                                          time: timeList[index],
                                          context: context);

                                      Navigator.pop(
                                        context,
                                      );
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              );
                            });
                    },
                    onLongPress: () {
                      showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Delete '
                                    '"'
                                    'Time Slot'
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
                                    onPressed: () {
                                      deleteTime(
                                          time: timeList[index],
                                          context: context);

                                      Navigator.pop(
                                        context,
                                      );
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              );
                            });
                    },
                    child: ListTile(
                      title: Text(timeList[index].commissionName),
                      trailing: Text(
                          '${twoDigits(timeList[index].amountTime.inHours.remainder(60))} hr'
                          ' '
                          '${twoDigits(timeList[index].amountTime.inMinutes.remainder(60))} min'
                          ' '
                          '${twoDigits(timeList[index].amountTime.inSeconds.remainder(60))} sec'),
                      
                    ),
                  ),
                );
              })),
    );
  }
}

class AddTimerDuration extends StatefulWidget {
  final TimerModel timeSlot;

  const AddTimerDuration(this.timeSlot, {super.key});

  @override
  State<AddTimerDuration> createState() => _AddTimerDurationState();
}

class _AddTimerDurationState extends State<AddTimerDuration> {
  final descriptionController = TextEditingController();
  final startDateTimeController = TextEditingController();
  final endDateTimeController = TextEditingController();

  Duration difference = const Duration();

  Future<void> _addTaskTime() async {
    TimerModel time = TimerModel(
        taskNumber: widget.timeSlot.taskNumber,
        commissionName: widget.timeSlot.commissionName,
        startDateTime: DateTime.parse(startDateTimeController.text),
        endDateTime: DateTime.parse(endDateTimeController.text),
        amountTime: difference,
        description: descriptionController.text);

    await TimerController.createTime(time);
  }

  @override
  void initState() {
    startDateTimeController.text = widget.timeSlot.startDateTime.toString();
    endDateTimeController.text = widget.timeSlot.endDateTime.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    difference = widget.timeSlot.amountTime;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Save Task"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DateTimePicker(
              type: DateTimePickerType.dateTimeSeparate,
              controller: startDateTimeController,
              initialValue: null,
              icon: const Icon(Icons.calendar_month_rounded),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              onChanged: (value) {
                difference = DateTime.parse(endDateTimeController.text)
                    .difference(DateTime.parse(startDateTimeController.text));

                if (difference.isNegative) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content:
                              const Text("Start date cannot be after end date"),
                          actions: [
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(
                                    context,
                                  );
                                },
                                child: const Text("OK"),
                              ),
                            )
                          ],
                        );
                      });
                }
              },
              validator: (val) {
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DateTimePicker(
              type: DateTimePickerType.dateTimeSeparate,
              controller: endDateTimeController,
              initialValue: null,
              icon: const Icon(Icons.calendar_month_rounded),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              validator: (val) {
                return null;
              },
              onChanged: (value) {
                difference = DateTime.parse(endDateTimeController.text)
                    .difference(DateTime.parse(startDateTimeController.text));

                if (difference.isNegative) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: const Text(
                              "End date cannot be before start date"),
                          actions: [
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(
                                    context,
                                  );
                                },
                                child: const Text(" OK"),
                              ),
                            )
                          ],
                        );
                      });
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: TextFormField(
              controller: descriptionController,
              keyboardType: TextInputType.text,
              showCursor: true,
              decoration: const InputDecoration(
                labelText: 'What did you do?',
              ),
            ),
          ),
          Center(
            child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: ElevatedButton(
                  onPressed: () async {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Saving Time')));

                    _addTaskTime();
                    if (!mounted) return;
                    Navigator.pop(context);
                  },
                  child: const Text("save"),
                )),
          )
        ],
      ),
    );
  }
}

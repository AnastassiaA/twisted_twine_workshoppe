import 'package:flutter/material.dart';

//I need a calender icon and a formfield
//formfield opens a show dialog button
//timelabeltext
//icon
//showdialogbox
//formfield

class MyTimePicker extends StatefulWidget {
  final String? labelText;
  //ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final TextEditingController? controller;
  
  const MyTimePicker(
      {
        this.controller,
        this.onTap,
        this.labelText,
      //this.icon,
      //this.labelText,

      super.key});

  @override
  State<MyTimePicker> createState() => _MyTimePickerState();
}

class _MyTimePickerState extends State<MyTimePicker> {
  final hourController = TextEditingController();
  final minuteController = TextEditingController();
  final controller = TextEditingController();
  Duration duration = const Duration();

  @override
  void initState() {
    hourController.text = "000";
    minuteController.text = "00";
    super.initState();
  }

  Duration timePickerDialogScreen() {
    showAdaptiveDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: SizedBox(
              height: 270,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20.0, left: 15.0),
                        child: Text(
                          "Enter duration",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 110,
                        child: TextFormField(
                          controller: hourController,
                          textAlign: TextAlign.center,
                          maxLength: 3,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontSize: 40),
                          decoration: const InputDecoration(
                              filled: true,
                              fillColor: Color.fromARGB(255, 223, 210, 243),
                              //contentPadding: EdgeInsets.all(8.0),
                              helperText: "Hour",
                              border: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  borderSide: BorderSide(
                                      width: 3, color: Color(0xff997ABD)))),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 2.0, bottom: 20.0),
                        child: Text(
                          ":",
                          style: TextStyle(fontSize: 40),
                        ),
                      ),
                      SizedBox(
                        width: 110,
                        child: TextFormField(
                          controller: minuteController,
                          textAlign: TextAlign.center,
                          maxLength: 2,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontSize: 40),
                          decoration: const InputDecoration(
                            //disabledBorder: OutlineInputBorder(),
                            filled: true,
                            fillColor: Color.fromARGB(255, 223, 210, 243),
                            //Color(0xffe7d0f5),
                            //contentPadding: EdgeInsets.all(8.0),
                            helperText: "Minute",
                            border: InputBorder.none,

                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                                borderSide: BorderSide(
                                    width: 2, color: Color(0xff997ABD))),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Cancel")),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(bottom: 20.0, right: 20.0),
                        child: TextButton(
                            onPressed: () {
                              setState(() {
                                duration = Duration(
                                    hours: int.parse(hourController.text),
                                    minutes: int.parse(minuteController.text));
                              });
                              if (!mounted) return;
                              Navigator.of(context).pop();
                            },
                            child: const Text("OK")),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });

    return duration;
  }

  @override
  Widget build(BuildContext context) {
    String threeDigits(int n) => n.toString().padLeft(3, '0');
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.all(1.0),
          child: Icon(Icons.av_timer_outlined),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 200.0),
            child: TextFormField(
              controller: controller,
              onTap: () {
                setState(() {
                  final time = timePickerDialogScreen();
                  final minutes = twoDigits(time.inMinutes.remainder(60));
                  final hours = threeDigits(time.inHours.remainder(60));

                  controller.text = "$hours : $minutes";
                });
              },
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Duration'),
            ),
          ),
        ),
      ],
    );
  }
}

//line 1859 in time picker

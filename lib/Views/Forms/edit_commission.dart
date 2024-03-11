import 'dart:convert';
import 'dart:io';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:image_picker/image_picker.dart';

import '../../Controllers/craft_type_controller.dart';
import '../../Controllers/task_controller.dart';
import '../../Models/Models/craft_type_model.dart';
import '../../Models/Models/task_model.dart';
import '../Views/commissions_page.dart';

class EditOrder extends StatefulWidget {
  final TaskModel model;
  const EditOrder(this.model, {super.key});

  @override
  State<EditOrder> createState() => _EditOrderState();
}

class _EditOrderState extends State<EditOrder> {
  final _formKey = GlobalKey<FormState>();

  final orderNameController = TextEditingController();
  final customerContactController = TextEditingController();
  final descriptionController = TextEditingController();
  final rowCountController = TextEditingController();
  final dateStartedController = TextEditingController();
  final dateCompletedController = TextEditingController();

  final FlutterContactPicker _contactPicker = FlutterContactPicker();
  Contact? _contact;

  String craftTypeValue = '';

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "Status", child: Text("Status")),
      const DropdownMenuItem(value: "Pending", child: Text("Pending")),
      const DropdownMenuItem(value: "In Progress", child: Text("In Progress")),
      const DropdownMenuItem(value: "Complete", child: Text("Complete")),
      const DropdownMenuItem(value: "On Hold", child: Text("On Hold")),
      const DropdownMenuItem(value: "Dropped", child: Text("Dropped")),
    ];

    return menuItems;
  }

  File? _selectedPictureImage;

  String base64Image = "";

  void _pickAPicture() async {
    final imagePicker = ImagePicker();

    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery, maxWidth: 600);

    setState(() {
      _selectedPictureImage = File(pickedImage!.path);
    });
    List<int> convertImage = await pickedImage!.readAsBytes();
    base64Image = base64Encode(convertImage);
  }

  //Image.memory(base64Decode(model.image)).image

  String selectedValue = "Status";

  //File? _selectedImage;
  bool depositMade = false;
  int depositValue = 0;

  List<DropdownMenuItem<String>> craftTypeList = [];

  @override
  void initState() {
    super.initState();

    CraftTypeController.getAllCraftTypes().then((value) {
      value.map((e) {
        return getDropDown(CraftTypeModel.fromMap(e).craftTypeName);
      }).forEach((element) {
        craftTypeList.add(element);
      });
      setState(() {});
    });
    setState(() {
      orderNameController.text = widget.model.taskName;

      craftTypeValue = widget.model.craftType;
      selectedValue = widget.model.status;
      dateStartedController.text = widget.model.dateStarted.toString();
      dateCompletedController.text = widget.model.dateCompleted.toString();
      descriptionController.text = widget.model.description;
      base64Image = widget.model.image;
      depositMade = widget.model.depositMade == 1 ? true : false;
      //rowCountController.text = widget.model.rowNumber.toString();
    });
  }

  DropdownMenuItem<String> getDropDown(String item) {
    return DropdownMenuItem(value: item, child: Text(item));
  }

  @override
  void dispose() {
    super.dispose();
    orderNameController.dispose();
    customerContactController.dispose();
    descriptionController.dispose();
    rowCountController.dispose();
    dateStartedController.dispose();
    dateCompletedController.dispose();
  }

  Future<void> _updateItem() async {
    TaskModel commission = TaskModel(
        taskNumber: widget.model.taskNumber,
        taskName: orderNameController.text,
        image: base64Image,
        customer:
            _contact == null ? widget.model.customer : _contact.toString(),
        craftType: craftTypeValue,
        dateStarted: dateStartedController.text.isEmpty
            ? DateTime.now()
            : DateTime.parse(dateStartedController.text),
        dateCompleted: dateCompletedController.text.isEmpty
            ? DateTime.now()
            : DateTime.parse(dateCompletedController.text),
        status: selectedValue,
        description: descriptionController.text,
        depositMade: depositMade == true ? depositValue = 1 : depositValue = 0,
        taskType: 'commission');
    await TaskController.updateTask(commission);
  }

  @override
  Widget build(BuildContext context) {
    Widget picture = GestureDetector(
      onTap: _pickAPicture,
      child: Image.memory(
        base64Decode(widget.model.image),
        fit: BoxFit.cover,
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.3,
      ),
    );

    if (_selectedPictureImage != null) {
      picture = GestureDetector(
        onTap: _pickAPicture,
        child: Image.file(
          _selectedPictureImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.3,
        ),
        //
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Order'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: TextFormField(
                    controller: orderNameController,
                    keyboardType: TextInputType.text,
                    showCursor: true,
                    decoration: const InputDecoration(
                      labelText: 'What is it?',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: double.infinity,
                    child: picture,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton(
                          onPressed: () async {
                            Contact? contact =
                                await _contactPicker.selectContact();

                            setState(() {
                              _contact = contact;
                            });
                          },
                          child: const Text('Customer Contact'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Text(
                            _contact == null
                                ? widget.model.customer
                                : _contact.toString(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 12.0),
                //   child: DropdownButtonFormField(
                //       //hint: const Text('Craft Type'),
                //       items: craftTypeList,
                //       onChanged: (String? value) {
                //         setState(() {
                //           craftTypeValue = value!;
                //         });
                //       }),
                // ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: DropdownButtonFormField(
                      hint: const Text("Status"),
                      value: selectedValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedValue = newValue!;

                          if (selectedValue == "Complete") {
                            dateCompletedController.clear();
                          }

                          if(selectedValue == "In Progress") {
                            dateStartedController.clear();
                          }
                        });
                      },
                      items: dropdownItems),
                ),
                Container(
                    child: selectedValue == "In Progress"
                        ? Stack(
                            children: [
                              DateTimePicker(
                                controller: dateStartedController,
                                initialValue: null,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                dateLabelText: 'When did you start it?',
                                onChanged: (val) => print(val),
                                validator: (val) {
                                  return null;
                                },
                                onSaved: (val) => print(val),
                              )
                            ],
                          )
                        : Container()),
                Container(
                    child: selectedValue == "Complete"
                        ? Column(
                            children: [
                              Stack(
                                children: [
                                  DateTimePicker(
                                    controller: dateStartedController,
                                    initialValue: null,
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                    dateLabelText: 'When did you start it?',
                                    onChanged: (val) => print(val),
                                    validator: (val) {
                                      return null;
                                    },
                                    onSaved: (val) => print(val),
                                  )
                                ],
                              ),
                              Stack(
                                children: [
                                  DateTimePicker(
                                    controller: dateCompletedController,
                                    initialValue: null,
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                    dateLabelText: 'When did you finish it?',
                                    onChanged: (val) => print(val),
                                    validator: (val) {
                                      return null;
                                    },
                                    onSaved: (val) => print(val),
                                  )
                                ],
                              ),
                            ],
                          )
                        : Container()),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: TextFormField(
                    controller: descriptionController,
                    keyboardType: TextInputType.text,
                    showCursor: true,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                    ),
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(top: 12),
                  child: Row(
                    children: [
                      Checkbox(
                        value: depositMade,
                        onChanged: (value) {
                          setState(() {
                            depositMade = !depositMade;
                          });
                        },
                      ),
                      const Text("Did they make a deposit?")
                    ],
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        String scaffoldText = orderNameController.text;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Saving edit for $scaffoldText'),
                          ),
                        );

                        await _updateItem();

                        if (!mounted) return;
                        Navigator.pop(context);
                        Navigator.pop(context);
                        //Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CommissionsPage()));
                      },
                      child: const Text('Save Edit'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

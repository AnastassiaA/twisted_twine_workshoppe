import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:image_picker/image_picker.dart';

import '../../Controllers/craft_type_controller.dart';
import '../../Controllers/task_controller.dart';
import '../../Models/Models/craft_type_model.dart';
import '../../Models/Models/task_model.dart';
import 'package:date_time_picker/date_time_picker.dart';

import '../Views/commissions_page.dart';

class AddCommissionForm extends StatefulWidget {
  const AddCommissionForm({super.key});

  @override
  State<AddCommissionForm> createState() => _AddCommissionFormState();
}

class _AddCommissionFormState extends State<AddCommissionForm> {
  final _formKey = GlobalKey<FormState>();

  final commissionNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateStartedController = TextEditingController();
  final dateCompletedController = TextEditingController();

  final FlutterContactPicker _contactPicker = FlutterContactPicker();

  Contact? _contact;
  String craftTypeValue = '';
  
  String selectedValue = "Status";
  int depositValue = 0;
  bool depositMade = false;
  String taskType = 'commission';

  List<DropdownMenuItem<String>> craftTypeList = [];

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

    if (pickedImage == null) {
      //maybe set something that picks the default image later
      //_selectedPictureImage = File("images/default_image.jpg");
    }
    setState(() {
      _selectedPictureImage = File(pickedImage!.path);
    });
    List<int> convertImage = await pickedImage!.readAsBytes();
    base64Image = base64Encode(convertImage);
  }

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
  }

  DropdownMenuItem<String> getDropDown(String item) {
    return DropdownMenuItem(value: item, child: Text(item));
  }

  @override
  void dispose() {
    super.dispose();
    commissionNameController.dispose();
    descriptionController.dispose();
    dateStartedController.dispose();
    dateCompletedController.dispose();
  }

  Future<void> _addcommission() async {
    TaskModel commission = TaskModel(
      taskName: commissionNameController.text,
      customer: _contact.toString(),
      craftType: craftTypeValue,
      status: selectedValue,
      dateStarted: dateStartedController.text.isEmpty
          ? DateTime.now()
          : DateTime.parse(dateStartedController.text),
      dateCompleted: dateCompletedController.text.isEmpty
          ? DateTime.now()
          : DateTime.parse(dateCompletedController.text),
      description: descriptionController.text,
      image: base64Image,
      depositMade: depositValue,
      taskType: taskType,
    );

    await TaskController.createTask(commission);
  }

  late String id;

  @override
  Widget build(BuildContext context) {
    Widget picture = TextButton.icon(
        onPressed: () {
          _pickAPicture();
        },
        icon: const Icon(Icons.image_aspect_ratio_rounded),
        label: const Text('Pick a picture'));

    if (_selectedPictureImage != null) {
      picture = GestureDetector(
        onTap: _pickAPicture,
        child: Image.file(
          _selectedPictureImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.3,
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Commissions'),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextFormField(
                      controller: commissionNameController,
                      keyboardType: TextInputType.text,
                      showCursor: true,
                      decoration: const InputDecoration(
                        labelText: 'What\'s the request?',
                      ),
                    ),
                  ),
                  //Image picker
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
                                  ? 'No contact selected'
                                  : _contact.toString(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  //CRAFT TYPE DROPDOWN MENU
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: DropdownButtonFormField(
                        hint: const Text('Craft Type'),
                        items: craftTypeList,
                        onChanged: (String? value) {
                          setState(() {
                            craftTypeValue = value!;
                          });
                        }),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: DropdownButtonFormField(
                        hint: const Text("Status"),
                        value: selectedValue,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValue = newValue!;
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

                              depositMade == true
                                  ? depositValue = 1
                                  : depositValue = 0;
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
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Saving commission')));

                            _addcommission();

                            //TODO: add a variable String taskType = 'commission';
                            if (!mounted) return;
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const CommissionsPage()));
                          },
                          child: const Text("add commission"),
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../Controllers/craft_type_controller.dart';
import '../../Controllers/task_controller.dart';
import '../../Models/Models/craft_type_model.dart';
import '../../Models/Models/task_model.dart';
import '../Views/projects_page.dart';

class EditProject extends StatefulWidget {
  final TaskModel model;
  const EditProject(this.model, {super.key});

  @override
  State<EditProject> createState() => _EditProjectState();
}

class _EditProjectState extends State<EditProject> {
  final _formKey = GlobalKey<FormState>();

  final projectNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateStartedController = TextEditingController();
  final dateCompletedController = TextEditingController();

  String craftTypeValue = '';

  String selectedValue = "Status";

  String taskType = 'project';

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

  List<DropdownMenuItem<String>> craftTypeList = [];

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

    setState(() {
      projectNameController.text = widget.model.taskName;
      descriptionController.text = widget.model.description;
      dateStartedController.text = widget.model.dateStarted.toString();
      dateCompletedController.text = widget.model.dateCompleted.toString();
      base64Image = widget.model.image;
    });
  }

  DropdownMenuItem<String> getDropDown(String item) {
    return DropdownMenuItem(value: item, child: Text(item));
  }

  @override
  void dispose() {
    super.dispose();
    projectNameController.dispose();
    descriptionController.dispose();
    dateStartedController.dispose();
    dateCompletedController.dispose();
  }

  Future<void> _editProject() async {
    TaskModel project = TaskModel(
      taskNumber: widget.model.taskNumber,
      taskName: projectNameController.text,
      customer: '',
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
      depositMade: null,
      taskType: taskType,
    );

    await TaskController.updateTask(project);
  }
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
          title: const Text('Edit Project'),
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
                      controller: projectNameController,
                      keyboardType: TextInputType.text,
                      showCursor: true,
                      decoration: const InputDecoration(
                        labelText: 'Project Name',
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

                  Center(
                    child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Saving Project')));

                            _editProject();

                            if (!mounted) return;
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ProjectsPage()));
                          },
                          child: const Text("SAVE EDIT"),
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

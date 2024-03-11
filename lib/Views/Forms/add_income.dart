import 'dart:convert';
import 'dart:io';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twisted_twine_workshopppe/Controllers/income_controller.dart';
import 'package:twisted_twine_workshopppe/Models/Models/income_model.dart';

import '../../Controllers/task_controller.dart';
import '../../Models/Models/task_model.dart';

class AddIncomeForm extends StatefulWidget {
  const AddIncomeForm({super.key});

  @override
  AddIncomeFormState createState() => AddIncomeFormState();
}

class AddIncomeFormState extends State<AddIncomeForm> {
  final _formKey = GlobalKey<FormState>();

  final descriptionController = TextEditingController();
  final dateController = TextEditingController();
  final amountController = TextEditingController();
  final disbursedFromController = TextEditingController();

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "Income Type", child: Text("Income Type")),
      const DropdownMenuItem(value: "Transfer In", child: Text("Transfer In")),
      const DropdownMenuItem(value: "Deposit", child: Text("Deposit")),
      const DropdownMenuItem(
          value: "Commission Payment", child: Text("Commission Payment")),
    ];

    return menuItems;
  }

  @override
  void dispose() {
    super.dispose();
    descriptionController.dispose();
    dateController.dispose();

    amountController.dispose();
    disbursedFromController.dispose();
  }

  String selectedValue = "Income Type";

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

  List<DropdownMenuItem<String>> commissionList = [];
  String commName = '';

  @override
  void initState() {
    super.initState();
    TaskController.getAllTasks().then((value) {
      value.map((e) {
        return getDropDown(TaskModel.fromMap(e).taskName);
      }).forEach((element) {
        commissionList.add(element);
      });
      setState(() {});
    });
  }

  DropdownMenuItem<String> getDropDown(String item) {
    return DropdownMenuItem(value: item, child: Text(item));
  }

  Future<void> _addIncome() async {
    IncomeModel income = IncomeModel(
        incomeDescription: descriptionController.text,
        date: DateTime.parse(dateController.text),
        incomeType: selectedValue,
        amount: double.parse(amountController.text),
        taskName: commName,
        disbursedFrom: disbursedFromController.text,
        receiptImage: base64Image);

    await IncomeController.createIncome(income);
  }

  @override
  Widget build(BuildContext context) {
    Widget picture = TextButton.icon(
        onPressed: () {
          _pickAPicture();
        },
        icon: const Icon(Icons.image_aspect_ratio_rounded),
        label: const Text('Add Receipt'));

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
          title: const Text('Add Income'),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    children: [
                      DateTimePicker(
                        controller: dateController,
                        initialValue: null,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        dateLabelText: 'Date',
                        onChanged: (val) => print(val),
                        validator: (val) {
                          print(val);
                          return null;
                        },
                        onSaved: (val) => print(val),
                      )
                    ],
                  ),

                  DropdownButtonFormField(
                      value: selectedValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedValue = newValue!;
                        });
                      },
                      items: dropdownItems),

                  Container(
                    child: selectedValue == "Deposit"
                        ? Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: DropdownButtonFormField(
                                hint: const Text('Commissions List'),
                                items: commissionList,
                                onChanged: (String? value) {
                                  setState(() {
                                    commName = value!;
                                  });
                                }),
                          )
                        : Container(),
                  ),

                  TextFormField(
                    controller: disbursedFromController,
                    keyboardType: TextInputType.text,
                    showCursor: true,
                    decoration: const InputDecoration(
                      labelText: 'Disbursed From:',
                    ),
                  ),
                  TextFormField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    showCursor: true,
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                    ),
                  ),
                  TextFormField(
                    readOnly: selectedValue == "Deposit" ? true : false,
                    controller: descriptionController,
                    keyboardType: TextInputType.text,
                    showCursor: true,
                    decoration: const InputDecoration(
                      labelText: 'Income Description',
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
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ElevatedButton(
                        //style: ,
                        onPressed:
                            //TODO: Refresh list tile on pressed
                            () async {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  duration: Duration(seconds: 1),
                                  content: Text('Saving Income')));

                          _addIncome();
                          if (!mounted) return;
                          Navigator.pop(context);
                        },
                        child: const Text("add Income"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

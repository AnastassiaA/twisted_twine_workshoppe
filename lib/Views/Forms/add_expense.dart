import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twisted_twine_workshopppe/Controllers/expense_controller.dart';
import 'dart:convert';
import 'dart:io';

import 'package:twisted_twine_workshopppe/Controllers/task_controller.dart';
import 'package:twisted_twine_workshopppe/Models/Models/expense_model.dart';
import 'package:twisted_twine_workshopppe/Models/Models/task_model.dart';

class AddExpenseForm extends StatefulWidget {
  const AddExpenseForm({Key? key}) : super(key: key);

  @override
  AddExpenseFormState createState() => AddExpenseFormState();
}

class AddExpenseFormState extends State<AddExpenseForm> {
  final _formKey = GlobalKey<FormState>();

  final expenseNameController = TextEditingController();
  final dateController = TextEditingController();
  final amountController = TextEditingController();
  final paidToController = TextEditingController();

  bool isThisACommissionExpense = false;

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(
          value: "Expense Type", child: Text("Expense Type")),
      const DropdownMenuItem(
          value: "Transfer Out", child: Text("Transfer Out")),
      const DropdownMenuItem(value: "Materials", child: Text("Materials")),
      const DropdownMenuItem(value: "Tools", child: Text("Tools")),
      const DropdownMenuItem(
          value: "Transportation", child: Text("Transportation")),
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

  @override
  void dispose() {
    super.dispose();
    expenseNameController.dispose();
    dateController.dispose();
    amountController.dispose();
    paidToController.dispose();
  }

  String selectedValue = "Expense Type";

  Future<void> _addExpense() async {
    ExpenseModel expense = ExpenseModel(
        expenseDescription: expenseNameController.text,
        date: DateTime.parse(dateController.text),
        expenseType: selectedValue,
        amount: double.parse(amountController.text),
        paidTo: paidToController.text,
        receiptImage: base64Image,
        taskName: commName);

    await ExpenseController.createExpense(expense);
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Expense'),
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
                TextFormField(
                  controller: paidToController,
                  keyboardType: TextInputType.text,
                  showCursor: true,
                  decoration: const InputDecoration(
                    labelText: 'Paid To',
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
                  controller: expenseNameController,
                  keyboardType: TextInputType.text,
                  showCursor: true,
                  decoration: const InputDecoration(
                    labelText: 'Expense Description',
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  child: Row(
                    children: [
                      Checkbox(
                        value: isThisACommissionExpense,
                        onChanged: (value) {
                          setState(() {
                            isThisACommissionExpense =
                                !isThisACommissionExpense;
                          });
                        },
                      ),
                      const Text("Is this for a commission?")
                    ],
                  ),
                ),
                Container(
                  child: isThisACommissionExpense == true
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
                      onPressed: () async {
                        _addExpense();
                        if (!mounted) return;
                        Navigator.of(context).pop();
                      },
                      child: const Text("add expense"),
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

 import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../Controllers/yarn_controller.dart';
import '../../Models/Models/yarn_model.dart';
import '../Views/yarn_page.dart';


class AddYarn extends StatefulWidget {
  const AddYarn({super.key});

  @override
  AddYarnState createState() => AddYarnState();
}

class AddYarnState extends State<AddYarn> {
  final _formKey = GlobalKey<FormState>();

  String dropdownValue = 'None';

  final yarnColorController = TextEditingController();
  final brandController = TextEditingController();
  final materialController = TextEditingController();
  final sizeController = TextEditingController();
  final availableWeightController = TextEditingController();
  final priceController = TextEditingController();
  final weightController = TextEditingController();
  final hooknNeedleController = TextEditingController();
  final costController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    yarnColorController.dispose();
    brandController.dispose();
    materialController.dispose();
    sizeController.dispose();
    availableWeightController.dispose();
    priceController.dispose();
    weightController.dispose();
    hooknNeedleController.dispose();
    costController.dispose();
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

  Future<void> _addYarn() async {
    YarnModel yarn = YarnModel(
        yarnColor: yarnColorController.text,
        image: base64Image,
        brand: brandController.text,
        material: materialController.text,
        size: sizeController.text,
        availableWeight: double.parse(availableWeightController.text),
        pricePerGram: double.parse(priceController.text),
        reccHookNeedle: hooknNeedleController.text,
        cost: double.parse(costController.text));

        await YarnController.createYarn(yarn);
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Yarn'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: yarnColorController,
                  keyboardType: TextInputType.text,
                  showCursor: true,
                  decoration: const InputDecoration(
                    labelText: 'Yarn Color',
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
                TextFormField(
                  controller: brandController,
                  keyboardType: TextInputType.text,
                  showCursor: true,
                  decoration: const InputDecoration(
                    labelText: 'Brand',
                  ),
                ),
                TextFormField(
                  controller: materialController,
                  keyboardType: TextInputType.text,
                  showCursor: true,
                  decoration: const InputDecoration(
                    labelText: 'Material',
                  ),
                ),
                TextFormField(
                  controller: sizeController,
                  keyboardType: TextInputType.text,
                  showCursor: true,
                  decoration: const InputDecoration(
                    labelText: 'Size',
                  ),
                ),
                TextFormField(
                  controller: availableWeightController,
                  keyboardType: TextInputType.number,
                  showCursor: true,
                  decoration: const InputDecoration(
                    labelText: 'Available Amount (g)',
                  ),
                ),
                TextFormField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  showCursor: true,
                  decoration: const InputDecoration(
                    labelText: 'Price per gram',
                  ),
                ),
                TextFormField(
                  controller: hooknNeedleController,
                  keyboardType: TextInputType.text,
                  showCursor: true,
                  decoration: const InputDecoration(
                    labelText: 'Recc Hook/Needle',
                  ),
                ),
                TextFormField(
                  controller: costController,
                  keyboardType: TextInputType.number,
                  showCursor: true,
                  decoration: const InputDecoration(
                    labelText: 'Cost',
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ElevatedButton(
                      //style: ,
                      onPressed: () async {
                        ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Saving Yarn')));

                                  _addYarn();
                                  if (!mounted) return;
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const YarnPage()));
                      },
                      child: const Text("Add Yarn"),
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

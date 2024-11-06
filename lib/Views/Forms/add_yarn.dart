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

  //String dropdownValue = 'None';
  String sizeValue = 'Yarn Size';
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "Yarn Size", child: Text("Yarn Size")),
      const DropdownMenuItem(value: "Lace - 0", child: Text("Lace - 0")),
      const DropdownMenuItem(
          value: "Super Fine, Sock, Fingering - 1",
          child: Text("Super Fine, Sock, Fingering - 1")),
      const DropdownMenuItem(
          value: "Fine Weight, Sport, Baby - 2",
          child: Text("Fine Weight, Sport, Baby - 2")),
      const DropdownMenuItem(
          value: "Light, Double Knit (DK) - 3",
          child: Text("Light, Double Knit (DK) - 3")),
      const DropdownMenuItem(
          value: "Medium, Worsted, Aran - 4",
          child: Text("Medium, Worsted, Aran - 4")),
      const DropdownMenuItem(value: "Bulky - 5", child: Text("Bulky - 5")),
      const DropdownMenuItem(
          value: "Super Bulky - 6", child: Text("Super Bulky - 6")),
      const DropdownMenuItem(value: "Jumbo - 7", child: Text("Jumbo - 7")),
    ];

    return menuItems;
  }

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
                
                Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: DropdownButtonFormField(
                        hint: const Text("Yarn Size"),
                        value: sizeValue,
                        onChanged: (String? newValue) {
                          setState(() {
                            sizeValue = newValue!;
                          });
                        },
                        items: dropdownItems),
                  ),
                // yarn size/weight
                //Lace - 0
                //Super Fine, Sock, Fingering - 1
                //Fine Weight, Sport, Baby - 2
                //Light, Double Knit (DK) - 3
                //Medium, Worsted, Aran - 4
                //Bulky - 5
                //Super Bulky - 6
                //Jumbo - 7

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
                            const SnackBar(content: Text('Saving Yarn')));

                        _addYarn();
                        if (!mounted) return;
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const YarnPage()));
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

import 'dart:convert';
import 'dart:io';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twisted_twine_workshopppe/Controllers/product_catalogue_controller.dart';
import 'package:twisted_twine_workshopppe/Models/Models/product_catalogue_model.dart';
import 'package:twisted_twine_workshopppe/Views/Views/product_catalogue_page.dart';

class AddProductToCatalogue extends StatefulWidget {
  const AddProductToCatalogue({super.key});

  @override
  State<AddProductToCatalogue> createState() => _AddProductToCatalogueState();
}

class _AddProductToCatalogueState extends State<AddProductToCatalogue> {
  File? _selectedPictureImage;
  String base64Image = "";
  final productNameController = TextEditingController();
  final priceController = TextEditingController();
  final durationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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

  Future<void> _addProduct() async {
    ProductCatalogueModel product = ProductCatalogueModel(
        image: base64Image,
        productName: productNameController.text,
        price: double.parse(priceController.text),
        //duration: durationController
        );

    await ProductCatalogueController.createProduct(product);
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
        title: const Text('Add Product'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  controller: productNameController,
                  keyboardType: TextInputType.text,
                  showCursor: true,
                  decoration: const InputDecoration(labelText: 'Product Name'),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 200.0),
                  child: TextFormField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    showCursor: true,
                    decoration: const InputDecoration(
                      labelText: 'Price',
                    ),
                  ),
                ),
                DateTimePicker(
                  timePickerEntryModeInput: true,
                  timeLabelText: 'Dont enter snythinng - fix later',
                  type: DateTimePickerType.time,
                  controller: durationController,
                  initialValue: null,
                  icon: const Icon(Icons.calendar_month_rounded),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  onChanged: (val) => print(val),
                  validator: (val) {
                    return null;
                  },
                ),
                //MyTimePicker(),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ElevatedButton(
                      //style: ,
                      onPressed: () async {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Saving Product')));

                        _addProduct();
                        if (!mounted) return;
                        Navigator.pop(context);
                        //Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ProductCataloguePage()));
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

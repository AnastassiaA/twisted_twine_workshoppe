import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twisted_twine_workshopppe/Controllers/other_fibres_controllers.dart';
import 'package:twisted_twine_workshopppe/Models/Models/other_fibres_model.dart';

class OtherFibresPage extends StatefulWidget {
  const OtherFibresPage({super.key});

  @override
  State<OtherFibresPage> createState() => _OtherFibresPageState();
}

class _OtherFibresPageState extends State<OtherFibresPage> {
  List<OtherFibresModel> fibresList = [];
  bool isLoading = true;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  getAllOtherFibres() async {
    final fibresData = await OtherFibresController.getAllOtherFibres();

    setState(() {
      fibresList = fibresData.map((e) => OtherFibresModel.fromMap(e)).toList();
      isLoading = false;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getAllOtherFibres();
    super.initState();
  }

  Future refresh() async {
    fibresList.clear();
    getAllOtherFibres();
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

  void deleteOtherFibres(
      {required OtherFibresModel fibre, required BuildContext context}) async {
    OtherFibresController.deleteOtherFibres(fibre.fibreId!).then((value) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Deleted')));
    }).catchError((e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    });
    getAllOtherFibres();
  }

  void form(int? id) async {
    if (id != null) {
      final thisFibreType =
          fibresList.firstWhere((element) => element.fibreId == id);
      nameController.text = thisFibreType.fibreName;
      base64Image = thisFibreType.image;
      descriptionController.text = thisFibreType.description;
      amountController.text = thisFibreType.amount.toString();
    }

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          Widget picture = GestureDetector(
            onTap: _pickAPicture,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.amberAccent,
                  radius: MediaQuery.of(context).size.width * 0.1,
                ),
                const Icon(Icons.camera_alt_rounded),
              ],
            ),
          );

          if (_selectedPictureImage != null) {
            picture = GestureDetector(
              onTap: _pickAPicture,
              child: CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.1,
                  //backgroundImage:
                  //TODO: add asset image later
                  foregroundImage: Image.file(_selectedPictureImage!).image
                  //Image.memory(base64Decode(base64Image)).image,
                  ),
            );
          }
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Center(
                      child: Text(
                        'Other Fibres',
                      ),
                    ),
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(labelText: 'Title'),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Container(
                            child: picture,
                          ),
                        ),
                      ],
                    ),
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Amount'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        child: Text(id == null ? 'Add Fibre' : 'Update Fibre'),
                        onPressed: () async {
                          if (id == null) {
                            await OtherFibresController.createOtherFibres(
                                OtherFibresModel(
                                    fibreName: nameController.text,
                                    image: base64Image,
                                    amount: double.parse(amountController.text),
                                    description: descriptionController.text));
                          }

                          if (id != null) {
                            await OtherFibresController.updateOtherFibres(
                                OtherFibresModel(
                                    fibreId: id,
                                    fibreName: nameController.text,
                                    image: base64Image,
                                    amount: double.parse(amountController.text),
                                    description: descriptionController.text));
                          }
                          nameController.text = '';
                          descriptionController.text = '';
                          amountController.text = '';
                          _selectedPictureImage = null;
                          base64Image = '';

                          if (!mounted) return;
                          Navigator.pop(
                            context,
                          );
                          refresh();
                        })
                  ]),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Other Fibres"),
        actions: const [
          IconButton(onPressed: null, icon: Icon(Icons.sort)),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: fibresList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: GestureDetector(
                    onDoubleTap: () {
                      //edit
                    },
                    onLongPress: () {
                      //delete
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            Image.memory(base64Decode(fibresList[index].image))
                                .image,
                      ),
                      title: Text(fibresList[index].fibreName),
                      subtitle: Text(fibresList[index].description),
                      trailing: Text('${fibresList[index].amount} g'),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          form(null);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

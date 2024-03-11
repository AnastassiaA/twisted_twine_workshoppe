import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twisted_twine_workshopppe/Controllers/fabric_controller.dart';
import 'package:twisted_twine_workshopppe/Models/Models/fabrics_model.dart';

class FabricsPage extends StatefulWidget {
  const FabricsPage({super.key});

  @override
  State<FabricsPage> createState() => _FabricsPageState();
}

class _FabricsPageState extends State<FabricsPage> {
  List<FabricsModel> fabricsList = [];
  bool isLoading = true;
  final TextEditingController fabricNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  getAllFabrics() async {
    final fabricData = await FabricController.getAllFabrics();

    setState(() {
      fabricsList = fabricData.map((e) => FabricsModel.fromMap(e)).toList();
      isLoading = false;
    });
  }

  @override
  void dispose() {
    fabricNameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getAllFabrics();
    super.initState();
  }

  Future refresh() async {
    fabricsList.clear();
    getAllFabrics();
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

  void deleteFabrics(
      {required FabricsModel fabric, required BuildContext context}) async {
    FabricController.deleteFabric(fabric.fabricId!).then((value) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Deleted')));
    }).catchError((e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    });
    getAllFabrics();
  }

  void form(int? id) async {
    if (id != null) {
      final thisFabricType =
          fabricsList.firstWhere((element) => element.fabricId == id);
      fabricNameController.text = thisFabricType.fabricName;
      base64Image = thisFabricType.image;
      descriptionController.text = thisFabricType.description;
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
                        'Fabric',
                      ),
                    ),
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        TextField(
                          controller: fabricNameController,
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
                        child:
                            Text(id == null ? 'Add Fabric' : 'Update Fabric'),
                        onPressed: () async {
                          if (id == null) {
                            await FabricController.createFabrics(FabricsModel(
                                fabricName: fabricNameController.text,
                                image: base64Image,
                                description: descriptionController.text));
                          }
                          if (id != null) {
                            await FabricController.updateFabrics(FabricsModel(
                                fabricId: id,
                                fabricName: fabricNameController.text,
                                image: base64Image,
                                description: descriptionController.text));
                          }
                          fabricNameController.text = '';
                          descriptionController.text = '';
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
        title: const Text("Fabrics"),
        actions: const [
          IconButton(onPressed: null, icon: Icon(Icons.sort)),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GridView.custom(
              padding: const EdgeInsets.only(
                bottom: 16.0,
                left: 16.0,
                right: 16.0,
              ),
              gridDelegate: SliverQuiltedGridDelegate(
                  crossAxisCount: 4,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  repeatPattern: QuiltedGridRepeatPattern.inverted,
                  pattern: const [
                    QuiltedGridTile(3, 2),
                    QuiltedGridTile(2, 2),
                  ]),
              childrenDelegate: SliverChildBuilderDelegate((context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: GestureDetector(
                      onDoubleTap: () {
                        form(fabricsList[index].fabricId);
                      },
                      onLongPress: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Delete '
                                    '"'
                                    '${fabricsList[index].fabricName}'
                                    '"'),
                                content: const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Are you sure?'),
                                  ],
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(
                                        context,
                                      );
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      deleteFabrics(
                                          fabric: fabricsList[index],
                                          context: context);

                                      Navigator.pop(
                                        context,
                                      );
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              );
                            });
                      },
                      child: Column(
                        children: [
                          Expanded(
                            child: Image.memory(
                              base64Decode(fabricsList[index].image),
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width * 0.6,
                              height: MediaQuery.of(context).size.height * 0.2,
                            ),
                          ),
                          ListTile(
                            title: Text(fabricsList[index].fabricName),
                            subtitle: Text(fabricsList[index].description),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }, childCount: fabricsList.length),
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

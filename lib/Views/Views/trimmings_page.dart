import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twisted_twine_workshopppe/Controllers/trimmings_controller.dart';

import '../../Models/Models/trimmings_model.dart';

class TrimmingsPage extends StatefulWidget {
  const TrimmingsPage({super.key});

  @override
  State<TrimmingsPage> createState() => _TrimmingsPageState();
}

class _TrimmingsPageState extends State<TrimmingsPage> {
  List<TrimmingsModel> trimmingsList = [];
  bool isLoading = true;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

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

  getAllTrimmings() async {
    final trimmingsData = await TrimmingsController.getAllTrimmings();

    setState(() {
      trimmingsList =
          trimmingsData.map((e) => TrimmingsModel.fromMap(e)).toList();
      isLoading = false;
    });
  }

  Future refresh() async {
    trimmingsList.clear();
    getAllTrimmings();
  }

  void deleteTrimmings(
      {required TrimmingsModel trimmings,
      required BuildContext context}) async {
    TrimmingsController.deleteTrimmings(trimmings.trimmingsId!).then((value) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Deleted')));
    }).catchError((e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    });
    getAllTrimmings();
  }

  void form(int? id) async {
    if (id != null) {
      final thisTrimmingsType =
          trimmingsList.firstWhere((element) => element.trimmingsId == id);
      nameController.text = thisTrimmingsType.trimmingsName;
      amountController.text = thisTrimmingsType.amount.toString();
      base64Image = thisTrimmingsType.image;
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
                        'Trimmings',
                      ),
                    ),
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(labelText: 'Name'),
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
                      decoration: const InputDecoration(labelText: 'Amount'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        child: Text(
                            id == null ? 'Add Trimmings' : 'Update Trimmings'),
                        onPressed: () async {
                          if (id == null) {
                            await TrimmingsController.createTrimmings(
                                TrimmingsModel(
                                    image: base64Image,
                                    trimmingsName: nameController.text,
                                    amount: int.parse(amountController.text)));
                          }

                          if (id != null) {
                            await TrimmingsController.updateTrimmings(
                                TrimmingsModel(
                                    trimmingsId: id,
                                    image: base64Image,
                                    trimmingsName: nameController.text,
                                    amount: int.parse(amountController.text)));
                          }
                          nameController.text = '';
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
  void initState() {
    getAllTrimmings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trimmings"),
        actions: const [
          Tooltip(
            message: 'Long press a commission to delete',
            child: Icon(
              Icons.help,

            ),
            
          ),
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
                  //QuiltedGridTile(2, 2),
                ],
              ),
              childrenDelegate: SliverChildBuilderDelegate((context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: GestureDetector(
                      onDoubleTap: () {
                        form(trimmingsList[index].trimmingsId);
                      },
                      onLongPress: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Delete '
                                    '"'
                                    '${trimmingsList[index].trimmingsName}'
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
                                      deleteTrimmings(
                                          trimmings: trimmingsList[index],
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
                              base64Decode(trimmingsList[index].image),
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width * 0.6,
                              height: MediaQuery.of(context).size.height * 0.3,
                            ),
                          ),
                          ListTile(
                            title: Text(trimmingsList[index].trimmingsName),
                            trailing: Text("${trimmingsList[index].amount}"),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }, childCount: trimmingsList.length)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          form(null);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

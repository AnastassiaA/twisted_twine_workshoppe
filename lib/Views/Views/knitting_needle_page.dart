import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';

import '../../Controllers/knitting_needle_controller.dart';
import '../../Controllers/knitting_needle_type_controller.dart';
import '../../Models/Models/knitting_needle_model.dart';
import '../../Models/Models/knitting_needle_type_model.dart';

class KnittingNeedlePage extends StatefulWidget {
  const KnittingNeedlePage({super.key});

  @override
  State<KnittingNeedlePage> createState() => _KnittingNeedlePageState();
}

class _KnittingNeedlePageState extends State<KnittingNeedlePage> {
  List<KnittingNeedleModel> needleList = [];
  bool isLoading = true;

  final TextEditingController sizeController = TextEditingController();
  //final TextEditingController typeController = TextEditingController();

  List<DropdownMenuItem<String>> needleTypeList = [];

  String needleTypevalue = '';

  getAllKnittingNeedles() async {
    final needledata = await KnittingNeedleController.getAllKnittingNeedles();

    setState(() {
      needleList =
          needledata.map((e) => KnittingNeedleModel.fromMap(e)).toList();
      isLoading = false;
    });
  }

  @override
  void initState() {
    getAllKnittingNeedles();
    KnittingNeedleTypeController.getAllNeedleTypes().then((value) {
      value.map((e) {
        return getDropDown(KnittingNeedleTypeModel.fromMap(e).needleTypeName);
      }).forEach((element) {
        needleTypeList.add(element);
      });
      setState(() {});
    });
    super.initState();
  }

  DropdownMenuItem<String> getDropDown(String item) {
    return DropdownMenuItem(value: item, child: Text(item));
  }

  Future refresh() async {
    needleList.clear();
    getAllKnittingNeedles();
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

  void form(int? id) async {
    if (id != null) {
      final thisNeedleType =
          needleList.firstWhere((element) => element.knittingNeedleId == id);
      sizeController.text = thisNeedleType.knittingNeedleSize;
      needleTypevalue = thisNeedleType.knittingNeedleType;
      base64Image = thisNeedleType.image;
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
                        'Knitting Needle',
                      ),
                    ),
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        TextField(
                          controller: sizeController,
                          decoration: const InputDecoration(
                              labelText: 'Knitting Needle Size'),
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
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: DropdownButtonFormField(
                          hint: const Text('Type'),
                          items: needleTypeList,
                          onChanged: (String? value) {
                            setState(() {
                              needleTypevalue = value!;
                            });
                          }),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        child: Text(id == null
                            ? 'Add Knitting Needle'
                            : 'Update Knitting Needle'),
                        onPressed: () async {
                          if (id == null) {
                            await KnittingNeedleController.createKnittingNeedle(
                              KnittingNeedleModel(
                                  knittingNeedleSize: sizeController.text,
                                  image: base64Image,
                                  knittingNeedleType: needleTypevalue),
                            );
                          }

                          if (id != null) {
                            await KnittingNeedleController.updateKnittingNeedle(
                              KnittingNeedleModel(
                                  knittingNeedleId: id,
                                  knittingNeedleSize: sizeController.text,
                                  image: base64Image,
                                  knittingNeedleType: needleTypevalue),
                            );
                          }
                          sizeController.text = '';
                          //typeController.text = '';
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

  void deleteYarn(
      {required KnittingNeedleModel needle,
      required BuildContext context}) async {
    KnittingNeedleController.deleteKnittingNeedle(needle.knittingNeedleId!)
        .then((value) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Deleted')));
    }).catchError((e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    });
    getAllKnittingNeedles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Knitting Needles"),
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
                  //QuiltedGridTile(2, 2),
                ],
              ),
              childrenDelegate: SliverChildBuilderDelegate((context, index) {
                return Card(
                  child: GestureDetector(
                    onDoubleTap: () {
                      form(needleList[index].knittingNeedleId);
                    },
                    onLongPress: () {},
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.memory(
                            base64Decode(needleList[index].image),
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width * 0.6,
                            height: MediaQuery.of(context).size.height * 0.3,
                          ),
                        ),
                        ListTile(
                          title: Text(needleList[index].knittingNeedleSize),
                          subtitle: Text(needleList[index].knittingNeedleType),
                        )
                      ],
                    ),
                  ),
                );
              }, childCount: needleList.length),
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

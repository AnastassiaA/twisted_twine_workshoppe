import 'dart:convert';
import 'dart:io';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twisted_twine_workshopppe/Controllers/crochet_hook_controller.dart';
import 'package:twisted_twine_workshopppe/Models/Models/crochet_hook_model.dart';

class CrochetHookPage extends StatefulWidget {
  const CrochetHookPage({super.key});

  @override
  State<CrochetHookPage> createState() => _CrochetHookPageState();
}

class _CrochetHookPageState extends State<CrochetHookPage> {
  List<CrochetHookModel> hookList = [];
  bool isLoading = true;

  final TextEditingController sizeController = TextEditingController();

  String base64Image = '';

  getAllCrochetHooks() async {
    final hookdata = await CrochetHookController.getAllCrochetHooks();

    setState(() {
      hookList = hookdata.map((e) => CrochetHookModel.fromMap(e)).toList();
      isLoading = false;
    });
  }

  @override
  void initState() {
    getAllCrochetHooks();
    super.initState();
  }

  Future refresh() async {
    hookList.clear();
    getAllCrochetHooks();
  }

  File? _selectedPictureImage;

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
      final thisHookType =
          hookList.firstWhere((element) => element.crochetHookId == id);
      sizeController.text = thisHookType.crochetHookSize;
      base64Image = thisHookType.image;
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
                        'Crochet Hook',
                      ),
                    ),
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        TextField(
                          controller: sizeController,
                          decoration: const InputDecoration(
                              labelText: 'Crochet Hook Size'),
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
                    ElevatedButton(
                        child: Text(id == null
                            ? 'Add Crochet Hook'
                            : 'Update Crochet Hook'),
                        onPressed: () async {
                          if (id == null) {
                            await CrochetHookController.createCrochetHook(
                                CrochetHookModel(
                                    image: base64Image,
                                    crochetHookSize: sizeController.text));
                          }

                          if (id != null) {
                            await CrochetHookController.updateCrochetHook(
                                CrochetHookModel(
                                    crochetHookId: id,
                                    image: base64Image,
                                    crochetHookSize: sizeController.text));
                          }
                          sizeController.text = '';
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
      {required CrochetHookModel hook, required BuildContext context}) async {
    CrochetHookController.deleteCrochetHook(hook.crochetHookId!).then((value) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Deleted')));
    }).catchError((e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    });
    getAllCrochetHooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crochet Hooks"),
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
                return Column(
                  children: [
                    Expanded(
                      child: Image.memory(
                        base64Decode(hookList[index].image),
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: MediaQuery.of(context).size.height * 0.3,
                      ),
                    ),
                    ListTile(
                      title: Text(hookList[index].crochetHookSize),
                    )
                  ],
                );
              }, childCount: hookList.length),
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

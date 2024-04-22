import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twisted_twine_workshopppe/Controllers/tools_controller.dart';

import '../../Models/Models/tools_model.dart';

class ToolsPage extends StatefulWidget {
  const ToolsPage({super.key});

  @override
  State<ToolsPage> createState() => _ToolsPageState();
}

class _ToolsPageState extends State<ToolsPage> {
  List<ToolsModel> toolsList = [];
  bool isLoading = true;

  final TextEditingController nameController = TextEditingController();

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

  getAllTools() async {
    final toolsData = await ToolsController.getAllTools();

    setState(() {
      toolsList = toolsData.map((e) => ToolsModel.fromMap(e)).toList();
      isLoading = false;
    });
  }

  Future refresh() async {
    toolsList.clear();
    getAllTools();
  }

  void deleteTools(
      {required ToolsModel tool,
      required BuildContext context}) async {
    ToolsController.deleteTools(tool.toolsId!).then((value) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Deleted')));
    }).catchError((e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    });
    getAllTools();
  }

  void form(int? id) async {
    if (id != null) {
      final thisToolsType =
          toolsList.firstWhere((element) => element.toolsId == id);
      nameController.text = thisToolsType.toolName;
      base64Image = thisToolsType.image!;
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
                        'Tools',
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
                    
                    ElevatedButton(
                        child: Text(
                            id == null ? 'Add Tool' : 'Update Tool'),
                        onPressed: () async {
                          if (id == null) {
                            await ToolsController.createTools(
                              ToolsModel(
                                image: base64Image,
                                toolName: nameController.text,
                                ));
                            
                          }

                          if (id != null) {
                            await ToolsController.updateTools(
                              ToolsModel(
                                toolsId: id,
                                image: base64Image,
                                toolName: nameController.text,
                                ));
                            }
                          nameController.text = '';
                        
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
    getAllTools();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tools"),
        actions: const [
          Tooltip(
            message: 'Long press to delete' '\n\n' 'Double tap to edit',
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
                        form(toolsList[index].toolsId);
                      },
                      onLongPress: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Delete '
                                    '"'
                                    '${toolsList[index].toolName}'
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
                                      deleteTools(
                                          tool: toolsList[index],
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
                              base64Decode(toolsList[index].image!),
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width * 0.6,
                              height: MediaQuery.of(context).size.height * 0.3,
                            ),
                          ),
                          ListTile(
                            title: Text(toolsList[index].toolName),
                            
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }, childCount: toolsList.length)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          form(null);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
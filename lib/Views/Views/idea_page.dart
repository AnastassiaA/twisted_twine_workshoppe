import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twisted_twine_workshopppe/Controllers/idea_controller.dart';
import 'package:twisted_twine_workshopppe/Models/Models/idea_model.dart';

class IdeaPage extends StatefulWidget {
  const IdeaPage({super.key});

  @override
  State<IdeaPage> createState() => _IdeaPageState();
}

class _IdeaPageState extends State<IdeaPage> {
  List<IdeaModel> ideaList = [];
  bool isLoading = true;

  getIdeas() async {
    final ideaData = await IdeaController.getAllIdeas();

    setState(() {
      ideaList = ideaData.map((e) => IdeaModel.fromMap(e)).toList();
      isLoading = false;
    });
  }

  @override
  void initState() {
    getIdeas();
    super.initState();
  }

  Future refresh() async {
    ideaList.clear();
    getIdeas();
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

  void deleteIdea({required IdeaModel idea, required BuildContext context}) {
    IdeaController.deleteIdea(idea.recordId!).then((value) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${idea.ideaName} deleted')));
    }).catchError((e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    });
    refresh();
  }

  final ideaNameController = TextEditingController();
  final descriptionController = TextEditingController();

  void form(int? id) async {
    if (id != null) {
      final thisIdeaType =
          ideaList.firstWhere((element) => element.recordId == id);
      ideaNameController.text = thisIdeaType.ideaName;
      base64Image = thisIdeaType.image;
      descriptionController.text = thisIdeaType.description;
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
                        'Idea',
                      ),
                    ),
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        TextField(
                          controller: ideaNameController,
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
                        child: Text(id == null ? 'Add Idea' : 'Update Idea'),
                        onPressed: () async {
                          if (id == null) {
                            await IdeaController.createIdea(IdeaModel(
                                image: base64Image,
                                ideaName: ideaNameController.text,
                                description: descriptionController.text));
                          }
                          if (id != null) {
                            await IdeaController.updateIdea(IdeaModel(
                                recordId: id,
                                image: base64Image,
                                ideaName: ideaNameController.text,
                                description: descriptionController.text));
                          }
                          ideaNameController.text = '';
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
        title: const Text("Ideas"),
        actions: [
          const Tooltip(
            message: 'Long press a commission to delete',
            child: Icon(
              Icons.help,
            ),
          ),
          const IconButton(onPressed: null, icon: Icon(Icons.sort)),
          IconButton(
              onPressed: () {
                form(null);
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: ideaList.length,
              itemBuilder: ((context, index) {
                return Card(
                  shadowColor: const Color(0xffefdff9),
                  surfaceTintColor: const Color(0xffefdff9),
                  color: const Color(0xffefdff9),
                  child: GestureDetector(
                    onDoubleTap: () {
                      form(ideaList[index].recordId);
                    },
                    onLongPress: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Delete '
                                  '"'
                                  '${ideaList[index].ideaName}'
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
                                    deleteIdea(
                                        idea: ideaList[index],
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
                        Image.memory(
                          base64Decode(ideaList[index].image),
                          fit: BoxFit.scaleDown,
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: MediaQuery.of(context).size.height * 0.5,
                        ),
                        ListTile(
                          title: Text(
                            ideaList[index].ideaName,
                            style: const TextStyle(fontSize: 25),
                          ),
                          subtitle: Text(
                            ideaList[index].description,
                            style: const TextStyle(fontSize: 20),
                            softWrap: true,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
            ),
    );
  }
}

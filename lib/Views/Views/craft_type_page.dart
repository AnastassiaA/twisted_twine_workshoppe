import 'package:flutter/material.dart';

import '../../Controllers/craft_type_controller.dart';
import '../../Models/Models/craft_type_model.dart';

class CraftTypePage extends StatefulWidget {
  const CraftTypePage({super.key});

  @override
  State<CraftTypePage> createState() => _CraftTypePageState();
}

class _CraftTypePageState extends State<CraftTypePage> {
  final TextEditingController craftNameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    craftNameController.dispose();
  }

  List<CraftTypeModel> craftTypeList = [];
  bool isLoading = true;

  getAllTypes() async {
    final type = await CraftTypeController.getAllCraftTypes();

    setState(() {
      craftTypeList = type.map((e) => CraftTypeModel.fromMap(e)).toList();
      isLoading = false;
    });
  }

  @override
  void initState() {
    getAllTypes();
    super.initState();
  }

  Future refresh() async {
    craftTypeList.clear();
    getAllTypes();
  }

  void form(int? id) async {
    if (id != null) {
      final thisCraftType =
          craftTypeList.firstWhere((element) => element.craftTypeNumber == id);
      craftNameController.text = thisCraftType.craftTypeName;
    }

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (_) => Container(
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
                        'Craft Type',
                      ),
                    ),
                    TextField(
                      controller: craftNameController,
                      // decoration: const InputDecoration(hintText: 'Enter type'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        child: Text(id == null
                            ? 'Add Craft Type'
                            : 'Update Craft Type'),
                        onPressed: () async {
                          if (id == null) {
                            await CraftTypeController.createCraftType(
                              CraftTypeModel(
                                  craftTypeName: craftNameController.text),
                            );
                          }

                          if (id != null) {
                            await CraftTypeController.updateCraftType(
                              CraftTypeModel(
                                  craftTypeNumber: id,
                                  craftTypeName: craftNameController.text),
                            );
                          }
                          craftNameController.text = '';

                          if (!mounted) return;
                          Navigator.pop(
                            context,
                          );
                          refresh();
                        })
                  ]),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Craft Type")),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: craftTypeList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(craftTypeList[index].craftTypeName),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              form(craftTypeList[index].craftTypeNumber);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              await CraftTypeController.deleteCraftType(
                                  craftTypeList[index].craftTypeNumber!);
                              refresh();
                            },
                          ),
                        ],
                      ),
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

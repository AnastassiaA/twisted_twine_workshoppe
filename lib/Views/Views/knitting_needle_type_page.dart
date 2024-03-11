import 'package:flutter/material.dart';
import 'package:twisted_twine_workshopppe/Controllers/knitting_needle_type_controller.dart';

import '../../Models/Models/knitting_needle_type_model.dart';

class KnittingNeedleTypePage extends StatefulWidget {
  const KnittingNeedleTypePage({super.key});

  @override
  State<KnittingNeedleTypePage> createState() => _KnittingNeedleTypePageState();
}

class _KnittingNeedleTypePageState extends State<KnittingNeedleTypePage> {
  final TextEditingController needleTypeController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    needleTypeController.dispose();
  }

  List<KnittingNeedleTypeModel> needleTypeList = [];
  bool isLoading = true;

  getAllNeedleTypes() async {
    final type = await KnittingNeedleTypeController.getAllNeedleTypes();

    setState(() {
      needleTypeList =
          type.map((e) => KnittingNeedleTypeModel.fromMap(e)).toList();
      isLoading = false;
    });
  }

  @override
  void initState() {
    getAllNeedleTypes();
    super.initState();
  }

  Future refresh() async {
    needleTypeList.clear();
    getAllNeedleTypes();
  }

  void form(int? id) async {
    if (id != null) {
      final thisNeedleType =
          needleTypeList.firstWhere((element) => element.needleTypeID == id);
      needleTypeController.text = thisNeedleType.needleTypeName;
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
                      'Knitting Needle Type',
                    ),
                  ),
                  TextField(
                    controller: needleTypeController,
                    // decoration: const InputDecoration(hintText: 'Enter type'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      child: Text(
                          id == null ? 'Add Knitting Needle Type' : 'Update Knitting Needle Type'),
                      onPressed: () async {
                        if (id == null) {
                          await KnittingNeedleTypeController.createNeedleType(
                            KnittingNeedleTypeModel(
                                needleTypeName: needleTypeController.text),
                          );
                        }

                        if (id != null) {
                          await KnittingNeedleTypeController.updateNeedleType(
                            KnittingNeedleTypeModel(
                                needleTypeID: id,
                                needleTypeName: needleTypeController.text),
                          );
                        }
                        needleTypeController.text = '';

                        if (!mounted) return;
                        Navigator.pop(
                          context,
                        );
                        refresh();
                      })
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Knitting Needle Type"),
      ),
      body: isLoading ?
      const Center(
        child: CircularProgressIndicator(),
      ) : ListView.builder(
        itemCount: needleTypeList.length,
        itemBuilder: ((context, index) {
          return Card(
            child: ListTile(
              title: Text(needleTypeList[index].needleTypeName),
              trailing: SizedBox(
                width: 100,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        form(needleTypeList[index].needleTypeID);
                      }, 
                      icon: const Icon(Icons.edit),),
                      IconButton(
                        onPressed: () async {
                          await KnittingNeedleTypeController.deleteNeedleType(needleTypeList[index].needleTypeID!);
                          refresh();
                        }, 
                        icon: const Icon(Icons.delete))
                  ],
                )
              ),
            ),);
        })),
        floatingActionButton: FloatingActionButton(
        onPressed: () {
          
          form(null);
        },
        child: const Icon(Icons.add),
      )
    );
  }
}

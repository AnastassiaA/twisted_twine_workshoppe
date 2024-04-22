import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:twisted_twine_workshopppe/Controllers/task_controller.dart';
import 'package:twisted_twine_workshopppe/Models/Models/task_model.dart';
import 'package:twisted_twine_workshopppe/Views/Cards/task_card.dart';
import 'package:twisted_twine_workshopppe/Views/Forms/add_project_form.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  List<TaskModel> projectList = [];
  bool isLoading = true;

  getAllProjects() async {
    final projectData = await TaskController.getAllTasksOfType('project');

    setState(() {
      projectList = projectData.map((e) => TaskModel.fromMap(e)).toList();
      isLoading = false;
    });
  }

  @override
  void initState() {
    getAllProjects();
    super.initState();
  }

  Future refresh() async {
    projectList.clear();
    getAllProjects();
  }

  void deleteProject(
      {required TaskModel project, required BuildContext context}) {
    TaskController.deleteTask(project.taskNumber!).then((value) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${project.taskName} deleted')));
    }).catchError((e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    });
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
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
          : ListView.builder(
              itemCount: projectList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey[350],
                      radius: 30,
                      backgroundImage:
                          Image.memory(base64Decode(projectList[index].image))
                              .image,
                    ),
                    title: Text(projectList[index].taskName),
                    subtitle: Text(projectList[index].customer),
                    trailing: Text(projectList[index].status),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Tasks(projectList[index]),
                        ),
                      );
                      //generateRowRecords();
                    },
                    onLongPress: () => showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Delete '
                                '"'
                                '${projectList[index].taskName}'
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
                                  onPressed: () async {
                                    // final result = await OrderController()
                                    //     .deleteOrder(
                                    //         _ordersList[index].orderNumber);
                                    deleteProject(
                                        project: projectList[index],
                                        context: context);

                                    if (!mounted) return;

                                    Navigator.pop(
                                      context,
                                    );
                                    //getAllOrders();
                                    refresh();
                                  },
                                  child: const Text('Delete')),
                            ],
                          );
                        }),
                  ),
                );
              }),
      floatingActionButton: FloatingActionButton(
        onPressed: () { 
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProject()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

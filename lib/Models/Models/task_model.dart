import '../Const/task_const.dart';

class TaskModel {
  final int? taskNumber;
  final String taskName;
  final String image;
  final String customer;
  final DateTime? dateStarted;
  final DateTime? dateCompleted;
  final String craftType; //knit or crochet
  final String status;
  final String description;
  final String? taskType;
  final int? depositMade;

  TaskModel({
    this.taskNumber,
    required this.taskName,
    required this.image,
    required this.customer,
    required this.craftType,
    this.dateStarted,
    this.dateCompleted,
    required this.status,
    required this.description,
    this.depositMade,
    required this.taskType,
  });

  Map<String, dynamic> toMap() {
    return {
      TaskConst.taskNumber: taskNumber,
      TaskConst.taskName: taskName,
      TaskConst.image: image,
      TaskConst.customer: customer,
      TaskConst.dateStarted: dateStarted!.toIso8601String(),
      TaskConst.dateCompleted: dateCompleted!.toIso8601String(),
      TaskConst.craftType: craftType,
      TaskConst.status: status,
      TaskConst.description: description,
      TaskConst.depositMade: depositMade,
      TaskConst.taskType: taskType,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> json) => TaskModel(
        taskNumber: json[TaskConst.taskNumber],
        taskName: json[TaskConst.taskName],
        image: json[TaskConst.image],
        customer: json[TaskConst.customer],
        craftType: json[TaskConst.craftType],
        dateStarted: DateTime.parse(json[TaskConst.dateStarted]),
        dateCompleted: DateTime.parse(json[TaskConst.dateCompleted]),
        status: json[TaskConst.status],
        description: json[TaskConst.description],
        taskType: json[TaskConst.taskType],
        depositMade: json[TaskConst.depositMade],
      );
}

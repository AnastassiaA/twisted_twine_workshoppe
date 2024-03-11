import 'package:twisted_twine_workshopppe/Models/Const/timer_const.dart';

class TimerModel {
  final int? timeSlotId;
  final int? taskNumber;
  final String commissionName;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final Duration amountTime;
  final String? description;

  TimerModel({
    this.timeSlotId,
     this.taskNumber,
    required this.commissionName,
    required this.startDateTime,
    required this.endDateTime,
    required this.amountTime,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      TimerConst.timeSlotId: timeSlotId,
      TimerConst.taskNumber: taskNumber,
      TimerConst.commissionName: commissionName,
      TimerConst.startDateTime: startDateTime.toIso8601String(),
      TimerConst.endDateTime: endDateTime.toIso8601String(),
      TimerConst.amountTime: amountTime.inSeconds.toInt(),
      TimerConst.description: description,
    };
  }

  factory TimerModel.fromMap(Map<String, dynamic> json) => TimerModel(
      timeSlotId: json[TimerConst.timeSlotId],
      taskNumber: json[TimerConst.taskNumber],
      commissionName: json[TimerConst.commissionName],
      startDateTime: DateTime.parse(json[TimerConst.startDateTime]),
      endDateTime: DateTime.parse(json[TimerConst.endDateTime]),
      amountTime:Duration(seconds: json[TimerConst.amountTime]),
      description: json[TimerConst.description]);
}

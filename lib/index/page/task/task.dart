import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';

@JsonSerializable(nullable: false)
class Task {
  num id;
  num number;
  num superTaskId;
  String title;
  String info;
  String imageUrl;
  int status;
  int endTime;
  int progress;
  int level;
  bool complete;
  List<Task> tasks;

  Task(
      this.id,
      this.number,
      this.superTaskId,
      this.title,
      this.info,
      this.imageUrl,
      this.status,
      this.endTime,
      this.progress,
      this.level,
      this.complete,
      this.tasks);


  @override
  String toString() {
    return 'Task{id: $id, number: $number, superTaskId: $superTaskId, title: $title, info: $info, imageUrl: $imageUrl, status: $status, endTime: $endTime, progress: $progress, level: $level, complete: $complete, tasks: $tasks}';
  }

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  String getJson(){
    return jsonEncode(toJson());
  }
  Map<String, dynamic> toJson() => _$TaskToJson(this);

  Task.empty();
}

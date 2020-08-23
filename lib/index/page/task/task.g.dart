// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) {
  return Task(
    json['id'] as num,
    json['number'] as num,
    json['superTaskId'] as num,
    json['title'] as String,
    json['info'] as String,
    json['imageUrl'] as String,
    json['status'] as int,
    json['endTime'] as int,
    json['progress'] as int,
    json['level'] as int,
    json['complete'] as bool,
    (json['tasks'] as List)
        .map((e) => Task.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'id': instance.id,
      'number': instance.number,
      'superTaskId': instance.superTaskId,
      'title': instance.title,
      'info': instance.info,
      'imageUrl': instance.imageUrl,
      'status': instance.status,
      'endTime': instance.endTime,
      'progress': instance.progress,
      'level': instance.level,
      'complete': instance.complete,
      'tasks': instance.tasks,
    };

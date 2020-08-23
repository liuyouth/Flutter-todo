// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['id'] as num,
    json['number'] as num,
    json['stepNum'] as num,
    json['name'] as String,
    json['nikeName'] as String,
    json['avatar'] as String,
    json['token'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'number': instance.number,
      'stepNum': instance.stepNum,
      'name': instance.name,
      'nikeName': instance.nikeName,
      'avatar': instance.avatar,
      'token': instance.token,
    };

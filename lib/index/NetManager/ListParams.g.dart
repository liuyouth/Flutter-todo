// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ListParams.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListParams _$ListParamsFromJson(Map<String, dynamic> json) {
  return ListParams(
    search: json['search'] as bool,
    complete: json['complete'] as bool,
    title: json['title'] as String,
    page: json['page'] as num,
  );
}

Map<String, dynamic> _$ListParamsToJson(ListParams instance) =>
    <String, dynamic>{
      'search': instance.search,
      'complete': instance.complete,
      'title': instance.title,
      'page': instance.page,
    };

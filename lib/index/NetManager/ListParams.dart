
import 'package:json_annotation/json_annotation.dart';

part 'ListParams.g.dart';
@JsonSerializable(nullable: false)
class ListParams{
  bool search;
  bool complete;
  String title;
  num page;


  ListParams({this.search, this.complete, this.title, this.page});

  factory ListParams.fromJson(Map<String, dynamic> json) => _$ListParamsFromJson(json);

  Map<String, dynamic> toJson() => _$ListParamsToJson(this);
}
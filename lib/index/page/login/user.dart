import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';
@JsonSerializable(nullable: false)
class User {
  num id;
  num number;
  num stepNum;
  String name;
  String nikeName;
  String avatar;
  String token;


  User(this.id, this.number, this.stepNum, this.name, this.nikeName,
      this.avatar, this.token);


  @override
  String toString() {
    return 'User{id: $id, number: $number, stepNum: $stepNum, name: $name, nikeName: $nikeName, avatar: $avatar, token: $token}';
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  User.empty();
}

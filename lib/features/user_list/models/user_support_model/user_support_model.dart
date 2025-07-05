import 'package:json_annotation/json_annotation.dart';

part 'user_support_model.g.dart';

@JsonSerializable()
class UserSupportModel {
  @JsonKey(name: 'url')
  final String? url;
  @JsonKey(name: 'text')
  final String? text;

  UserSupportModel({this.url, this.text});

  factory UserSupportModel.fromJson(Map<String, dynamic> json) =>
      _$UserSupportModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserSupportModelToJson(this);
}

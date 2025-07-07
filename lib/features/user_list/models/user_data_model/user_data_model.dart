import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_data_model.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class UserDataModel {
  @HiveField(0)
  @JsonKey(name: 'id')
  final int? id;
  @HiveField(1)
  @JsonKey(name: 'email')
  final String? email;
  @HiveField(2)
  @JsonKey(name: 'first_name')
  final String? firstName;
  @HiveField(3)
  @JsonKey(name: 'last_name')
  final String? lastName;
  @HiveField(4)
  @JsonKey(name: 'avatar')
  final String? avatar;

  UserDataModel({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.avatar,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) =>
      _$UserDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataModelToJson(this);
}

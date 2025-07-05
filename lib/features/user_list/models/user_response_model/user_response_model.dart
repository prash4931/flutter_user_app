import 'package:flutter_user_app/features/user_list/models/user_data_model/user_data_model.dart';
import 'package:flutter_user_app/features/user_list/models/user_support_model/user_support_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_response_model.g.dart';

@JsonSerializable()
class UserResponseModel {
  @JsonKey(name: 'page')
  final int? page;
  @JsonKey(name: 'per_page')
  final int? perPage;
  @JsonKey(name: 'total')
  final int? total;
  @JsonKey(name: 'total_pages')
  final int? totalPages;
  @JsonKey(name: 'data')
  final List<UserDataModel>? data;
  @JsonKey(name: 'support')
  final UserSupportModel? support;

  UserResponseModel({
    this.page,
    this.perPage,
    this.total,
    this.totalPages,
    this.data,
    this.support,
  });

  factory UserResponseModel.fromJson(Map<String, dynamic> json) =>
      _$UserResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserResponseModelToJson(this);
}

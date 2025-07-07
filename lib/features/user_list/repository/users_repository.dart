import 'dart:async';
import 'dart:convert';

import 'package:flutter_user_app/core/endpoints.dart';
import 'package:flutter_user_app/core/error_constants.dart';
import 'package:flutter_user_app/features/user_list/models/user_data_model/user_data_model.dart';
import 'package:flutter_user_app/features/user_list/models/user_response_model/user_response_model.dart';
import 'package:flutter_user_app/features/user_list/repository/i_users_repository.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class UsersRepository implements IUsersRepository {
  @override
  Future<List<UserDataModel>> getUsers({int page = 1, int perPage = 10}) async {
    final client = http.Client();
    final url = Uri.parse('${Endpoints.getUsers}page=$page&per_page=$perPage');

    print('[UserListRepository] Fetching users: $url');
    try {
      final response = await client
          .get(url, headers: {'x-api-key': 'reqres-free-v1'})
          .timeout(const Duration(seconds: 10));
      print('[UserListRepository] Response status: \n${response.statusCode}');
      print('[UserListRepository] Response body: \n${response.body}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final userListResponse = UserResponseModel.fromJson(data);
        final users = userListResponse.data;
        print(
          '[UserListRepository] Parsed users count: \n${userListResponse.data?.length}',
        );
        // Cache users to Hive
        final box = Hive.box<UserDataModel>('users');
        if (page == 1) {
          await box.clear();
          if (users != null && users.isNotEmpty) {
            await box.addAll(users);
          }
        } else {
          // Append new users for next pages
          if (users != null && users.isNotEmpty) {
            await box.addAll(users);
          } 
        }
        return users ?? [];
      } else {
        throw Exception(
          'Failed to load users. Status code: ${response.statusCode}',
        );
      }
    } on http.ClientException catch (e) {
      print('[UserListRepository] ClientException: $e');
      throw Exception(ErrorConstants.noInternetError);
    } on TimeoutException {
      throw Exception('Request timed out. Please try again.');
    } catch (e) {
      print('[UserListRepository] Exception: $e');
      throw Exception('Failed to load users.');
    }
  }

  @override
  List<UserDataModel> loadCachedUsers() {
    final box = Hive.box<UserDataModel>('users');
    return box.values.toList();
  }
}

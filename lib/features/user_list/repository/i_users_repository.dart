import 'package:flutter_user_app/features/user_list/models/user_data_model/user_data_model.dart';
import 'package:flutter_user_app/features/user_list/models/user_response_model/user_response_model.dart';

abstract class IUsersRepository {
  Future<List<UserDataModel>> getUsers({int page = 1, int perPage = 10});

  List<UserDataModel> loadCachedUsers();
}

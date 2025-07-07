import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_user_app/core/error_constants.dart';
import 'package:flutter_user_app/features/user_list/models/user_data_model/user_data_model.dart';
import 'package:flutter_user_app/features/user_list/repository/i_users_repository.dart';
import 'package:flutter_user_app/features/user_list/repository/users_repository.dart';

class UserListProvider extends ChangeNotifier {
  final IUsersRepository repository = UsersRepository();

  List<UserDataModel> users = [];
  bool isLoading = false;
  String? error;
  int _page = 1;
  final int _perPage = 10;
  bool hasMore = true;
  bool isFetchingMore = false;
  String _searchQuery = '';
  String get searchQuery => _searchQuery;
  set searchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  List<UserDataModel> get filteredUsers {
    if (_searchQuery.isEmpty) return users;
    final query = _searchQuery.toLowerCase();
    return users
        .where(
          (user) =>
              (user.firstName != null &&
                  user.firstName!.toLowerCase().contains(query)) ||
              (user.lastName != null &&
                  user.lastName!.toLowerCase().contains(query)),
        )
        .toList();
  }

  Future<void> fetchUsers({bool refresh = false}) async {
    if (isLoading || isFetchingMore) return;
    if (refresh) {
      _page = 1;
      hasMore = true;
      users.clear();
      notifyListeners();
    }
    isLoading = _page == 1;
    isFetchingMore = _page > 1;
    error = null;
    notifyListeners();
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none) ) {
        // Load from cache
        final cached = repository.loadCachedUsers();
        if (cached.isNotEmpty) {
          users = cached;
          error = '${ErrorConstants.noInternetError} Showing cached data.';
        } else {
          error = '${ErrorConstants.noInternetError}. No cached data available.';
        }
        isLoading = false;
        isFetchingMore = false;
        notifyListeners();
        return;
      }
      final fetched = await repository.getUsers(page: _page, perPage: _perPage);
      if (refresh) users.clear();
      if (fetched.isEmpty && _page == 1) {
        error = 'No users found.';
        hasMore = false;
      } else {
        if (fetched.length < _perPage) hasMore = false;
        users.addAll(fetched);
        _page++;
      }
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      isFetchingMore = false;
      notifyListeners();
    }
  }

  void loadMore() {
    if (hasMore && !isLoading && !isFetchingMore) {
      fetchUsers();
    }
  }
}

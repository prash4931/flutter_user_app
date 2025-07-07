import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_user_app/features/user_details/screens/user_details_screen.dart';
import 'package:flutter_user_app/features/user_list/providers/user_list_provider.dart';
import 'package:provider/provider.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      context.read<UserListProvider>().fetchUsers();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User List')),
      body: Consumer<UserListProvider>(
        builder: (context, state, _) {
          if (state.isLoading && state.users.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.error != null && state.users.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.error!, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => state.fetchUsers(refresh: true),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state.users.isEmpty) {
            return const Center(child: Text('No users found.'));
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search by name',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => state.searchQuery = value,
                ),
              ),
              if (state.filteredUsers.isEmpty)
                Expanded(child: Center(child: Text('No users found.'))),
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (!state.isFetchingMore &&
                        state.hasMore &&
                        scrollInfo.metrics.pixels >=
                            scrollInfo.metrics.maxScrollExtent - 200) {
                      state.loadMore();
                    }
                    return false;
                  },
                  child: RefreshIndicator(
                    onRefresh: () => state.fetchUsers(refresh: true),
                    child: ListView.builder(
                      itemCount:
                          state.filteredUsers.length +
                          (state.isFetchingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == state.filteredUsers.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        final user = state.filteredUsers[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              leading: CircleAvatar(
                                radius: 28,

                                // backgroundImage:
                                // user.avatar != null &&
                                //     user.avatar!.isNotEmpty
                                // ? CachedNetworkImage( imageUrl:  user.avatar!)
                                // : null,
                                child: Hero(
                                  tag: 'avatar-hero-tag-${user.id}',
                                  child: ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: user.avatar ?? '',
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                '${user.firstName} ${user.lastName}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Text(
                                user.email ?? 'NA',
                                style: TextStyle(fontSize: 12),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        UserDetailsScreen(user: user),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

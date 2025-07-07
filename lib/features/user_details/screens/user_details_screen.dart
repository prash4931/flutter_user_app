import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_user_app/features/user_list/models/user_data_model/user_data_model.dart';

class UserDetailsScreen extends StatelessWidget {
  final UserDataModel user;

  const UserDetailsScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text('User Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: SizedBox(
                width: double.infinity,
                
                child: Card(
                  elevation: 2,
                
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: 100,
                      ),
                      Hero(
                        tag: 'avatar-hero-tag-${user.id}',
                        child: ClipOval(
                          
                          child: CachedNetworkImage(
                            imageUrl: user.avatar ?? '',
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          ),
                        ),
                      ),
                      
                      Text(
                        '${user.firstName} ${user.lastName}',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(user.email ?? 'NA', style: TextStyle(fontSize: 12)),
                      SizedBox(
                        height: 100,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

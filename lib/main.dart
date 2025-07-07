import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_user_app/features/user_list/models/user_data_model/user_data_model.dart';
import 'package:flutter_user_app/features/user_list/providers/user_list_provider.dart';
import 'package:flutter_user_app/features/user_list/screens/user_list_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserDataModelAdapter());
  await Hive.openBox<UserDataModel>('users');
  await dotenv.load(fileName: ".env");

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserListProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter User App', home: const UserListScreen());
  }
}

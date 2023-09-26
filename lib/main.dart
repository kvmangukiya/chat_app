import 'package:chat_app/views/screens/home_screen.dart';
import 'package:chat_app/views/screens/login.dart';
import 'package:chat_app/views/screens/new_chat.dart';
import 'package:chat_app/views/screens/users.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'controllers/theme_controller.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HI Chat',
      theme: ThemeData(
        brightness: Brightness.light,
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // primaryColor: Colors.deepOrange.shade100,
        // primaryColorDark: const Color(0xff000D6B),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      themeMode:
          themeController.isDark.value ? ThemeMode.dark : ThemeMode.light,
      getPages: [
        GetPage(name: "/", page: () => LoginScreen()),
        GetPage(name: "/users", page: () => Users()),
        GetPage(name: "/home", page: () => HomeScreen()),
        GetPage(name: "/newChat", page: () => NewChat()),
      ],
    );
  }
}

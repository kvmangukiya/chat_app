import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../helpers/auth_helper.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HI Chat"),
        actions: [
          IconButton(
              onPressed: () {
                AuthHelper.authHelper.signOutWithGoogle();
                Get.offNamed("/");
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      drawer: Drawer(
        child: UserAccountsDrawerHeader(
          currentAccountPicture: CircleAvatar(
            child: AuthHelper.lUser.imagePath == null
                ? const Text("")
                : Image.network(AuthHelper.lUser.imagePath as String),
          ),
          accountName: AuthHelper.lUser.name == null
              ? const Text("")
              : Text(AuthHelper.lUser.name as String),
          accountEmail: Text(AuthHelper.lUser.email),
        ),
      ),
    );
  }
}

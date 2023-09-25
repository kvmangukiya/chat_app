import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../helpers/auth_helper.dart';
import '../../helpers/firestore_helper.dart';
import '../../modals/user_modal.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  UserModal? lUser = Get.arguments;

  @override
  Widget build(BuildContext context) {
    log("Login Info: {$lUser}");
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder(
            stream: FireStoreHelper.fireStoreHelper.getAllUser(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<QueryDocumentSnapshot<Map<String, dynamic>>> usersList =
                    snapshot.data!.docs;
                List<UserModal> users =
                    usersList.map((e) => UserModal.fromMap(e.data())).toList();
                return ListView(
                  children: users
                      .map(
                        (user) => ListTile(
                          title: Text(user.name ?? ""),
                          subtitle: Text(user.email),
                          leading: CircleAvatar(
                            child: Text((user.name ?? "")
                                .substring(0, 1)
                                .toUpperCase()),
                          ),
                        ),
                      )
                      .toList(),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
      drawer: Drawer(
        child: UserAccountsDrawerHeader(
          currentAccountPicture: CircleAvatar(
            foregroundImage: (lUser?.imagePath == null)
                ? null
                : NetworkImage(lUser?.imagePath as String),
          ),
          accountName: (lUser?.name == null)
              ? const Text("")
              : Text(lUser?.name as String),
          accountEmail: Text("${lUser?.email}"),
        ),
      ),
    );
  }
}

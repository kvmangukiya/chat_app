import 'package:chat_app/helpers/firestore_helper.dart';
import 'package:chat_app/modals/user_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../helpers/auth_helper.dart';

class Users extends StatelessWidget {
  Users({super.key});
  final UserModal lUser = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
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
                            child: Text((user.name ?? "").substring(1, 1)),
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
            child: lUser.imagePath == null
                ? Text((lUser.name ?? "").substring(1, 1))
                : Image.network(lUser.imagePath as String),
          ),
          accountName:
              lUser.name == null ? const Text("") : Text(lUser.name as String),
          accountEmail: Text(lUser.email),
        ),
      ),
    );
  }
}

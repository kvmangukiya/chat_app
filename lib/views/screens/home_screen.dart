import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../helpers/auth_helper.dart';
import '../../helpers/firestore_helper.dart';
import '../../modals/user_modal.dart';

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
                            child: Text(user.id.toString()),
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

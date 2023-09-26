import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../helpers/auth_helper.dart';
import '../../helpers/firestore_helper.dart';
import '../../modals/user_modal.dart';
import '../components/drawer.dart';
import '../components/theme_button.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final UserModal lUser = Get.arguments;

  @override
  Widget build(BuildContext context) {
    log("Login Info: {$lUser}");
    return Scaffold(
      appBar: AppBar(
        title: const Text("HI Chat"),
        actions: [
          themeButton(context),
          IconButton(
              onPressed: () {
                AuthHelper.authHelper.signOutWithGoogle();
                Get.offNamed("/");
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: StreamBuilder(
          stream: FireStoreHelper.fireStoreHelper.getChatUsers(lUser.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<QueryDocumentSnapshot<Map<String, dynamic>>> usersList =
                  snapshot.data!.docs;
              return ListView(
                children: usersList.map(
                  (userData) {
                    Map<String, dynamic> user = userData.data();
                    int dispTime = user['lastMsgTime'];
                    // if (dispTime) {}
                    return ListTile(
                      title: Text(user['name'] ?? ""),
                      subtitle: Text(user['lastMsg']),
                      leading: CircleAvatar(
                        foregroundImage: (user['imagePath'] == null)
                            ? null
                            : NetworkImage(user['imagePath']),
                        child: (user['imagePath'] == null ||
                                user['imagePath'] == "")
                            ? Text((user['name'] ?? "")
                                .substring(0, 1)
                                .toUpperCase())
                            : null,
                      ),
                      trailing: Text("${dispTime}"),
                    );
                  },
                ).toList(),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          Get.toNamed("/newChat", arguments: lUser);
        },
        child: const Icon(Icons.message_outlined, size: 22),
      ),
      drawer: hiDrawer(lUser),
    );
  }
}

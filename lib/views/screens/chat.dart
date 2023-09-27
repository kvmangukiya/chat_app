import 'dart:developer';
import 'package:chat_app/views/components/back_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../helpers/auth_helper.dart';
import '../../helpers/firestore_helper.dart';
import '../../modals/user_modal.dart';
import '../components/theme_button.dart';

class Chat extends StatelessWidget {
  Chat({super.key});
  final UserModal lUser = Get.arguments[0];
  final Map<String, dynamic> cUser = Get.arguments[1];

  @override
  Widget build(BuildContext context) {
    log("Login Info: {$lUser}");
    return Scaffold(
      appBar: AppBar(
        leading: backButton(context),
        title: const Text("New Chat"),
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
          stream:
              FireStoreHelper.fireStoreHelper.getChat(lUser.id, cUser['id']),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<QueryDocumentSnapshot<Map<String, dynamic>>> chatList =
                  snapshot.data!.docs;

              return ListView(
                children: chatList
                    .map((chat) => Card(
                          child: Text(chat['msg']),
                        ))
                    .toList(),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

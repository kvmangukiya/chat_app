import 'dart:developer';
import 'package:chat_app/modals/contact_modal.dart';
import 'package:chat_app/views/components/back_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../helpers/auth_helper.dart';
import '../../helpers/firestore_helper.dart';
import '../../modals/user_modal.dart';
import '../components/theme_button.dart';

class NewChat extends StatelessWidget {
  NewChat({super.key});
  final UserModal lUser = Get.arguments;

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
          stream: FireStoreHelper.fireStoreHelper.getAllNewChatUser(lUser.id),
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
                        onTap: () async {
                          bool resFlag = await FireStoreHelper.fireStoreHelper
                              .newChatContact(
                                  senderId: lUser.id, receiverId: user.id);
                          if (resFlag) {
                            ContactModal cm = ContactModal(
                                id: user.id,
                                name: user.name ?? "",
                                imagePath: user.imagePath ?? "",
                                lastMsg: "",
                                lastMsgTime: 0,
                                lastUnreadMsgCount: 0,
                                lastUnreadMsgId: 0);
                            Get.offNamed("/chat", arguments: [lUser, cm]);
                          } else {
                            Get.snackbar("Fail...",
                                "There is some problem, try after some time...");
                          }
                        },
                        title: Text(user.name ?? ""),
                        subtitle: Text(user.email),
                        leading: CircleAvatar(
                          child: Text(
                              (user.name ?? "").substring(0, 1).toUpperCase()),
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
    );
  }
}

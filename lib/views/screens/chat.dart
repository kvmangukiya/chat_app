import 'dart:developer';
import 'package:chat_app/views/components/back_button.dart';
import 'package:chat_app/views/components/functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../helpers/auth_helper.dart';
import '../../helpers/firestore_helper.dart';
import '../../modals/color_modal.dart';
import '../../modals/user_modal.dart';
import '../components/theme_button.dart';

class Chat extends StatelessWidget {
  Chat({super.key});
  final UserModal lUser = Get.arguments[0];
  final Map<String, dynamic> cUser = Get.arguments[1];
  TextEditingController newChat = TextEditingController();

  @override
  Widget build(BuildContext context) {
    log("Login Info: {$lUser}");
    return Scaffold(
      appBar: AppBar(
        leading: backButton(context),
        title: Text(cUser['name']),
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
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: FireStoreHelper.fireStoreHelper
                    .getChat(lUser.id, cUser['id']),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<QueryDocumentSnapshot<Map<String, dynamic>>> chatList =
                        snapshot.data!.docs;

                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: ListView(
                        children: chatList
                            .map((chat) => Row(
                                  mainAxisAlignment:
                                      chatAlignment(chat['type']),
                                  children: [
                                    Card(
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        child: Column(
                                          children: [
                                            Text(
                                              chat['msg'],
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: Text(
                                                chatMsgTime(chat['msgTime']),
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color:
                                                        Colors.grey.shade500),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ))
                            .toList(),
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ),
          TextFormField(
            controller: newChat,
            textInputAction: TextInputAction.send,
            textCapitalization: TextCapitalization.sentences,
            style: const TextStyle().copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: ColorModal.primaryColor),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white.withOpacity(0.2),
              hintText: "Enter message here",
              hintStyle: const TextStyle()
                  .copyWith(color: ColorModal.primaryColor.withOpacity(0.5)),
              border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(color: ColorModal.primaryColor)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  borderSide:
                      BorderSide(color: ColorModal.primaryColor, width: 1.5)),
              suffixIcon: IconButton(
                color: ColorModal.primaryColor,
                icon: const Icon(Icons.send_rounded),
                onPressed: () {},
              ),
              labelStyle: const TextStyle().copyWith(color: Colors.grey),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }

  MainAxisAlignment chatAlignment(String sType) {
    if (sType == "S") {
      return MainAxisAlignment.end;
    } else {
      return MainAxisAlignment.start;
    }
  }
}

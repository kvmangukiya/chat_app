import 'dart:developer';
import 'package:chat_app/modals/chat_modal.dart';
import 'package:chat_app/modals/contact_modal.dart';
import 'package:chat_app/views/components/back_button.dart';
import 'package:chat_app/views/components/functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../helpers/auth_helper.dart';
import '../../helpers/firestore_helper.dart';
import '../../modals/color_modal.dart';
import '../../modals/user_modal.dart';
import '../components/theme_button.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final UserModal lUser = Get.arguments[0];

  final ContactModal cUser = Get.arguments[1];

  TextEditingController newChat = TextEditingController();
  TextEditingController editChat = TextEditingController();

  late AutoScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.vertical);
  }

  @override
  Widget build(BuildContext context) {
    log("Login Info: {$lUser}");

    return Scaffold(
      appBar: AppBar(
        leading: backButton(context),
        title: Text(cUser.name),
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
                stream:
                    FireStoreHelper.fireStoreHelper.getChat(lUser.id, cUser.id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<QueryDocumentSnapshot<Map<String, dynamic>>>
                        chatLists = snapshot.data!.docs;
                    List<ChatModal> chatList = chatLists
                        .map((e) => ChatModal.fromMap(e.data()))
                        .toList();
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: ListView(
                        controller: scrollController,
                        children: chatList
                            .map((chat) => AutoScrollTag(
                                  key: ValueKey(chat.id),
                                  controller: scrollController,
                                  index: chat.id,
                                  child: GestureDetector(
                                    onLongPress: () {
                                      log("test");
                                      showCupertinoDialog(
                                        context: context,
                                        builder: (context) {
                                          editChat.text = chat.msg;
                                          return CupertinoAlertDialog(
                                            title: const Text("Edit Chat"),
                                            content: Material(
                                              child: TextFormField(
                                                maxLines: 8,
                                                minLines: 3,
                                                controller: editChat,
                                                textInputAction:
                                                    TextInputAction.send,
                                                textCapitalization:
                                                    TextCapitalization
                                                        .sentences,
                                                style: const TextStyle()
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 16,
                                                        color: ColorModal
                                                            .primaryColor),
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.white
                                                      .withOpacity(0.2),
                                                  hintText: "Enter msg here",
                                                  hintStyle: const TextStyle()
                                                      .copyWith(
                                                          color: ColorModal
                                                              .primaryColor
                                                              .withOpacity(
                                                                  0.5)),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  8)),
                                                      borderSide: BorderSide(
                                                          color: ColorModal
                                                              .primaryColor)),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                                  Radius
                                                                      .circular(
                                                                          8)),
                                                          borderSide: BorderSide(
                                                              color: ColorModal
                                                                  .primaryColor,
                                                              width: 1.5)),
                                                  labelStyle: const TextStyle()
                                                      .copyWith(
                                                          color: Colors.grey),
                                                  contentPadding:
                                                      const EdgeInsets.all(12),
                                                ),
                                              ),
                                            ),
                                            actions: [
                                              CupertinoDialogAction(
                                                isDefaultAction: true,
                                                onPressed: () async {
                                                  await FireStoreHelper
                                                      .fireStoreHelper
                                                      .editChat(
                                                          lUser.id,
                                                          cUser.id,
                                                          chat.id,
                                                          editChat.text)
                                                      .then(
                                                          (value) =>
                                                              Navigator.pop(
                                                                  context),
                                                          onError: (e) =>
                                                              Navigator.pop(
                                                                  context));
                                                },
                                                child:
                                                    const Text("Edit - Save"),
                                              ),
                                              CupertinoDialogAction(
                                                isDestructiveAction: true,
                                                onPressed: () async {
                                                  await FireStoreHelper
                                                      .fireStoreHelper
                                                      .deleteChat(lUser.id,
                                                          cUser.id, chat.id)
                                                      .then(
                                                          (value) =>
                                                              Navigator.pop(
                                                                  context),
                                                          onError: (e) =>
                                                              Navigator.pop(
                                                                  context));
                                                },
                                                child: const Text("Delete"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          chatAlignment(chat.type),
                                      children: [
                                        LimitedBox(
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          child: Card(
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.7,
                                              child: Column(
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      chat.msg,
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: Text(
                                                      chatMsgTime(chat.msgTime),
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors
                                                              .grey.shade500),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
                onPressed: () async {
                  if (newChat.text != "") {
                    int id = DateTime.now().millisecondsSinceEpoch;
                    if (await FireStoreHelper.fireStoreHelper.insertChat(
                      senderId: lUser.id,
                      receiverId: cUser.id,
                      chatMsg: ChatModal(
                          id: id,
                          msg: newChat.text,
                          msgTime: id,
                          seenTime: 0,
                          type: "S"),
                    )) {
                      newChat.text = "";
                    }
                  }
                },
              ),
              labelStyle: const TextStyle().copyWith(color: Colors.grey),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
          _scrollToIndex1(),
        ],
      ),
    );
  }

  Widget _scrollToIndex1() {
    Future.delayed(const Duration(milliseconds: 400))
        .then((value) => _scrollToIndex());
    return Container();
  }

  Future<void> _scrollToIndex() async {
    await scrollController.scrollToIndex(1696218154704,
        preferPosition: AutoScrollPosition.end);
  }

  MainAxisAlignment chatAlignment(String sType) {
    if (sType == "S") {
      return MainAxisAlignment.end;
    } else {
      return MainAxisAlignment.start;
    }
  }
}

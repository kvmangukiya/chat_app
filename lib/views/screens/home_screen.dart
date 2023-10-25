import 'dart:developer';

import 'package:chat_app/modals/contact_modal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../helpers/auth_helper.dart';
import '../../helpers/firestore_helper.dart';
import '../../modals/user_modal.dart';
import '../components/drawer.dart';
import '../components/functions.dart';
import '../components/theme_button.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserModal lUser = Get.arguments;

  @override
  initState() {
    super.initState();

    checkPermission();
  }

  checkPermission() async {
    if (await Permission.notification.isDenied) {
      Get.dialog(
        AlertDialog(
          title: const Text("Please allow notifications..."),
          actions: [
            IconButton(
                onPressed: () {
                  openAppSettings();
                },
                icon: const Icon(Icons.settings))
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String lastMTime;
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    log("Login Info: {$lUser}");
    return Scaffold(
      key: scaffoldKey,
      drawer: hiDrawer(lUser),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => scaffoldKey.currentState!.openDrawer(),
          child: Transform.scale(
            scale: 0.6,
            child: CircleAvatar(
              foregroundImage: (lUser.imagePath == null)
                  ? null
                  : NetworkImage(lUser.imagePath as String),
            ),
          ),
        ),
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
              List<ContactModal> usersList = snapshot.data!.docs
                  .map((e) => ContactModal.fromMap(e.data()))
                  .toList();
              log("Users:  ${usersList.length.toString()}");
              return ListView(
                children: usersList.map(
                  (userData) {
                    log(userData.toString());
                    lastMTime = lastMsgTime(DateTime.fromMillisecondsSinceEpoch(
                        userData.lastMsgTime));

                    return ListTile(
                      onTap: () async {
                        await FireStoreHelper.fireStoreHelper.updateChatContact(
                            senderId: lUser.id, receiverId: userData.id);
                        Get.toNamed("/chat", arguments: [lUser, userData]);
                      },
                      title: Text(userData.name),
                      subtitle: Text(userData.lastMsg),
                      leading: CircleAvatar(
                        foregroundImage: (userData.imagePath == "")
                            ? null
                            : NetworkImage(userData.imagePath),
                        child: (userData.imagePath.isEmpty)
                            ? (userData.name.isNotEmpty
                                ? Text(
                                    userData.name.substring(0, 1).toUpperCase())
                                : null)
                            : null,
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(lastMTime),
                          const SizedBox(height: 2),
                          (userData.lastUnreadMsgCount > 0)
                              ? CircleAvatar(
                                  radius: 10,
                                  child: Text(
                                      userData.lastUnreadMsgCount.toString(),
                                      style: const TextStyle(fontSize: 12)),
                                )
                              : const SizedBox(height: 20),
                        ],
                      ),
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

          // LocalNotificationHelper.localNotificationHelper.simpleNotification(
          //     userId: lUser.id % 10000,
          //     title: "Shital",
          //     subTitle: "Jai Swaminarayan");

          // LocalNotificationHelper.localNotificationHelper.scheduleNotification(
          //     userId: lUser.id % 10000,
          //     title: "Shital",
          //     subTitle: "Jai Swaminarayan");
        },
        child: const Icon(Icons.message_outlined, size: 22),
      ),
    );
  }
}

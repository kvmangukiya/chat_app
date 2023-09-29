import 'dart:developer';
import 'package:chat_app/helpers/notification_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
                    String lastMTime = lastMsgTime(
                        DateTime.fromMillisecondsSinceEpoch(
                            user['lastMsgTime']));

                    return ListTile(
                      onTap: () {
                        Get.toNamed("/chat", arguments: [lUser, user]);
                      },
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
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(lastMTime),
                          const SizedBox(height: 2),
                          (user['lastUnreadMsgCount'] > 0)
                              ? CircleAvatar(
                                  radius: 10,
                                  child: Text(
                                      user['lastUnreadMsgCount'].toString(),
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
          // Get.toNamed("/newChat", arguments: lUser);

          // LocalNotificationHelper.localNotificationHelper.simpleNotification(
          //     userId: lUser.id % 10000,
          //     title: "Shital",
          //     subTitle: "Jai Swaminarayan");

          LocalNotificationHelper.localNotificationHelper.scheduleNotification(
              userId: lUser.id % 10000,
              title: "Shital",
              subTitle: "Jai Swaminarayan");
        },
        child: const Icon(Icons.message_outlined, size: 22),
      ),
      drawer: hiDrawer(lUser),
    );
  }
}

import 'package:chat_app/modals/user_modal.dart';
import 'package:flutter/material.dart';

Widget hiDrawer(UserModal lUser) {
  return Drawer(
    child: UserAccountsDrawerHeader(
      currentAccountPicture: CircleAvatar(
        foregroundImage: (lUser.imagePath == null)
            ? null
            : NetworkImage(lUser.imagePath as String),
      ),
      accountName:
          (lUser.name == null) ? const Text("") : Text(lUser.name as String),
      accountEmail: Text(lUser.email),
    ),
  );
}

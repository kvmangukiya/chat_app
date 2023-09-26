import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/theme_controller.dart';

Widget backButton(BuildContext context,
    {IconData icon = Icons.arrow_back_ios_new_rounded}) {
  ThemeController themeController = Get.find<ThemeController>();
  return IconButton(
      onPressed: () => Get.back(),
      icon: themeController.getIsDark()
          ? Icon(icon)
          : Icon(icon, color: Theme.of(context).primaryColorDark));
}

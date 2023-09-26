import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/theme_controller.dart';

Widget themeButton(BuildContext context) {
  ThemeController themeController = Get.find<ThemeController>();

  return IconButton(
    onPressed: () {
      if (themeController.getIsDark()) {
        themeController.setIsDark(false);
        Get.changeThemeMode(ThemeMode.light);
      } else {
        themeController.setIsDark(true);
        Get.changeThemeMode(ThemeMode.dark);
      }
    },
    icon: Obx(
      () => themeController.getIsDark()
          ? const Icon(Icons.light_outlined)
          : const Icon(Icons.light_rounded),
    ),
  );
}

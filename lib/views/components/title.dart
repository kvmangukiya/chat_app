import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget appTitle(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Get.toNamed("/");
    },
    child: const Text("Quotes",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
  );
}

Widget title(
        {required String text,
        double fs = 16,
        FontWeight fw = FontWeight.w600,
        Color co = Colors.indigo}) =>
    Text(
      text,
      style: TextStyle(fontSize: fs, fontWeight: fw, color: co),
    );

import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSnackBarMessage(
    BuildContext context,
    String message, [
      bool isError = false,
    ]) {
  Get.snackbar(
    "Notification",
    message,
    backgroundColor: isError ? Colors.red : Colors.green,
    colorText: Colors.white,
    snackPosition: SnackPosition.BOTTOM,
    duration: const Duration(seconds: 3),
  );
}

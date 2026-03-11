import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget loadingSpinner() {
  return const Center(
    child: CircularProgressIndicator(),
  );
}

void showErrorSnackbar(String message) {
  Get.snackbar(
    'Error',
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.red.shade100,
    colorText: Colors.red.shade900,
  );
}

void showSuccessSnackbar(String message) {
  Get.snackbar(
    'Success',
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.green.shade100,
    colorText: Colors.green.shade900,
  );
}

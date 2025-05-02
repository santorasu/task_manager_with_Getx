import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/data/service/network_client.dart';
import 'package:task_management/data/utils/urls.dart';
import 'package:task_management/ui/screens/login_screen.dart';
import 'package:task_management/ui/widgets/snack_bar_message.dart';

class ResetPasswordController extends GetxController {
  final TextEditingController newPasswordTEController = TextEditingController();
  final TextEditingController confirmNewPasswordTEController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  RxBool passwordVisible = false.obs;
  RxBool confirmPasswordVisible = false.obs;
  RxBool isLoading = false.obs;

  late String email;
  late String otp;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    email = args['email'];
    otp = args['OTP'];
  }

  String? passwordValidator(String? value) {
    if ((value?.isEmpty ?? true) || (value!.length < 6)) {
      return 'Enter your password more than 6 characters';
    }
    return null;
  }

  String? confirmPasswordValidator(String? value) {
    if ((value?.isEmpty ?? true) || (value!.length < 6)) {
      return 'Enter your password more than 6 characters';
    }
    if (value != newPasswordTEController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> resetPassword() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    String newPassword = newPasswordTEController.text.trim();

    Map<String, dynamic> requestBody = {
      "email": email,
      "OTP": otp,
      "password": newPassword,
    };

    String url = Urls.recoverResetPasswordUrl;
    NetworkResponse response = await NetworkClient.postRequest(
      url: url,
      body: requestBody,
    );

    if (response.statusCode == 200) {
      showSnackBarMessage(Get.context!, 'Password reset successful');
      Get.offAll(() => const LoginScreen());
    } else {
      showSnackBarMessage(Get.context!, 'Failed to reset password', true);
    }

    isLoading.value = false;
  }

  @override
  void onClose() {
    newPasswordTEController.dispose();
    confirmNewPasswordTEController.dispose();
    super.onClose();
  }
}

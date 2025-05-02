import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/data/service/network_client.dart';
import 'package:task_management/data/utils/urls.dart';
import 'package:task_management/ui/screens/forgot_password_pin_verification_screen.dart';
import 'package:task_management/ui/widgets/snack_bar_message.dart';

class ForgotPasswordController extends GetxController {
  final TextEditingController emailTEController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final RxBool isLoading = false.obs;

  String? emailValidator(String value) {
    if (value.trim().isEmpty) {
      return 'Enter your mail address';
    }
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegExp.hasMatch(value)) {
      return 'Enter a valid mail';
    }
    return null;
  }

  Future<void> forgetPasswordEmailVerify() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    String email = emailTEController.text.trim();
    String url = Urls.recoverVerifyEmailUrl(email);

    try {
      NetworkResponse response = await NetworkClient.getRequest(url: url);

      if (response.statusCode == 200) {
        Get.off(() => ForgotPasswordPinVerificationScreen(email: email));
      } else {
        showSnackBarMessage(Get.context!, 'Email not found', true);
      }
    } catch (error) {
      showSnackBarMessage(Get.context!, 'An error occurred. Please try again.', true);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailTEController.dispose();
    super.onClose();
  }
}

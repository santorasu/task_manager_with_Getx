import 'package:get/get.dart';
import 'package:task_management/data/service/network_client.dart';
import 'package:task_management/data/utils/urls.dart';
import 'package:task_management/ui/screens/forgot_password_pin_verification_screen.dart';
import 'package:task_management/ui/widgets/snack_bar_message.dart';

class ForgotPasswordController extends GetxController {
  var isLoading = false.obs;
  var email = ''.obs;

  // Method to verify the email and navigate to pin verification screen
  Future<void> verifyEmail(String email) async {
    isLoading.value = true;

    String url = Urls.recoverVerifyEmailUrl(email);

    try {
      NetworkResponse response = await NetworkClient.getRequest(url: url);

      if (response.statusCode == 200) {
        // Navigate to the pin verification screen if the email is valid
        Get.to(() => ForgotPasswordPinVerificationScreen(email: email));
      } else {
        showSnackBarMessage(Get.context!, 'Email not found', true);
      }
    } catch (error) {
      showSnackBarMessage(Get.context!, 'An error occurred. Please try again.', true);
    } finally {
      isLoading.value = false;
    }
  }

  // Validate email format
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
}

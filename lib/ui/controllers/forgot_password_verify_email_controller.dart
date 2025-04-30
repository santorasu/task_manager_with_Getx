import 'package:get/get.dart';
import 'package:task_management/data/service/network_client.dart';
import 'package:task_management/data/utils/urls.dart';
import 'package:task_management/ui/screens/forgot_password_pin_verification_screen.dart';
import 'package:task_management/ui/widgets/snack_bar_message.dart';

class ForgotPasswordController extends GetxController {
  var isLoading = false.obs;
  var email = ''.obs;

  Future<void> verifyEmail(String email) async {
    isLoading.value = true;

    String url = Urls.recoverVerifyEmailUrl(email);

    try {
      NetworkResponse response = await NetworkClient.getRequest(url: url);

      if (response.statusCode == 200) {
        Get.to(() => ForgotPasswordPinVerificationScreen(email: email));
        showSnackBarMessage(Get.context!, 'Email found', false);
      } else {
        showSnackBarMessage(Get.context!, 'Email not found', true);
      }
    } catch (error) {
      showSnackBarMessage(Get.context!, 'An error occurred. Please try again.', true);
    } finally {
      isLoading.value = false;
    }
  }


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

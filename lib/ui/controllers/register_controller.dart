import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:task_management/data/service/network_client.dart';
import 'package:task_management/data/utils/urls.dart';
import 'package:task_management/ui/widgets/snack_bar_message.dart';

class RegisterController extends GetxController {

  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var registrationInProgress = false.obs;

  Future<void> registerUser() async {
    registrationInProgress.value = true;

    Map<String, dynamic> requestBody = {
      "email": emailController.text.trim(),
      "firstName": firstNameController.text.trim(),
      "lastName": lastNameController.text.trim(),
      "mobile": mobileController.text.trim(),
      "password": passwordController.text,
    };

    NetworkResponse response = await NetworkClient.postRequest(
      url: Urls.registerUrl,
      body: requestBody,
    );

    registrationInProgress.value = false;

    if (response.isSuccess) {
      emailController.clear();
      firstNameController.clear();
      lastNameController.clear();
      mobileController.clear();
      passwordController.clear();

      showSnackBarMessage(Get.context!, "User registered successfully!");
    } else {
      showSnackBarMessage(Get.context!, response.errorMessage, true);
    }
  }
}

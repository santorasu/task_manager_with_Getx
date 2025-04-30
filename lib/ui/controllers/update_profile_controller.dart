import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_management/data/models/user_model.dart';
import 'package:task_management/data/service/network_client.dart';
import 'package:task_management/data/utils/urls.dart';
import 'package:task_management/ui/screens/main_bottom_nav_screen.dart';
import 'package:task_management/ui/widgets/snack_bar_message.dart';
import 'package:task_management/ui/controllers/auth_controller.dart';

class UpdateProfileController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  bool updateProfileInProgress = false;
  XFile? pickedImage;

  void initializeUserData() {
    UserModel userModel = AuthController.userModel!;
    emailController.text = userModel.email;
    firstNameController.text = userModel.firstName;
    lastNameController.text = userModel.lastName;
    mobileController.text = userModel.mobile;
  }

  Future<void> pickImage() async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      pickedImage = image;
      update();
    }
  }

  Future<void> updateProfile() async {
    updateProfileInProgress = true;
    update();

    Map<String, dynamic> requestBody = {
      "email": emailController.text.trim(),
      "firstName": firstNameController.text.trim(),
      "lastName": lastNameController.text.trim(),
      "mobile": mobileController.text.trim(),
    };

    if (passwordController.text.isNotEmpty) {
      requestBody['password'] = passwordController.text;
    }

    if (pickedImage != null) {
      List<int> imageBytes = await pickedImage!.readAsBytes();
      String encodedImage = base64Encode(imageBytes);
      requestBody['photo'] = encodedImage;
    }

    NetworkResponse response = await NetworkClient.postRequest(
      url: Urls.updateProfileUrl,
      body: requestBody,
    );

    updateProfileInProgress = false;
    update();

    if (response.isSuccess) {
      AuthController.userModel!.firstName = firstNameController.text.trim();
      AuthController.userModel!.lastName = lastNameController.text.trim();
      AuthController.userModel!.mobile = mobileController.text.trim();
      showSnackBarMessage(Get.context!, "Profile updated successfully!");
      Get.offAll(() => const MainBottomNavScreen());
    } else {
      showSnackBarMessage(Get.context!, response.errorMessage, true);
    }
  }
}

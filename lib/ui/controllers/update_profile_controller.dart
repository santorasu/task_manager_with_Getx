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
  // Form Controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Form validation state
  bool updateProfileInProgress = false;
  XFile? pickedImage;

  // Initialize user data
  void initializeUserData() {
    UserModel userModel = AuthController.userModel!;
    emailController.text = userModel.email;
    firstNameController.text = userModel.firstName;
    lastNameController.text = userModel.lastName;
    mobileController.text = userModel.mobile;
  }

  // Image picker method
  Future<void> pickImage() async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      pickedImage = image;
      update();
    }
  }

  // Update profile method
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

    // Send the update request
    NetworkResponse response = await NetworkClient.postRequest(
      url: Urls.updateProfileUrl,
      body: requestBody,
    );

    updateProfileInProgress = false;
    update();

    if (response.isSuccess) {
      // Update user model with new information
      AuthController.userModel!.firstName = firstNameController.text.trim();
      AuthController.userModel!.lastName = lastNameController.text.trim();
      AuthController.userModel!.mobile = mobileController.text.trim();

      showSnackBarMessage(Get.context!, "Profile updated successfully!");
      Get.offAll(() => const MainBottomNavScreen()); // Navigate to main screen
    } else {
      showSnackBarMessage(Get.context!, response.errorMessage, true);
    }
  }
}

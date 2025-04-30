import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/ui/controllers/update_profile_controller.dart';
import 'package:task_management/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_management/ui/widgets/screen_background.dart';
import 'package:task_management/ui/widgets/tm_app_bar.dart';

class UpdateProfileScreen extends StatelessWidget {
  UpdateProfileScreen({super.key});

  final UpdateProfileController _controller = Get.put(UpdateProfileController());

  @override
  Widget build(BuildContext context) {
    _controller.initializeUserData();

    return Scaffold(
      appBar: TMAppBar(fromProfileScreen: true),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: GlobalKey<FormState>(),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 32),
                  Text(
                    "Update Profile",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 24),
                  _buildPhotoPickerWidget(),
                  SizedBox(height: 8),
                  _buildTextField('Email', _controller.emailController, false),
                  SizedBox(height: 8),
                  _buildTextField('First Name', _controller.firstNameController, true),
                  SizedBox(height: 8),
                  _buildTextField('Last Name', _controller.lastNameController, true),
                  SizedBox(height: 8),
                  _buildTextField('Phone', _controller.mobileController, true, keyboardType: TextInputType.phone),
                  SizedBox(height: 8),
                  _buildTextField('Password', _controller.passwordController, true, obscureText: true),
                  SizedBox(height: 16),
                  GetBuilder<UpdateProfileController>(
                    builder: (controller) {
                      return Visibility(
                        visible: !controller.updateProfileInProgress,
                        replacement: const CenteredCircularProgressIndicator(),
                        child: ElevatedButton(
                          onPressed: controller.updateProfile,
                          child: const Icon(
                            Icons.arrow_circle_right_outlined,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller, bool isEnabled, {bool obscureText = false, TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(hintText: hint),
      obscureText: obscureText,
      enabled: isEnabled,
      keyboardType: keyboardType,
      validator: (value) {
        if (value?.trim().isEmpty ?? true) {
          return 'Enter your $hint';
        }
        return null;
      },
    );
  }

  Widget _buildPhotoPickerWidget() {
    return GestureDetector(
      onTap: _controller.pickImage,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                'Photo',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 8),
            Text(_controller.pickedImage?.name ?? "Select Your Photo")
          ],
        ),
      ),
    );
  }
}

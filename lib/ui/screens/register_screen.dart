import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/ui/controllers/register_controller.dart';
import 'package:task_management/ui/screens/login_screen.dart';
import 'package:task_management/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_management/ui/widgets/screen_background.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final RegisterController _controller = Get.put(RegisterController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 80),
                  Text(
                    "Join With Us",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 24),
                  _buildEmailField(),
                  SizedBox(height: 8),
                  _buildFirstNameField(),
                  SizedBox(height: 8),
                  _buildLastNameField(),
                  SizedBox(height: 8),
                  _buildPhoneField(),
                  SizedBox(height: 8),
                  _buildPasswordField(),
                  SizedBox(height: 16),
                  _buildSubmitButton(),
                  SizedBox(height: 16),
                  _buildSignInRedirect(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _controller.emailController,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(hintText: 'Email'),
      validator: (String? value) {
        if ((value?.isEmpty ?? true) || !EmailValidator.validate(value!)) {
          return 'Enter a valid Email';
        }
        return null;
      },
    );
  }

  Widget _buildFirstNameField() {
    return TextFormField(
      controller: _controller.firstNameController,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(hintText: 'First Name'),
      validator: (String? value) {
        if ((value?.trim().isEmpty ?? true)) {
          return 'Enter your first name';
        }
        return null;
      },
    );
  }

  Widget _buildLastNameField() {
    return TextFormField(
      controller: _controller.lastNameController,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(hintText: 'Last Name'),
      validator: (String? value) {
        if ((value?.trim().isEmpty ?? true)) {
          return 'Enter your last name';
        }
        return null;
      },
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _controller.mobileController,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(hintText: 'Mobile'),
      validator: (String? value) {
        String phone = value?.trim() ?? '';
        RegExp regExp = RegExp(
          r"^(?:\+88|0088)?(01[15-9]\d{8})$",
        );
        if (regExp.hasMatch(phone) == false) {
          return 'Enter a valid phone number';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _controller.passwordController,
      decoration: InputDecoration(hintText: 'Password'),
      validator: (String? value) {
        if ((value?.isEmpty ?? true) || (value!.length < 6)) {
          return 'Enter a password with more than 6 characters';
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton() {
    return Obx(() {
      return Visibility(
        visible: !_controller.registrationInProgress.value,
        replacement: const CenteredCircularProgressIndicator(),
        child: ElevatedButton(
          onPressed: _onTapSubmitButton,
          child: const Icon(
            Icons.arrow_circle_right_outlined,
            color: Colors.white,
            size: 24,
          ),
        ),
      );
    });
  }

  Widget _buildSignInRedirect() {
    return Center(
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          children: [
            TextSpan(text: "Already have an account? "),
            TextSpan(
              text: "Sign In",
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()..onTap = _onTapSignInButton,
            ),
          ],
        ),
      ),
    );
  }

  void _onTapSubmitButton() {
    if (_formKey.currentState!.validate()) {
      _controller.registerUser();
      clearFields();
      Get.to(LoginScreen());
    }
  }

  void _onTapSignInButton() {
    Get.back();
  }

  void clearFields() {
    _controller.emailController.clear();
    _controller.firstNameController.clear();
    _controller.lastNameController.clear();
    _controller.mobileController.clear();
    _controller.passwordController.clear();
  }
}

import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/ui/controllers/login_controller.dart';
import 'package:task_management/ui/screens/register_screen.dart';
import 'package:task_management/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_management/ui/widgets/screen_background.dart';

import '../widgets/snack_bar_message.dart';
import 'forgot_password_verify_email_screen.dart';
import 'main_bottom_nav_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final LoginController _loginController = Get.find<LoginController>();

  bool _passwordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 80),
                Text(
                  "Get Started with",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 24),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textInputAction: TextInputAction.next,
                  controller: _emailTEController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(hintText: 'Email'),
                  validator: (String? value) {
                    String email = value?.trim() ?? '';
                    if (EmailValidator.validate(email) == false) {
                      return 'Enter a valid Email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _passwordTEController,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible =
                              !_passwordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (String? value) {
                    if ((value?.isEmpty ?? true) || (value!.length < 6)) {
                      return 'Enter your password more than 6 characters';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16),
                GetBuilder<LoginController>(
                  builder: (controller) {
                    return Visibility(
                      visible: controller.logInProgress == false,
                      replacement: const CenteredCircularProgressIndicator(),
                      child: ElevatedButton(
                        onPressed: _onTapSignInButton,
                        child: const Icon(
                          Icons.arrow_circle_right_outlined,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 16),
                Center(
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: _onTapForgotPasswordButton,
                        child: Text("Forgot Password?"),
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(text: "Don't have account? "),
                            TextSpan(
                              text: "Sign Up",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = _onTapSignUpButton,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTapSignInButton() {
    if (_formKey.currentState!.validate()) {
      _login();
    }
  }

  Future<void> _login() async {
    final bool isSuccess = await _loginController.login(
      _emailTEController.text.trim(),
      _passwordTEController.text,
    );
    if (isSuccess) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainBottomNavScreen()),
        (predicate) => false,
      );
    } else {
      showSnackBarMessage(context, _loginController.errorMessage!, true);
    }
  }

  void _onTapSignUpButton() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterScreen()),
    );
  }

  void _onTapForgotPasswordButton() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ForgotPasswordVerifyEmailScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}

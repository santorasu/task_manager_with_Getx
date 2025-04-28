import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_management/data/service/network_client.dart';
import 'package:task_management/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_management/ui/widgets/screen_background.dart';
import 'package:task_management/ui/widgets/snack_bar_message.dart';

import '../../data/utils/urls.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  bool _registrationInProgress = false;
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
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailTEController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    textInputAction: TextInputAction.next,
                    controller: _firstNameTEController,
                    decoration: InputDecoration(hintText: 'First Name'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your first name';
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 8),

                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _lastNameTEController,
                    decoration: InputDecoration(hintText: 'Last Name'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your last name';
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 8),

                  TextFormField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    controller: _mobileTEController,
                    decoration: InputDecoration(hintText: 'Mobile'),
                    validator: (String? value) {
                      String phone = value?.trim() ?? '';
                      RegExp regExp = RegExp(
                        r"^(?:\+88|0088)?(01[15-9]\d{8})$",
                      );
                      if (regExp.hasMatch(phone) == false) {
                        return 'Enter your phone number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordTEController,
                    decoration: InputDecoration(hintText: 'Password'),
                    validator: (String? value) {
                      if ((value?.isEmpty ?? true) || (value!.length < 6)) {
                        return 'Enter your password more than 6 character';
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 16),
                  Visibility(
                    visible: _registrationInProgress == false,
                    replacement: const CenteredCircularProgressIndicator(),
                    child: ElevatedButton(
                      onPressed: _onTabSubmitButton,
                      child: const Icon(
                        Icons.arrow_circle_right_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
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
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = _onTapSignInButton,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _clearTextFields(){
    _emailTEController.clear();
    _firstNameTEController.clear();
    _lastNameTEController.clear();
    _mobileTEController.clear();
    _passwordTEController.clear();
  }

  void _onTabSubmitButton() {
    if (_formKey.currentState!.validate()) {
      _registerUser();
    }
  }

  Future<void> _registerUser() async {
    _registrationInProgress = true;
    setState(() {});
    Map<String, dynamic> requestBody = {
      "email": _emailTEController.text.trim(),
      "firstName": _firstNameTEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "mobile": _mobileTEController.text.trim(),
      "password": _passwordTEController.text,
    };
    NetworkResponse response = await NetworkClient.postRequest(
      url: Urls.registerUrl,
      body: requestBody,
    );
    _registrationInProgress = false;
    setState(() {});
    if (response.isSuccess) {
      _clearTextFields();
     showSnackBarMessage(context, "User register successfully!");
    } else {
      showSnackBarMessage(context, response.errorMessage,true);
    }
  }

  void _onTapSignInButton() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}

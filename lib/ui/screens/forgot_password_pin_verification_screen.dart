import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_management/data/service/network_client.dart';
import 'package:task_management/data/utils/urls.dart';
import 'package:task_management/ui/screens/reset_password_screen.dart';
import 'package:task_management/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_management/ui/widgets/screen_background.dart';
import 'package:task_management/ui/widgets/snack_bar_message.dart';

import 'login_screen.dart';

class ForgotPasswordPinVerificationScreen extends StatefulWidget {
  final String email;
  const ForgotPasswordPinVerificationScreen({super.key, required this.email});

  @override
  State<ForgotPasswordPinVerificationScreen> createState() =>
      _ForgotPasswordPinVerificationScreenState();
}

class _ForgotPasswordPinVerificationScreenState
    extends State<ForgotPasswordPinVerificationScreen> {
  final TextEditingController _pinCodeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isOtpInProgress = false;
  bool _isDisposed = false;

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
                  "Pin Verification",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 4),
                Text(
                  "A 6 digit verification pin has been sent to your email",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                ),
                SizedBox(height: 24),
                PinCodeTextField(
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  keyboardType: TextInputType.number,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                    selectedFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  backgroundColor: Colors.transparent,
                  enableActiveFill: true,
                  controller: _pinCodeController,
                  appContext: context,
                  validator: (String? value) {
                    if (value!.trim().isEmpty) {
                      return 'Please enter your OTP';
                    } else if (value.trim().length < 6) {
                      return 'Please enter a valid OTP';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _onTapSubmitButton,
                  child: Visibility(
                    visible: !_isOtpInProgress,
                    replacement: const CenteredCircularProgressIndicator(),
                    child: const Text("Verify"),
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
                        const TextSpan(text: "Already Have an account? "),
                        TextSpan(
                          text: "Sign In",
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
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
    );
  }

  void _onTapSubmitButton() {
    if (_formKey.currentState!.validate()) {
      forgetPasswordOTPVerify();
    }
  }

  Future<void> forgetPasswordOTPVerify() async {
    final String otp = _pinCodeController.text;
    if (_isDisposed) return;

    setState(() {
      _isOtpInProgress = true;
    });

    Map<String, dynamic> authDataForSetPassword = {
      'email': widget.email,
      'OTP': otp,
    };

    String url = Urls.otpVerifyUrl(
      email: widget.email,
      otp: otp,
    );

    try {
      NetworkResponse response = await NetworkClient.getRequest(url: url);

      if (_isDisposed) return;
      _pinCodeController.clear();

      if (!mounted) return;

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResetPasswordScreen(),
            settings: RouteSettings(
              arguments: {
                'email': widget.email,
                'OTP': otp,
              },
            ),
          ),
        );
      } else {
        showSnackBarMessage(context, 'Invalid OTP !!!', true);
      }
    } catch (error) {
      if (_isDisposed) return;
      showSnackBarMessage(context, 'An error occurred. Please try again.', true);
    } finally {
      setState(() {
        _isOtpInProgress = false;
      });
    }
  }

  void _onTapSignInButton() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
          (pre) => false,
    );
  }

  @override
  void dispose() {
    _pinCodeController.dispose();
    _isDisposed = true;
    super.dispose();
  }
}

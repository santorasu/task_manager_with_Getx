import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/forgot_password_verify_email_controller.dart';
import '../widgets/centered_circular_progress_indicator.dart';
import '../widgets/screen_background.dart';

class ForgotPasswordVerifyEmailScreen extends StatelessWidget {
  const ForgotPasswordVerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ForgotPasswordController>(
      init: ForgotPasswordController(),
      builder: (controller) {
        return Scaffold(
          body: ScreenBackground(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 80),
                    Text(
                      "Your Email Address",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "A 6 digit verification pin will be sent to your email",
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      controller: controller.emailTEController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(hintText: 'Email'),
                      validator:
                          (value) => controller.emailValidator(value ?? ''),
                    ),
                    const SizedBox(height: 16),
                    Obx(() {
                      return ElevatedButton(
                        onPressed:
                            controller.isLoading.value
                                ? null
                                : controller.forgetPasswordEmailVerify,
                        child: Visibility(
                          visible: !controller.isLoading.value,
                          replacement:
                              const CenteredCircularProgressIndicator(),
                          child: const Icon(
                            Icons.arrow_circle_right_outlined,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 32),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          children: [
                            const TextSpan(text: "Have account? "),
                            TextSpan(
                              text: "Sign In",
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      Get.back();
                                    },
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
      },
    );
  }
}

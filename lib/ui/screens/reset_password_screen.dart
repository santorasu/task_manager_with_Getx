import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reset_password_controller.dart';
import '../widgets/centered_circular_progress_indicator.dart';
import '../widgets/screen_background.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ResetPasswordController>(
      init: ResetPasswordController(),
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
                      "Set Password",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Set a new password minimum length of 6 letters.",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    Obx(() {
                      return TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: controller.newPasswordTEController,
                        textInputAction: TextInputAction.next,
                        obscureText: !controller.passwordVisible.value,
                        decoration: InputDecoration(
                          hintText: "Enter New Password",
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.passwordVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              controller.passwordVisible.value =
                              !controller.passwordVisible.value;
                            },
                          ),
                        ),
                        validator: controller.passwordValidator,
                      );
                    }),
                    const SizedBox(height: 8),
                    Obx(() {
                      return TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: controller.confirmNewPasswordTEController,
                        obscureText: !controller.confirmPasswordVisible.value,
                        decoration: InputDecoration(
                          hintText: "Confirm New Password",
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.confirmPasswordVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              controller.confirmPasswordVisible.value =
                              !controller.confirmPasswordVisible.value;
                            },
                          ),
                        ),
                        validator: controller.confirmPasswordValidator,
                      );
                    }),
                    const SizedBox(height: 16),
                    Obx(() {
                      return ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.resetPassword,
                        child: Visibility(
                          visible: !controller.isLoading.value,
                          replacement: const CenteredCircularProgressIndicator(),
                          child: const Text("Confirm"),
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
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
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.offAll(() => const LoginScreen());
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

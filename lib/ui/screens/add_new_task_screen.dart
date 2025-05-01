import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/ui/controllers/add_new_task_controller.dart';
import 'package:task_management/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_management/ui/widgets/screen_background.dart';
import 'package:task_management/ui/widgets/tm_app_bar.dart';
import 'package:task_management/ui/screens/main_bottom_nav_screen.dart';

class AddNewTaskScreen extends StatelessWidget {
  final TextEditingController _titleTTController = TextEditingController();
  final TextEditingController _descriptionTTController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AddNewTaskController _addNewTaskController = Get.find<AddNewTaskController>();

  AddNewTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 32),
                  Text(
                    "Add New Task",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 24),
                  _buildTitleField(),
                  SizedBox(height: 8),
                  _buildDescriptionField(),
                  SizedBox(height: 16),
                  _buildSubmitButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleTTController,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(hintText: 'Title'),
      validator: (String? value) {
        if (value?.trim().isEmpty ?? true) {
          return 'Enter your Title';
        }
        return null;
      },
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionTTController,
      maxLines: 6,
      decoration: InputDecoration(
        hintText: 'Description',
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      validator: (String? value) {
        if (value?.trim().isEmpty ?? true) {
          return 'Enter your Description';
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return GetBuilder<AddNewTaskController>(
      builder: (controller) {
        return Visibility(
          visible: !controller.addNewTaskInProgress,
          replacement: const CenteredCircularProgressIndicator(),
          child: ElevatedButton(
            onPressed: (){_onTapSubmitButton(context);},
            child: const Icon(
              Icons.arrow_circle_right_outlined,
              color: Colors.white,
              size: 24,
            ),
          ),
        );
      },
    );
  }

  void _onTapSubmitButton(context) {
    if (_formKey.currentState!.validate()) {
      _addNewTaskController.addNewTask(
        _titleTTController.text.trim(),
        _descriptionTTController.text.trim(),
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) => MainBottomNavScreen()));
    }
  }

  @override
  void dispose() {
    _titleTTController.dispose();
    _descriptionTTController.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:task_management/data/service/network_client.dart';
import 'package:task_management/data/utils/urls.dart';
import 'package:task_management/ui/screens/main_bottom_nav_screen.dart';
import 'package:task_management/ui/screens/progress_task_screen.dart';
import 'package:task_management/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_management/ui/widgets/screen_background.dart';
import 'package:task_management/ui/widgets/tm_app_bar.dart';

import '../widgets/snack_bar_message.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _titleTTController = TextEditingController();
  final TextEditingController _descriptionTTController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _addNewTaskInProgress = false;
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

                  TextFormField(
                    controller: _titleTTController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(hintText: 'Title'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your Title';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _descriptionTTController,
                    maxLines: 6,
                    decoration: InputDecoration(
                      hintText: 'Description',
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your Description';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  Visibility(
                    visible: _addNewTaskInProgress == false,
                    replacement: const CenteredCircularProgressIndicator(),
                    child: ElevatedButton(
                      onPressed: _onTapSubmitButton,
                      child: const Icon(
                        Icons.arrow_circle_right_outlined,
                        color: Colors.white,
                        size: 24,
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

  void _onTapSubmitButton() {
    if (_formKey.currentState!.validate()) {
      _addNewTask();
      // Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => MainBottomNavScreen()));
      Get.to(MainBottomNavScreen());
    }
  }

  Future<void> _addNewTask() async {
    _addNewTaskInProgress = true;
    setState(() {});

    Map<String, dynamic> requestBody = {
      "title": _titleTTController.text.trim(),
      "description": _descriptionTTController.text.trim(),
      "status": 'New',
    };
    final NetworkResponse response = await NetworkClient.postRequest(
      url: Urls.createTaskUrl,
      body: requestBody,
    );

    _addNewTaskInProgress = false;
    setState(() {});

    if(response.isSuccess){
      _clearTextFields();
      showSnackBarMessage(context, "New Task Added");
    }else{
      showSnackBarMessage(context,response.errorMessage);
    }
  }

  void _clearTextFields(){
    _titleTTController.clear();
    _descriptionTTController.clear();
  }

  @override
  void dispose() {
    _titleTTController.dispose();
    _descriptionTTController.dispose();
    super.dispose();
  }
}

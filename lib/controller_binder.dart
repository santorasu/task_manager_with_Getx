import 'package:get/get.dart';
import 'package:task_management/ui/controllers/add_new_task_controller.dart';
import 'package:task_management/ui/controllers/cancelled_task_controller.dart';
import 'package:task_management/ui/controllers/completed_task_controller.dart';
import 'package:task_management/ui/controllers/delete_task_controller.dart';
import 'package:task_management/ui/controllers/forgot_password_verify_email_controller.dart';
import 'package:task_management/ui/controllers/login_controller.dart';
import 'package:task_management/ui/controllers/main_bottom_nav_controller.dart';
import 'package:task_management/ui/controllers/new_task_controller.dart';
import 'package:task_management/ui/controllers/progress_task_controller.dart';
import 'package:task_management/ui/controllers/update_profile_controller.dart';

class ControllerBinder extends Bindings{
  @override
  void dependencies() {
    Get.put(LoginController());
    Get.put(NewTaskController());
    Get.put(ProgressTaskController());
    Get.put(CompletedTaskController());
    Get.put(CancelledTaskController());
    Get.put(DeleteTaskController());
    Get.put(AddNewTaskController());
    Get.put(MainBottomNavController());
    Get.put(UpdateProfileController());
    //Get.put(ForgotPasswordController());
  }

}
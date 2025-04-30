import 'package:get/get.dart';
import 'package:task_management/ui/controllers/cancelled_task_controller.dart';
import 'package:task_management/ui/controllers/completed_task_controller.dart';
import 'package:task_management/ui/controllers/login_controller.dart';
import 'package:task_management/ui/controllers/new_task_controller.dart';
import 'package:task_management/ui/controllers/progress_task_controller.dart';

class ControllerBinder extends Bindings{
  @override
  void dependencies() {
    Get.put(LoginController());
    Get.put(NewTaskController());
    Get.put(ProgressTaskController());
    Get.put(CompletedTaskController());
    Get.put(CancelledTaskController());
  }

}
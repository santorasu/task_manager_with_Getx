import 'package:get/get.dart';
import 'package:task_management/data/service/network_client.dart';
import 'package:task_management/data/utils/urls.dart';
import 'package:task_management/ui/controllers/new_task_controller.dart';
import 'package:task_management/ui/widgets/snack_bar_message.dart';


class AddNewTaskController extends GetxController {
  bool _addNewTaskInProgress = false;
  bool get addNewTaskInProgress => _addNewTaskInProgress;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  NewTaskController newTaskController = Get.put(NewTaskController());
 

  Future<void> addNewTask(String title, String description) async {
    _addNewTaskInProgress = true;
    update();

    Map<String, dynamic> requestBody = {
      "title": title.trim(),
      "description": description.trim(),
      "status": 'New',
    };

    final NetworkResponse response = await NetworkClient.postRequest(
      url: Urls.createTaskUrl,
      body: requestBody,
    );

    _addNewTaskInProgress = false;
    update();

    if (response.isSuccess) {
      _errorMessage = null;
      showSnackBarMessage(Get.context!, "New Task Added");
      newTaskController.getNewTaskList();
      update();
    } else {
      _errorMessage = response.errorMessage;
      showSnackBarMessage(Get.context!, _errorMessage!, true);
    }
  }
}

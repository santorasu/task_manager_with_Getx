import 'dart:ui';
import 'package:get/get.dart';
import 'package:task_management/data/service/network_client.dart';
import 'package:task_management/data/utils/urls.dart';
import 'package:task_management/ui/widgets/snack_bar_message.dart';

class DeleteTaskController extends GetxController {
  bool _isInProgress = false;
  bool get isInProgress => _isInProgress;

  Future<void> deleteTask(String taskId, VoidCallback onSuccess) async {
    _isInProgress = true;
    update();

    final NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.deleteTaskUrl(taskId),
    );

    _isInProgress = false;
    update();

    if (response.isSuccess) {
      onSuccess();
    } else {
      showSnackBarMessage(Get.context!, response.errorMessage, true);
    }
  }
}

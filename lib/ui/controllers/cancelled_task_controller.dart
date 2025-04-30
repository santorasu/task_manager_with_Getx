import 'package:get/get.dart';
import 'package:task_management/data/models/task_list_model.dart';
import 'package:task_management/data/models/task_model.dart';
import 'package:task_management/data/service/network_client.dart';
import 'package:task_management/data/utils/urls.dart';

class CancelledTaskController extends GetxController {
  bool _getCancelledTasksInProgress = false;
  bool get getCancelledTasksInProgress => _getCancelledTasksInProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<TaskModel> _cancelledTaskList = [];
  List<TaskModel> get cancelledTaskList => _cancelledTaskList;

  Future<void> getAllCancelledTaskList() async {
    _getCancelledTasksInProgress = true;
    update();

    final NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.cancelledTaskListUrl,
    );

    if (response.isSuccess) {
      TaskListModel taskListModel = TaskListModel.fromJson(response.data ?? {});
      _cancelledTaskList = taskListModel.taskList;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
      _cancelledTaskList = [];
    }

    _getCancelledTasksInProgress = false;
    update();
  }
}

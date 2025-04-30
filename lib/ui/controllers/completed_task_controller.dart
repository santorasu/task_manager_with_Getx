import 'package:get/get.dart';
import 'package:task_management/data/models/task_list_model.dart';
import 'package:task_management/data/models/task_model.dart';
import 'package:task_management/data/service/network_client.dart';
import 'package:task_management/data/utils/urls.dart';

class CompletedTaskController extends GetxController {
  bool _getCompletedTaskInProgress = false;
  bool get getCompletedTaskInProgress => _getCompletedTaskInProgress;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<TaskModel> _completedTaskList = [];
  List<TaskModel> get completedTaskList => _completedTaskList;

  Future<void> getAllCompletedTaskList() async {
    _getCompletedTaskInProgress = true;
    update();

    final NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.completedTaskListUrl,
    );

    if (response.isSuccess) {
      TaskListModel taskListModel = TaskListModel.fromJson(response.data ?? {});
      _completedTaskList = taskListModel.taskList;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
      _completedTaskList = [];
    }

    _getCompletedTaskInProgress = false;
    update();
  }
}

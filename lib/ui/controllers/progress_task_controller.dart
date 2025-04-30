import 'package:get/get.dart';
import 'package:task_management/data/models/task_list_model.dart';
import 'package:task_management/data/models/task_model.dart';
import 'package:task_management/data/service/network_client.dart';
import 'package:task_management/data/utils/urls.dart';

class ProgressTaskController extends GetxController {
  bool _getProgressTasksInProgress = false;
  bool get getProgressTasksInProgress => _getProgressTasksInProgress;

  List<TaskModel> _progressTaskList = [];
  List<TaskModel> get progressTaskList => _progressTaskList;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> getAllProgressTaskList() async {
    await _getAllProgressTaskList();
  }

  Future<void> _getAllProgressTaskList() async {
    _getProgressTasksInProgress = true;
    update();

    final NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.progressTaskListUrl,
    );

    if (response.isSuccess) {
      TaskListModel taskListModel = TaskListModel.fromJson(response.data ?? {});
      _progressTaskList = taskListModel.taskList;
      _errorMessage = null;
    } else {
      _progressTaskList = [];
      _errorMessage = response.errorMessage;
    }

    _getProgressTasksInProgress = false;
    update();
  }
}

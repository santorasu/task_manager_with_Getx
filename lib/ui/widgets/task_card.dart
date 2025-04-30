import 'package:date_formatter/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/data/models/task_model.dart';
import 'package:task_management/data/service/network_client.dart';
import 'package:task_management/data/utils/urls.dart';
import 'package:task_management/ui/controllers/delete_task_controller.dart';
import 'package:task_management/ui/screens/main_bottom_nav_screen.dart';
import 'package:task_management/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_management/ui/widgets/snack_bar_message.dart';

enum TaskStatus { sNew, progress, completed, cancelled }

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.taskStatus,
    required this.taskModel,
    required this.refreshList,
  });

  final TaskStatus taskStatus;
  final TaskModel taskModel;
  final VoidCallback refreshList;

  @override
  Widget build(BuildContext context) {
    final DeleteTaskController _deleteTaskController = Get.find<DeleteTaskController>();

    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              taskModel.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Text(taskModel.description),
            Text(
              "Date: ${DateFormatter.formatDateTime(dateTime: DateTime.parse(taskModel.createdDate), outputFormat: 'dd/MM/yyyy')}",
            ),

            Row(
              children: [
                Chip(
                  label: Text(
                    taskModel.status,
                    style: const TextStyle(color: Colors.white),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  backgroundColor: _getStatusChipColor(),
                  side: BorderSide.none,
                ),
                const Spacer(),
                Row(
                  children: [
                    GetBuilder<DeleteTaskController>(
                      builder: (controller) {
                        return Visibility(
                          visible: controller.isInProgress == false,
                          replacement: const CenteredCircularProgressIndicator(),
                          child: IconButton(
                            onPressed: () {
                              _deleteTaskController.deleteTask(taskModel.id, () {
                                refreshList();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MainBottomNavScreen(),
                                  ),
                                );
                              });
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      onPressed: () {
                        _showUpdateStatusDialog(context);
                      },
                      icon: const Icon(Icons.edit),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusChipColor() {
    late Color color;
    switch (taskStatus) {
      case TaskStatus.sNew:
        color = Colors.blue;
        break;
      case TaskStatus.progress:
        color = Colors.purple;
        break;
      case TaskStatus.completed:
        color = Colors.green;
        break;
      case TaskStatus.cancelled:
        color = Colors.red;
        break;
    }
    return color;
  }

  void _showUpdateStatusDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStatusOption(context, 'New'),
              _buildStatusOption(context, 'Progress'),
              _buildStatusOption(context, 'Completed'),
              _buildStatusOption(context, 'Cancelled'),
            ],
          ),
        );
      },
    );
  }

  ListTile _buildStatusOption(BuildContext context, String status) {
    return ListTile(
      onTap: () {
        _popDialog(context);
        if (taskModel.status == status) return;
        _changeTaskStatus(status);
      },
      title: Text(status),
      trailing: taskModel.status == status ? const Icon(Icons.done) : null,
    );
  }

  void _popDialog(BuildContext context) {
    Navigator.pop(context);
  }

  Future<void> _changeTaskStatus(String status) async {
    final response = await NetworkClient.getRequest(
      url: Urls.updateTaskStatusUrl(taskModel.id, status),
    );

    if (response.isSuccess) {
      refreshList();
    } else {
      showSnackBarMessage(Get.context!, response.errorMessage, true);
    }
  }
}

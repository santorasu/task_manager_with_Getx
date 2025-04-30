import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/ui/controllers/completed_task_controller.dart';
import 'package:task_management/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_management/ui/widgets/snack_bar_message.dart';
import 'package:task_management/ui/widgets/task_card.dart';
import '../../data/models/task_model.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  final CompletedTaskController _controller = Get.find<CompletedTaskController>();

  @override
  void initState() {
    super.initState();
    _loadCompletedTasks();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<CompletedTaskController>(
        builder: (controller) {
          return Visibility(
            visible: controller.getCompletedTaskInProgress == false,
            replacement: const CenteredCircularProgressIndicator(),
            child: ListView.separated(
              itemCount: controller.completedTaskList.length,
              itemBuilder: (context, index) {
                return TaskCard(
                  taskStatus: TaskStatus.completed,
                  taskModel: controller.completedTaskList[index],
                  refreshList: _loadCompletedTasks,
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 8),
            ),
          );
        },
      ),
    );
  }

  void _loadCompletedTasks() async {
    await _controller.getAllCompletedTaskList();
    if (_controller.errorMessage != null) {
      showSnackBarMessage(context, _controller.errorMessage!, true);
    }
  }
}

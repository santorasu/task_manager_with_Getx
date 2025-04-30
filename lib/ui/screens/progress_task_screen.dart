import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/ui/controllers/progress_task_controller.dart';
import 'package:task_management/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_management/ui/widgets/snack_bar_message.dart';
import 'package:task_management/ui/widgets/task_card.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {
  final ProgressTaskController _controller = Get.find<ProgressTaskController>();

  @override
  void initState() {
    super.initState();
    _getAllProgressTaskList();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ProgressTaskController>(
        builder: (controller) {
          return Visibility(
            visible: controller.getProgressTasksInProgress == false,
            replacement: const CenteredCircularProgressIndicator(),
            child: ListView.separated(
              itemCount: controller.progressTaskList.length,
              itemBuilder: (context, index) {
                return TaskCard(
                  taskStatus: TaskStatus.progress,
                  taskModel: controller.progressTaskList[index],
                  refreshList: _getAllProgressTaskList,
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 8),
            ),
          );
        },
      ),
    );
  }

  void _getAllProgressTaskList() async {
    await _controller.getAllProgressTaskList();
    if (_controller.errorMessage != null) {
      showSnackBarMessage(context, _controller.errorMessage!, true);
    }
  }
}



import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/ui/controllers/cancelled_task_controller.dart';
import 'package:task_management/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_management/ui/widgets/snack_bar_message.dart';
import 'package:task_management/ui/widgets/task_card.dart';

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {
  final CancelledTaskController _controller = Get.find<CancelledTaskController>();

  @override
  void initState() {
    super.initState();
    _getAllCancelledTaskList();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<CancelledTaskController>(
        builder: (controller) {
          return Visibility(
            visible: controller.getCancelledTasksInProgress == false,
            replacement: const CenteredCircularProgressIndicator(),
            child: ListView.separated(
              itemCount: controller.cancelledTaskList.length,
              itemBuilder: (context, index) {
                return TaskCard(
                  taskStatus: TaskStatus.cancelled,
                  taskModel: controller.cancelledTaskList[index],
                  refreshList: _getAllCancelledTaskList,
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 8),
            ),
          );
        },
      ),
    );
  }

  void _getAllCancelledTaskList() async {
    await _controller.getAllCancelledTaskList();
    if (_controller.errorMessage != null) {
      showSnackBarMessage(context, _controller.errorMessage!, true);
    }
  }
}

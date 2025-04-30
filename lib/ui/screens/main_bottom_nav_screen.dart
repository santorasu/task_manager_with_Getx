import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management/ui/screens/progress_task_screen.dart';
import 'cancelled_task_screen.dart';
import 'completed_task_screen.dart';
import 'new_tasks_screen.dart';
import '../widgets/tm_app_bar.dart';
import '../controllers/main_bottom_nav_controller.dart';

class MainBottomNavScreen extends StatelessWidget {
  const MainBottomNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MainBottomNavController _controller = Get.put(MainBottomNavController());

    final List<Widget> _screens = const [
      NewTaskScreen(),
      ProgressTaskScreen(),
      CompletedTaskScreen(),
      CancelledTaskScreen(),
    ];

    return Scaffold(
      appBar: const TMAppBar(),
      body: Obx(() {
        return _screens[_controller.selectedIndex.value];
      }),
      bottomNavigationBar: Obx(() {
        return NavigationBar(
          selectedIndex: _controller.selectedIndex.value,
          onDestinationSelected: (index) {
            _controller.changeIndex(index);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.new_label),
              label: 'New',
            ),
            NavigationDestination(
              icon: Icon(Icons.ac_unit_sharp),
              label: 'Progress',
            ),
            NavigationDestination(
              icon: Icon(Icons.done),
              label: 'Complete',
            ),
            NavigationDestination(
              icon: Icon(Icons.cancel_outlined),
              label: 'Cancelled',
            ),
          ],
        );
      }),
    );
  }
}

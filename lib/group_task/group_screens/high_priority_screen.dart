import 'package:flutter/material.dart';
import 'package:task_shefa/group_task/group_screens/priority_tasks_screen.dart';

class HighPriorityScreen extends StatelessWidget {
  const HighPriorityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PriorityTasksScreen(config: PriorityTasksConfig.high);
  }
}

import 'package:flutter/material.dart';
import 'package:task_shefa/group_task/group_screens/widgets/state_chip_widget.dart';

import '../../../task/task_model/task_model.dart';
import '../group_task_ui.dart';
// ui of overview card
class OverviewCardWidget extends StatelessWidget{
  final List<TaskModel> tasks;
  const OverviewCardWidget({super.key, required this.tasks});

  int openTaskCount() =>
      tasks.where((t) => !t.isCompleted).length;
  int doneTaskCount() => tasks.length - openTaskCount();

  @override
  Widget build(BuildContext context) {
    final open = openTaskCount();
    final done = doneTaskCount();
    return Container(
      margin: const EdgeInsets.fromLTRB(GroupTaskUi.hPad, 4, GroupTaskUi.hPad, 16),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [GroupTaskUi.primary, GroupTaskUi.primaryDark],
        ),
        borderRadius: BorderRadius.circular(GroupTaskUi.radiusLg),
        boxShadow: GroupTaskUi.cardShadow(GroupTaskUi.primary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your workspace',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${tasks.length} total tasks',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              StateChipWidget(label: 'open',value:  '$open',color:  Colors.white),
              const SizedBox(width: 8),
              StateChipWidget(label: 'done',value:  '$done',color:  Colors.white),
            ],
          ),
        ],
      ),
    );

  }
}
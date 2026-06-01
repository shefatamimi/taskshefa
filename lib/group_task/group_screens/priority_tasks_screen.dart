import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_shefa/group_task/group_screens/group_task_ui.dart';
import 'package:task_shefa/task/task_model/task_model.dart';
import 'package:task_shefa/task/task_service/task_service.dart';

/// Visual and filter configuration for a priority task list.
class PriorityTasksConfig {
  const PriorityTasksConfig({
    required this.priority,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.softColor,
    required this.gradient,
    required this.icon,
    required this.emptyMessage,
    required this.emptyHint,
  });

  final String priority;
  final String title;
  final String subtitle;
  final Color accent;
  final Color softColor;
  final List<Color> gradient;
  final IconData icon;
  final String emptyMessage;
  final String emptyHint;

  static const high = PriorityTasksConfig(
    priority: 'High',
    title: 'High priority',
    subtitle: 'Needs immediate attention',
    accent: GroupTaskUi.high,
    softColor: GroupTaskUi.highSoft,
    gradient: [GroupTaskUi.high, Color(0xFFE63946)],
    icon: Icons.flag_rounded,
    emptyMessage: 'No high priority tasks',
    emptyHint: 'You\'re all caught up on urgent work',
  );

  static const medium = PriorityTasksConfig(
    priority: 'Medium',
    title: 'Medium priority',
    subtitle: 'Complete soon',
    accent: GroupTaskUi.medium,
    softColor: GroupTaskUi.mediumSoft,
    gradient: [GroupTaskUi.medium, Color(0xFFE67E22)],
    icon: Icons.schedule_rounded,
    emptyMessage: 'No medium priority tasks',
    emptyHint: 'Nothing scheduled for the near term',
  );

  static const low = PriorityTasksConfig(
    priority: 'Low',
    title: 'Low priority',
    subtitle: 'Schedule for later',
    accent: GroupTaskUi.low,
    softColor: GroupTaskUi.lowSoft,
    gradient: [GroupTaskUi.low, Color(0xFF1ABC9C)],
    icon: Icons.trending_down_rounded,
    emptyMessage: 'No low priority tasks',
    emptyHint: 'Relax — nothing on the back burner',
  );
}

class PriorityTasksScreen extends StatefulWidget {
  const PriorityTasksScreen({super.key, required this.config});

  final PriorityTasksConfig config;

  @override
  State<PriorityTasksScreen> createState() => _PriorityTasksScreenState();
}

class _PriorityTasksScreenState extends State<PriorityTasksScreen> {
  final TaskService _taskService = TaskService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late Stream<List<TaskModel>> _taskStream;
  late String _userId;

  PriorityTasksConfig get _config => widget.config;

  @override
  void initState() {
    super.initState();
    final user = _auth.currentUser;
    if (user == null) {
      _userId = '';
      _taskStream = const Stream.empty();
      return;
    }
    _userId = user.uid;
    _taskStream = _taskService.getTasks(_userId);
  }

  List<TaskModel> _filterTasks(List<TaskModel> tasks) {
    return tasks
        .where(
          (t) => t.priority == _config.priority && !t.isCompleted,
        )
        .toList();
  }

  Future<void> _toggleComplete(TaskModel task) async {
    final updated = TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      dueDate: task.dueDate,
      priority: task.priority,
      isCompleted: !task.isCompleted,
      userId: task.userId,
      alert: task.alert,
      groupId: task.groupId,
    );
    await _taskService.updateTask(task.id!, updated);
    if (!mounted) return;
    showGroupTaskSnackBar(
      context,
      task.isCompleted ? 'Task marked incomplete' : 'Task completed',
    );
  }

  Future<void> _deleteTask(TaskModel task) async {
    final confirmed = await showDeleteTaskDialog(context, task.title);
    if (confirmed != true || task.id == null) return;
    try {
      await _taskService.deleteTask(task.id!);
      if (!mounted) return;
      showGroupTaskSnackBar(context, 'Task deleted');
    } catch (e) {
      if (!mounted) return;
      showGroupTaskSnackBar(context, 'Failed to delete: $e', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GroupTaskUi.background,
      body: StreamBuilder<List<TaskModel>>(
        stream: _taskStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: GroupTaskUi.primary),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(color: GroupTaskUi.textSecondary),
              ),
            );
          }

          final tasks = _filterTasks(snapshot.data ?? []);

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: GroupTaskListHeader(
                  eyebrow: 'Priority',
                  title: _config.title,
                  subtitle: _config.subtitle,
                  accent: _config.accent,
                  softColor: _config.softColor,
                  gradient: _config.gradient,
                  icon: _config.icon,
                  taskCount: tasks.length,
                ),
              ),
              if (tasks.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: GroupTaskEmptyState(
                    message: _config.emptyMessage,
                    hint: _config.emptyHint,
                    accent: _config.accent,
                    icon: _config.icon,
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final task = tasks[index];
                      return GroupTaskListTile(
                        task: task,
                        accent: _config.accent,
                        onComplete: () => _toggleComplete(task),
                        onDelete: () => _deleteTask(task),
                      );
                    },
                    childCount: tasks.length,
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          );
        },
      ),
    );
  }
}

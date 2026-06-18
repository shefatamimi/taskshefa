import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_shefa/group_task/group_screens/group_task_ui.dart';
import 'package:task_shefa/task/task_model/task_model.dart';
import 'package:task_shefa/task/task_service/task_service.dart';

class CustimizeGroup extends StatefulWidget {
  final String groupId;

  const CustimizeGroup({super.key, required this.groupId});

  @override
  State<CustimizeGroup> createState() => _CustimizeGroupState();
}

class _CustimizeGroupState extends State<CustimizeGroup> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TaskService _taskService = TaskService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late Stream<List<TaskModel>> _taskStream;
  late String _userId;

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
    _taskStream = _taskService.getTasksByGroup(_userId, widget.groupId);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _clearFields() {
    _titleController.clear();
    _descriptionController.clear();
  }

  Future<void> _showAddTaskDialog() async {
    _clearFields();
    await showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: GroupTaskUi.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(GroupTaskUi.radiusLg),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'New task',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color:Colors.black,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  style: const TextStyle(
                    color: Colors.black,
                    height: 1.4,
                  ),
                  controller: _titleController,
                  decoration: groupTaskFieldDecoration(
                    'Task title',
                    Icons.task_alt_outlined,
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 14),
                TextField(
                  style: const TextStyle(
                    color: Colors.black,
                    height: 1.4,
                  ),


                  controller: _descriptionController,
                  decoration: groupTaskFieldDecoration(
                    'Description (optional)',
                    Icons.notes_outlined,
                  ),
                  maxLines: 2,
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          _clearFields();
                          Navigator.pop(dialogContext);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: GroupTaskUi.textSecondary,
                          side: const BorderSide(color: GroupTaskUi.divider),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(GroupTaskUi.radiusSm),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () async {
                          final title = _titleController.text.trim();
                          if (title.isEmpty) {
                            showGroupTaskSnackBar(
                              dialogContext,
                              'Please enter a task title',
                              isError: true,
                            );
                            return;
                          }
                          try {
                            await _taskService.addTask(
                              TaskModel(
                                id: null,
                                title: title,
                                description:
                                    _descriptionController.text.trim(),
                                dueDate: DateTime.now(),
                                priority: 'None',
                                isCompleted: false,
                                userId: _userId,
                                groupId: widget.groupId,
                                alert: '',
                              ),
                            );
                            if (!dialogContext.mounted) return;
                            Navigator.pop(dialogContext);
                            _clearFields();
                            if (!mounted) return;
                            showGroupTaskSnackBar(context, 'Task added');
                          } catch (e) {
                            if (!dialogContext.mounted) return;
                            showGroupTaskSnackBar(
                              dialogContext,
                              'Failed to add task: $e',
                              isError: true,
                            );
                          }
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: GroupTaskUi.group,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(GroupTaskUi.radiusSm),
                          ),
                        ),
                        child: const Text('Add'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<TaskModel> _openTasks(List<TaskModel> tasks) =>
      tasks.where((t) => !t.isCompleted).toList();

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

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTaskDialog,
        elevation: 4,
        backgroundColor: GroupTaskUi.group,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Add task',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: StreamBuilder<List<TaskModel>>(
        stream: _taskStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: GroupTaskUi.group),
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

          final tasks = _openTasks(snapshot.data ?? []);

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: GroupTaskListHeader(
                  eyebrow: 'Group',
                  title: 'Group tasks',
                  subtitle: 'Tasks in this folder',
                  accent: GroupTaskUi.group,
                  softColor: GroupTaskUi.groupSoft,
                  gradient: const [GroupTaskUi.group, Color(0xFF6D28D9)],
                  icon: Icons.folder_rounded,
                  taskCount: tasks.length,
                ),
              ),
              if (tasks.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: GroupTaskEmptyState(
                    message: 'No tasks in this group',
                    hint: 'Tap "Add task" to create your first one',
                    accent: GroupTaskUi.group,
                    icon: Icons.folder_open_outlined,
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final task = tasks[index];
                      return GroupTaskListTile(
                        task: task,
                        accent: GroupTaskUi.group,
                        onComplete: () => _toggleComplete(task),
                        onDelete: () => _deleteTask(task),
                      );
                    },
                    childCount: tasks.length,
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        },
      ),
    );
  }
}

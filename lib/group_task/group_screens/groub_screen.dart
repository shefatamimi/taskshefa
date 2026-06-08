import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_shefa/group_task/group_model/group_model.dart';
import 'package:task_shefa/group_task/group_screens/Low_priority_screen.dart';
import 'package:task_shefa/group_task/group_screens/custimize_group.dart';
import 'package:task_shefa/group_task/group_screens/high_priority_screen.dart';
import 'package:task_shefa/group_task/group_screens/medium_preiority_screen.dart';
import 'package:task_shefa/group_task/group_screens/widgets/header_icon_button_widget.dart';
import 'package:task_shefa/group_task/group_screens/widgets/overview_card_widget.dart';
import 'package:task_shefa/group_task/group_service/group_service.dart';
import 'package:task_shefa/setting/screens/notification_screen.dart';
import 'package:task_shefa/setting/screens/setting_screen.dart';
import 'package:task_shefa/task/task_model/task_model.dart';
import 'package:task_shefa/task/task_screen/my_tasks_screen.dart';
import 'package:task_shefa/group_task/group_screens/group_task_ui.dart';
import 'package:task_shefa/task/task_service/task_service.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final TaskService _taskService = TaskService();
  final GroupService _groupService = GroupService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late Stream<List<TaskModel>> _taskStream;
  late Stream<List<GroupModel>> _groupsStream;
  late String _userId;

  @override
  void initState() {
    super.initState();
    final user = _auth.currentUser;
    if (user == null) {
      _userId = '';
      _taskStream = const Stream.empty();
      _groupsStream = const Stream.empty();
      return;
    }
    _userId = user.uid;
    _taskStream = _taskService.getTasks(_userId);
    _groupsStream = _groupService.getGroups(_userId);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  List<TaskModel> _tasksForPriority(List<TaskModel> tasks, String priority) {
    return tasks
        .where((task) => task.priority == priority && !task.isCompleted)
        .toList();
  }

  double _priorityProgress(List<TaskModel> tasks, String priority) {
    if (tasks.isEmpty) return 0;
    return _tasksForPriority(tasks, priority).length / tasks.length;
  }

  int _priorityPercent(List<TaskModel> tasks, String priority) {
    if (tasks.isEmpty) return 0;
    return (_priorityProgress(tasks, priority) * 100).round();
  }

  List<TaskModel> _tasksForGroup(List<TaskModel> tasks, String? groupId) {
    if (groupId == null || groupId.isEmpty) return [];
    return tasks.where((task) => task.groupId == groupId).toList();
  }

  double _groupCompletionProgress(List<TaskModel> groupTasks) {
    if (groupTasks.isEmpty) return 0;
    final completed =
        groupTasks.where((task) => task.isCompleted).length;
    return completed / groupTasks.length;
  }

  int _openTaskCount(List<TaskModel> tasks) =>
      tasks.where((t) => !t.isCompleted).length;

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    showGroupTaskSnackBar(context, message, isError: isError);
  }

  void _clearDialogFields() {
    _titleController.clear();
    _descriptionController.clear();
  }

// فتح نافذه اضافه او تعديل قروب
  Future<void> _showGroupFormDialog({
    required String title,// new group   or edit group
    required String actionLabel, // create or save
    required Future<void> Function() onSubmit,//
  }) async {
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
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: GroupTaskUi.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _titleController,
                  decoration: groupTaskFieldDecoration(
                      'Group name', Icons.folder_outlined),
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 14),
                TextField(
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
                          _clearDialogFields();
                          Navigator.pop(dialogContext);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: GroupTaskUi.textSecondary,
                          side: const BorderSide(color: GroupTaskUi.divider),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(GroupTaskUi.radiusSm),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () async {
                          try {
                            await onSubmit();
                            if (!dialogContext.mounted) return;
                            Navigator.pop(dialogContext);
                            _clearDialogFields();
                          } catch (_) {}
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: GroupTaskUi.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(GroupTaskUi.radiusSm),
                          ),
                        ),
                        child: Text(actionLabel),
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

  // اختصينا بنافذه اضافه القروب وحطينا التفاصيل تبعها
  void showAddGroupDialog() {
    _clearDialogFields();
    _showGroupFormDialog(
      title: 'New group',
      actionLabel: 'Create',
      onSubmit: () async {
        final title = _titleController.text.trim();
        if (title.isEmpty) {
          _showSnackBar('Please enter a group title', isError: true);
          return;
        }
        await _groupService.addGroup(
          GroupModel(
            id: null,
            title: title,
            description: _descriptionController.text.trim(),
            userId: _userId,
          ),
        );
        _showSnackBar('Group created');
      },
    );
  }

  // اختصينا بنافذه بتعجيل القروب وحطينا التفاصيل تبعه
  void _showEditGroupDialog(GroupModel group) {
    _titleController.text = group.title;
    _descriptionController.text = group.description;
    _showGroupFormDialog(
      title: 'Edit group',
      actionLabel: 'Save',
      onSubmit: () async {
        final title = _titleController.text.trim();
        if (title.isEmpty) {
          _showSnackBar('Please enter a group title', isError: true);
          return;
        }
        await _groupService.updateGroup(
          group.id!,
          GroupModel(
            id: group.id,
            userId: group.userId,
            title: title,
            description: _descriptionController.text.trim(),
          ),
        );
        _showSnackBar('Group updated');
      },
    );
  }
// نافذه حذف القروب
  Future<void> _confirmDeleteGroup(GroupModel group) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(GroupTaskUi.radiusLg),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: GroupTaskUi.highSoft,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.delete_outline, color: GroupTaskUi.high, size: 28),
              ),
              const SizedBox(height: 16),
              const Text(
                'Delete group?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: GroupTaskUi.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '"${group.title}" will be removed permanently.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: GroupTaskUi.textSecondary, height: 1.4),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(dialogContext, false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(GroupTaskUi.radiusSm),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.pop(dialogContext, true),
                      style: FilledButton.styleFrom(
                        backgroundColor: GroupTaskUi.high,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(GroupTaskUi.radiusSm),
                        ),
                      ),
                      child: const Text('Delete'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    if (confirmed != true || group.id == null) return;
    try {
      await _groupService.deleteGroup(group.id!);
      _showSnackBar('Group deleted');
    } catch (e) {
      _showSnackBar('Failed to delete group: $e', isError: true);
    }
  }

// العناوين
  Widget _sectionHeader({
    required String title,
    required String subtitle,
    IconData? trailingIcon,
    VoidCallback? onTrailingTap,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(GroupTaskUi.hPad, 8, GroupTaskUi.hPad, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: GroupTaskUi.textPrimary,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: GroupTaskUi.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          if (trailingIcon != null)
            Material(
              color: GroupTaskUi.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(GroupTaskUi.radiusSm),
              ),
              elevation: 0,
              child: InkWell(
                onTap: onTrailingTap,
                borderRadius: BorderRadius.circular(GroupTaskUi.radiusSm),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(GroupTaskUi.radiusSm),
                    border: Border.all(color: GroupTaskUi.divider),
                  ),
                  child: Icon(trailingIcon, size: 20, color: GroupTaskUi.textSecondary),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _progressBar(double value, Color color) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(99),
      child: SizedBox(
        height: 6,
        child: LinearProgressIndicator(
          value: value.clamp(0.0, 1.0),
          backgroundColor: GroupTaskUi.divider,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ),
    );
  }

// هي الicon تم استعملها بال  all task container and customize groub
  Widget _iconBadge({
    required IconData icon,
    required List<Color> gradient,
    double size = 48,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: gradient.last.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: size * 0.48),
    );
  }

  Widget _modernCard({
    required Widget child,
    required Color accent,
    Color? background,
    VoidCallback? onTap,
    EdgeInsetsGeometry margin = const EdgeInsets.symmetric(
      horizontal: GroupTaskUi.hPad,
      vertical: 6,
    ),
  }) {
    return Padding(
      padding: margin,
      child: Material(
        color: background ?? GroupTaskUi.surface,
        elevation: 0,
        shadowColor: accent.withValues(alpha: 0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(GroupTaskUi.radiusLg),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(GroupTaskUi.radiusLg),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(GroupTaskUi.radiusLg),
              boxShadow: GroupTaskUi.cardShadow(accent),
              border: Border.all(
                color: accent.withValues(alpha: 0.08),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: child,
            ),
          ),
        ),
      ),
    );
  }

// ui of  all group container priority card
  Widget buildPriorityCard({
    required String title,
    required String description,
    required Color color,
    required Color softColor,
    required List<Color> gradient,
    required IconData icon,
    required Widget screen,
    required String priority,
  }) {
    return _modernCard(
      accent: color,
      background: softColor,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: StreamBuilder<List<TaskModel>>(
        stream: _taskStream,
        builder: (context, snapshot) {
          final tasks = snapshot.data ?? [];
          final priorityTasks = _tasksForPriority(tasks, priority);
          final percent = _priorityPercent(tasks, priority);
          final progress = _priorityProgress(tasks, priority);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _iconBadge(icon: icon, gradient: gradient),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: GroupTaskUi.textPrimary,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          description,
                          style: const TextStyle(
                            fontSize: 12,
                            color: GroupTaskUi.textSecondary,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      '$percent%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: color.withValues(alpha: 0.7),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${priorityTasks.length} open tasks',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: GroupTaskUi.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _progressBar(progress, color),
            ],
          );
        },
      ),
    );
  }
// ui of customize group container
  Widget _buildGroupCard(GroupModel group, List<TaskModel> allTasks) {
    final groupTasks = _tasksForGroup(allTasks, group.id);
    final completionPercent =
        (_groupCompletionProgress(groupTasks) * 100).round();
    final progress = _groupCompletionProgress(groupTasks);

    return _modernCard(
      accent: GroupTaskUi.group,
      background: GroupTaskUi.groupSoft,
      onTap: () {
        if (group.id == null) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CustimizeGroup(groupId: group.id!),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _iconBadge(
                icon: Icons.folder_rounded,
                gradient: const [GroupTaskUi.group, Color(0xFF6D28D9)],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: GroupTaskUi.textPrimary,
                      ),
                    ),
                    if (group.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        group.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: GroupTaskUi.textSecondary,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              _groupActionButton(
                icon: Icons.edit_outlined,
                color: GroupTaskUi.primary,
                onPressed: () => _showEditGroupDialog(group),
              ),
              const SizedBox(width: 4),
              _groupActionButton(
                icon: Icons.delete_outline,
                color: GroupTaskUi.high,
                onPressed: () => _confirmDeleteGroup(group),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${groupTasks.length} tasks',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: GroupTaskUi.textSecondary,
                ),
              ),
              Text(
                '$completionPercent% complete',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: GroupTaskUi.group,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _progressBar(progress, GroupTaskUi.group),
        ],
      ),
    );
  }
 // icon edit + delete
  Widget _groupActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: 20, color: color),
        ),
      ),
    );
  }
// ui of all task container
  Widget _buildTotalTasksCard() {
    return _modernCard(
      accent: GroupTaskUi.primary,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MyTasks()),
        );
      },
      child: StreamBuilder<List<TaskModel>>(
        stream: _taskStream,
        builder: (context, snapshot) {
          final tasks = snapshot.data ?? [];
          final open = _openTaskCount(tasks);

          return Row(
            children: [
              _iconBadge(
                icon: Icons.checklist_rounded,
                gradient: const [GroupTaskUi.primary, GroupTaskUi.primaryDark],
                size: 52,
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'All tasks',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: GroupTaskUi.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'View everything in one place',
                      style: TextStyle(
                        fontSize: 12,
                        color: GroupTaskUi.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(
                    '${tasks.length}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: GroupTaskUi.primary,
                      height: 1,
                    ),
                  ),
                  Text(
                    '$open open',
                    style: const TextStyle(
                      fontSize: 11,
                      color: GroupTaskUi.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.chevron_right_rounded,
                color: GroupTaskUi.primary,
              ),
            ],
          );
        },
      ),
    );
  }

// ui of empty groups hint of customize group
  Widget _buildEmptyGroupsHint() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: GroupTaskUi.hPad, vertical: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: GroupTaskUi.surface,
          borderRadius: BorderRadius.circular(GroupTaskUi.radiusMd),
          border: Border.all(
            color: GroupTaskUi.divider,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.create_new_folder_outlined,
              size: 36,
              color: GroupTaskUi.textSecondary.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 10),
            const Text(
              'No custom groups yet',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: GroupTaskUi.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Tap + to organize tasks into folders',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: GroupTaskUi.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  // ui of scaffold
  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: GroupTaskUi.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: showAddGroupDialog,
        elevation: 4,
        backgroundColor: GroupTaskUi.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'New group',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: GroupTaskUi.surface,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  GroupTaskUi.hPad,
                  topPadding + 12,
                  GroupTaskUi.hPad,
                  20,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Dashboard',
                            style: TextStyle(
                              fontSize: 13,
                              color: GroupTaskUi.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Task overview',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: GroupTaskUi.textPrimary,
                              letterSpacing: -0.8,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    HeaderIconButton(
                      icon: Icons.notifications_none_rounded,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotificationScreen(),
                          ),
                        );

                        

                      },
                    ),
                    const SizedBox(width: 8),
                    HeaderIconButton(
                      icon: Icons.settings_outlined,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          // ui of overview card container =>OverviewCardWidget
          SliverToBoxAdapter(
            child: StreamBuilder<List<TaskModel>>(
              stream: _taskStream,
              builder: (context, snapshot) {
                final tasks = snapshot.data ?? [];
                return OverviewCardWidget(tasks: tasks,);
              },
            ),
          ),
          SliverToBoxAdapter(
            child: _sectionHeader(
              title: 'By priority',
              subtitle: 'Focus on what matters most',
            ),
          ),

          SliverToBoxAdapter(
            child: buildPriorityCard(
              title: 'High priority',
              description: 'Needs immediate attention',
              color: GroupTaskUi.high,
              softColor: GroupTaskUi.highSoft,
              gradient: const [GroupTaskUi.high, Color(0xFFE63946)],
              icon: Icons.flag_rounded,
              screen: const HighPriorityScreen(),
              priority: 'High',
            ),
          ),
          SliverToBoxAdapter(
            child: buildPriorityCard(
              title: 'Medium priority',
              description: 'Complete soon',
              color: GroupTaskUi.medium,
              softColor: GroupTaskUi.mediumSoft,
              gradient: const [GroupTaskUi.medium, Color(0xFFE67E22)],
              icon: Icons.schedule_rounded,
              screen: const MediumPreiorityScreen(),
              priority: 'Medium',
            ),
          ),
          SliverToBoxAdapter(
            child: buildPriorityCard(
              title: 'Low priority',
              description: 'Schedule for later',
              color: GroupTaskUi.low,
              softColor: GroupTaskUi.lowSoft,
              gradient: const [GroupTaskUi.low, Color(0xFF1ABC9C)],
              icon: Icons.trending_down_rounded,
              screen: const LowPriorityScreen(),
              priority: 'Low',
            ),
          ),
          SliverToBoxAdapter(
            child: _sectionHeader(
              title: 'Your groups',
              subtitle: 'Custom folders for your tasks',
            ),
          ),
          //  build customize group container
          StreamBuilder<List<GroupModel>>(
            stream: _groupsStream,
            builder: (context, groupSnapshot) {
              if (!groupSnapshot.hasData || groupSnapshot.data!.isEmpty) {
                return SliverToBoxAdapter(child: _buildEmptyGroupsHint());
              }
              return StreamBuilder<List<TaskModel>>(
                stream: _taskStream,
                builder: (context, taskSnapshot) {
                  final tasks = taskSnapshot.data ?? [];
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return _buildGroupCard(
                          groupSnapshot.data![index],
                          tasks,
                        );
                      },
                      childCount: groupSnapshot.data!.length,
                    ),
                  );
                },
              );
            },
          ),

          SliverToBoxAdapter(
            child: _sectionHeader(
              title: 'Quick access',
              subtitle: 'See every task in one list',
            ),
          ),
          // build all task container
          SliverToBoxAdapter(child: _buildTotalTasksCard()),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

}

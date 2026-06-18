import 'package:flutter/material.dart';
import 'package:task_shefa/task/task_model/task_model.dart';

/// Shared design tokens for group task screens.
abstract final class GroupTaskUi {
  static const background = Color(0xFFF4F6FB);
  static const surface = Colors.white;
  static const primary = Color(0xFF4F6BED);
  static const primaryDark = Color(0xFF3D56C7);
  static const textPrimary = Color(0xFF1E2433);
  static const textSecondary = Color(0xFF6B7280);
  static const divider = Color(0xFFE8ECF4);

  static const high = Color(0xFFFF5A5F);
  static const highSoft = Color(0xFFFFECEE);
  static const medium = Color(0xFFFF9F43);
  static const mediumSoft = Color(0xFFFFF4E8);
  static const low = Color(0xFF2ECC9A);
  static const lowSoft = Color(0xFFE8FBF4);
  static const group = Color(0xFF8B5CF6);
  static const groupSoft = Color(0xFFF3EEFF);

  static const radiusLg = 24.0;
  static const radiusMd = 16.0;
  static const radiusSm = 12.0;
  static const hPad = 20.0;

  static List<BoxShadow> cardShadow(Color tint) => [
        BoxShadow(
          color: tint.withValues(alpha: 0.12),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ];

  static Color priorityColor(String priority) => switch (priority) {
        'High' => high,
        'Medium' => medium,
        'Low' => low,
        _ => textSecondary,
      };

  static String formatDueDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(date.year, date.month, date.day);
    final diff = due.difference(today).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    if (diff == -1) return 'Yesterday';
    if (diff < 0) return '${-diff}d overdue';
    if (diff < 7) return 'In $diff days';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}';
  }
}

void showGroupTaskSnackBar(
  BuildContext context,
  String message, {
  bool isError = false,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(GroupTaskUi.radiusSm),
      ),
      margin: const EdgeInsets.all(16),
      content: Text(message),
      backgroundColor:
          isError ? const Color(0xFFE53935) : GroupTaskUi.textPrimary,
    ),
  );
}

InputDecoration groupTaskFieldDecoration(String label, IconData icon) {
  return InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon, size: 22, color: GroupTaskUi.textSecondary),
    filled: true,
    fillColor: GroupTaskUi.background,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(GroupTaskUi.radiusSm),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(GroupTaskUi.radiusSm),
      borderSide: const BorderSide(color: GroupTaskUi.divider),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(GroupTaskUi.radiusSm),
      borderSide: const BorderSide(color: GroupTaskUi.primary, width: 1.5),
    ),
  );
}

class GroupTaskListHeader extends StatelessWidget {
  const GroupTaskListHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.softColor,
    required this.gradient,
    required this.icon,
    required this.taskCount,
  });

  final String eyebrow;
  final String title;
  final String subtitle;
  final Color accent;
  final Color softColor;
  final List<Color> gradient;
  final IconData icon;
  final int taskCount;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;

    return Container(
      decoration: const BoxDecoration(
        color: GroupTaskUi.surface,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              GroupTaskUi.hPad,
              topPadding + 8,
              GroupTaskUi.hPad,
              16,
            ),
            child: Row(
              children: [
                _BackButton(accent: accent),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        eyebrow,
                        style: const TextStyle(
                          fontSize: 13,
                          color: GroupTaskUi.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: GroupTaskUi.textPrimary,
                          letterSpacing: -0.5,
                          height: 1.15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              GroupTaskUi.hPad,
              0,
              GroupTaskUi.hPad,
              20,
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: softColor,
                borderRadius: BorderRadius.circular(GroupTaskUi.radiusLg),
                border: Border.all(color: accent.withValues(alpha: 0.12)),
              ),
              child: Row(
                children: [
                  _IconBadge(icon: icon, gradient: gradient),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subtitle,
                          style: const TextStyle(
                            fontSize: 13,
                            color: GroupTaskUi.textSecondary,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$taskCount open ${taskCount == 1 ? 'task' : 'tasks'}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: accent,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: GroupTaskUi.background,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () => Navigator.maybePop(context),
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(Icons.arrow_back_rounded, color: accent, size: 22),
        ),
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.icon, required this.gradient});

  final IconData icon;
  final List<Color> gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
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
      child: Icon(icon, color: Colors.white, size: 24),
    );
  }
}

class GroupTaskEmptyState extends StatelessWidget {
  const GroupTaskEmptyState({
    super.key,
    required this.message,
    required this.hint,
    required this.accent,
    this.icon = Icons.task_alt_outlined,
  });

  final String message;
  final String hint;
  final Color accent;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: accent.withValues(alpha: 0.7)),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: GroupTaskUi.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              hint,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: GroupTaskUi.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GroupTaskListTile extends StatelessWidget {
  const GroupTaskListTile({
    super.key,
    required this.task,
    required this.accent,
    required this.onComplete,
    required this.onDelete,
    this.onUpdated,

  });

  final TaskModel task;
  final Color accent;
  final VoidCallback onComplete;
  final VoidCallback onDelete;
  final VoidCallback? onUpdated;



  @override
  Widget build(BuildContext context) {
    final priorityColor = GroupTaskUi.priorityColor(task.priority);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: GroupTaskUi.hPad,
        vertical: 6,
      ),
      child: Material(
        color: GroupTaskUi.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(GroupTaskUi.radiusLg),
        ),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(GroupTaskUi.radiusLg),
            boxShadow: GroupTaskUi.cardShadow(accent),
            border: Border.all(color: accent.withValues(alpha: 0.08)),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Material(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: onComplete,
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Icon(
                        Icons.check_rounded,
                        color: accent,
                        size: 22,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: GroupTaskUi.textPrimary,
                          letterSpacing: -0.2,
                        ),
                      ),
                      if (task.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          task.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            color: GroupTaskUi.textSecondary,
                            height: 1.35,
                          ),
                        ),
                      ],
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _MetaChip(
                            icon: Icons.calendar_today_outlined,
                            label: GroupTaskUi.formatDueDate(task.dueDate),
                            color: accent,
                          ),
                          if (task.priority != 'None') ...[
                            const SizedBox(width: 8),
                            _MetaChip(
                              icon: Icons.flag_outlined,
                              label: task.priority,
                              color: priorityColor,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: GroupTaskUi.high.withValues(alpha: 0.85),
                  ),
                  tooltip: 'Delete task',
                ),
                const SizedBox(width: 8),
                if (onUpdated != null)
                IconButton(
                  onPressed: onUpdated,
                  icon: Icon(
                    Icons.edit,
                    color: GroupTaskUi.high.withValues(alpha: 0.85),
                  ),
                  tooltip: 'Update task',
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

Future<bool?> showDeleteTaskDialog(BuildContext context, String taskTitle) {
  return showDialog<bool>(
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
              decoration: const BoxDecoration(
                color: GroupTaskUi.highSoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_outline,
                color: GroupTaskUi.high,
                size: 28,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Delete task?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.blueAccent,

              ),
            ),
            const SizedBox(height: 8),
            Text(
              '"$taskTitle" will be removed permanently.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: GroupTaskUi.textSecondary,
                height: 1.4,
              ),
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
                    onPressed: () => Navigator.pop(dialogContext, true),
                    style: FilledButton.styleFrom(
                      backgroundColor: GroupTaskUi.high,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(GroupTaskUi.radiusSm),
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
}

Future<bool?> showUpdateTaskDialog(BuildContext context, String taskTitle) {
  return showDialog<bool>(
    context: context,
    builder: (dialogContext) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(GroupTaskUi.radiusLg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column( children: [
          CircleAvatar(
          radius: 70,
          child: Icon(
            Icons.drive_file_rename_outline,
            size: 70,
          )
      ),

        TextFormField(
          decoration: InputDecoration(
            labelText: 'Title',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Due Date',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Priority',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Alert',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            // Handle save button press
          },
          child: Text('Save'),
        ),
        SizedBox(height: 16),

        ]
        ),
      ),
    ),
  );
}

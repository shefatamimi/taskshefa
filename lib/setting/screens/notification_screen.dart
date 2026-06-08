import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_shefa/task/task_model/task_model.dart';
import 'package:task_shefa/task/task_service/task_service.dart';
import 'package:task_shefa/users/models/user_models.dart';
import 'package:task_shefa/users/service/user_service.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final TaskService taskService = TaskService();
  final UserService userService = UserService();
  final auth = FirebaseAuth.instance;

  UserModel? userModel;
  late Stream<List<TaskModel>> taskStream;

  String userId = "";

  @override
  void initState() {
    super.initState();

    final user = auth.currentUser;

    if (user == null) {
      taskStream = const Stream.empty();
      return;
    }

    userId = user.uid;

    loadUser();
    getTasks();
  }

  Future<void> loadUser() async {
    final user = await userService.getUser(userId);

    if (!mounted) return;

    setState(() {
      userModel = user;
    });
  }

  Future<void> getTasks() async {

    setState(() {
      taskStream = taskService.getTasks(userId);
    });
  }

  DateTime getStartDateTime(TaskModel task) {
    if (task.startTime == null) return task.dueDate;

    try {
      final clean = task.startTime!.trim();

      final parts = clean.split(":");

      if (parts.length != 2) return task.dueDate;

      final hour = int.tryParse(parts[0]);
      final minute = int.tryParse(parts[1]);

      if (hour == null || minute == null) return task.dueDate;

      return DateTime(
        task.dueDate.year,
        task.dueDate.month,
        task.dueDate.day,
        hour,
        minute,
      );
    } catch (e) {
      return task.dueDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        centerTitle: true,
      ),
      body: StreamBuilder<List<TaskModel>>(
        stream: taskStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No notifications"));
          }


          final now = DateTime.now();

          final tasks = snapshot.data!.where((task) {
            if (task.alert == 'None') return false;

            final start = getStartDateTime(task);
// وقت نوتيفيكشن قبل بدايه المهمه ب5د او 10د
            final notifyTime = start.subtract(
              Duration(
                minutes: task.alert == '10 Minutes' ? 10 : 5,
              ),
            );
// النوتيفيكشن يظهر قبل بدايه المهمه ب5 د اة 10د وختفي في حاله بدأ المهمه
            return  now.isAfter(notifyTime) && now.isBefore(start);
          }).toList();





          if (tasks.isEmpty) {
            return const Center(child: Text("No notifications"));
          }


          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];

              final start = getStartDateTime(task);

              final notifyTime = start.subtract(Duration(minutes: task.alert == '10 Minutes' ? 10 : 5,),
              );

              return notificationTile(
                title: task.title,
                body: task.description,
                isRead: task.isCompleted,
                time: notifyTime.toString(), // ✔ الآن صح
              );
            },
          );
        },
      ),
    );
  }

  Widget notificationTile({
    required String title,
    required String body,
    required String time,
    required bool isRead,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isRead ? Colors.grey[200] : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: isRead ? Colors.grey : Colors.blue,
            child: const Icon(
              Icons.notifications,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight:
                    isRead ? FontWeight.normal : FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          if (!isRead)
            const Icon(
              Icons.circle,
              size: 10,
              color: Colors.red,
            ),
        ],
      ),
    );
  }
}
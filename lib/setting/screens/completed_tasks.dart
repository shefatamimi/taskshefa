import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_shefa/group_task/group_screens/group_task_ui.dart';
import 'package:task_shefa/task/task_model/task_model.dart';
import 'package:task_shefa/task/task_service/task_service.dart';
import 'package:task_shefa/users/models/user_models.dart';
import 'package:task_shefa/users/service/user_service.dart';
class CompletedTasks extends StatefulWidget {

  const CompletedTasks({super.key});

  @override
  State<CompletedTasks> createState() => _CompletedTasksState();

}

class _CompletedTasksState extends State<CompletedTasks> {
  final TaskService taskService = TaskService();
  final auth = FirebaseAuth.instance;
  late final user = auth.currentUser;
  final UserService userService = UserService();
  late String userId = user!.uid;
  UserModel? userModel;
  late Stream<List<TaskModel>> taskStream;

  Future <void> loadUser() async {
    final user = await userService.getUser(userId);
    if (!mounted) return;
    setState(() {
      userModel = user;
    });
  }
  Future<void> deleteTask(String taskId) async {
    final shouldDelete = await showDeleteTaskDialog(context, 'Task');
    if (shouldDelete == true) {
      taskService.deleteTask(taskId);
      setState(() {
        taskStream = taskService.getTasks(userId);
      });
    }

  }
  Future<void> changestatues(TaskModel task) async {
    final updatedTask = TaskModel(
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
    await taskService.updateTask(task.id!, updatedTask);
  }
  Future <void> getTasks() async {
    taskStream = taskService.getTasks(userId);


  }
  @override
  void initState() {
    super.initState();
    final user = auth.currentUser;

    if (user == null) {

      taskStream = const Stream.empty();
      userId = "";
      return;
    }

    userId = user.uid;

    loadUser();
    getTasks();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Tasks'),
        centerTitle: true,
      ),
      body:Column(
        children: [
          const SizedBox(height: 20),

          const Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Project',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'See All',
                  style: TextStyle(color: Colors.blueGrey),
                ),
              ],
            ),
          ),

          Expanded(
            child: StreamBuilder<List<TaskModel>>(
              stream: taskStream,

              builder: (context, snapshot) {
                var tasks = snapshot.data ?? [];
                tasks = tasks.where((task) => task.isCompleted).toList();

                if (tasks.isEmpty) {
                  return const Center(
                    child: Text('No Completed Tasks'),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return GroupTaskListTile(
                      task: task,
                      accent: GroupTaskUi.primary,
                      onComplete: () {
                        changestatues(task);
                      },
                      onDelete: () {
                        deleteTask(task.id!);
                      },
                    );






                  },
                );
              },
            ),
          ),
        ],
      ),

    );
  }
}

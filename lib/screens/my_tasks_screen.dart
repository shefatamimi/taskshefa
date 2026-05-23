import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_shefa/screens/add_task.dart';
import 'package:task_shefa/task/task_model/task_model.dart';
import 'package:task_shefa/task/task_service/task_service.dart';
import 'package:task_shefa/users/models/user_models.dart';
import 'package:task_shefa/users/service/user_service.dart';

class MyTasks extends StatefulWidget {
  const MyTasks({super.key,});

  @override
  State<MyTasks> createState() => _MyTasksState();
}

class _MyTasksState extends State<MyTasks> {
  final TaskService taskService = TaskService();
  final UserService userService = UserService();
  final FirebaseAuth auth = FirebaseAuth.instance;

  UserModel? userModel;
  late String userId;
  late Stream<List<TaskModel>> taskStream;

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
    taskStream = taskService.getTasks(userId);
  }

  Future<void> loadUser() async {
    final user = await userService.getUser(userId);

    if (!mounted) return;

    setState(() {
      userModel = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello ${userModel?.name ?? "..."}'),
        centerTitle: true,
      ),

      body: Column(
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
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final tasks = snapshot.data ?? [];

                if (tasks.isEmpty) {
                  return const Center(child: Text('No tasks found'));
                }

                return ListView.separated(
                  itemCount: tasks.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final task = tasks[index];


                    return Column(
                      children: [
                        SizedBox(height: 20,),
                                Text(task.dueDate.toString()),
                          ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(task.title),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(task.description),
                          ),

                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
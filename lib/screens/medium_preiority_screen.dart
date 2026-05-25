import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_shefa/task/task_model/task_model.dart';
import 'package:task_shefa/task/task_service/task_service.dart';
import 'package:task_shefa/users/models/user_models.dart';
import 'package:task_shefa/users/service/user_service.dart';


class MediumPreiorityScreen extends StatefulWidget {
  const MediumPreiorityScreen({super.key});

  @override
  State<MediumPreiorityScreen> createState() => _MediumPreiorityScreenState();

}

class _MediumPreiorityScreenState extends State<MediumPreiorityScreen> {
  late String userId;

  final TaskService taskService = TaskService();
  final auth = FirebaseAuth.instance;
  late final user = auth.currentUser;
  final UserService userService = UserService();
  UserModel? userModel;
  late Stream<List<TaskModel>> taskStream;


  Future<void> loadUser() async {
    final user = await userService.getUser(userId);
    if (!mounted) return;
    setState(() {
      userModel = user;
    });
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
    );
    await taskService.updateTask(task.id!, updatedTask);
  }
  Future<void> deleteTask(String taskId) async {
    await taskService.deleteTask(taskId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Task deleted successfully')),
    );
    Navigator.pop(context);
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
    taskStream = taskService.getTasks(userId);
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
                var tasks = snapshot.data ?? [];
                tasks = tasks.where((task) => task.priority == 'Medium').toList();

                if (tasks.isEmpty) {
                  return const Center(
                    child: Text('No Medium Priority Tasks'),
                  );
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(onPressed: (){
                              changestatues(task);

                    }, icon: Icon(
                              task.isCompleted
                                  ? Icons.check_circle
                                  : Icons.check_circle_outline,
                              color:
                              task.isCompleted
                                  ? Colors.green
                                  : Colors.grey,
                              size: 30,
                            ),
                            ),
                            IconButton(onPressed: (){
                              deleteTask(task.id!);

                            }, icon: Icon(Icons.delete)),

                      ],
                    )
                      ],
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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_shefa/group_task/group_model/group_model.dart';
import 'package:task_shefa/group_task/group_service/group_service.dart';
import 'package:task_shefa/task/task_model/task_model.dart';
import 'package:task_shefa/task/task_service/task_service.dart';
import 'package:task_shefa/users/models/user_models.dart';
import 'package:task_shefa/users/service/user_service.dart';
class CustimizeGroup extends StatefulWidget {
  final String groupId;
  const CustimizeGroup({super.key, required this.groupId});

  @override
  State<CustimizeGroup> createState() => _CustimizeGroupState();
}

class _CustimizeGroupState extends State<CustimizeGroup> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TaskService taskService = TaskService();
  final auth = FirebaseAuth.instance;
  late final user = auth.currentUser;
  final UserService userService = UserService();
  late String userId = user!.uid;
  final GroupService groupService = GroupService();
  late GroupModel group;
  late String groupId = widget.groupId;



  UserModel? userModel;
  late Stream<List<TaskModel>> taskStream;
  final date = DateTime.now();
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
      groupId: task.groupId,
    );
    await taskService.updateTask(task.id!, updatedTask);
  }
  Future<void> deleteTask(String taskId) async {
    await taskService.deleteTask(taskId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Task deleted successfully')),
    );
  }
  void showAddGroupDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Task"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: "Description"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed
              : () async {
                try {

                  final newTask = TaskModel(
                    id: null,
                    title: _titleController.text,
                    description: _descriptionController.text,
                    dueDate: date,
                    priority: 'None',
                    isCompleted: false,
                    userId: userId,
                    groupId: widget.groupId,
                    alert: '',
                  );
                  await taskService.addTask(newTask);
                  Navigator.pop(context);
                  print("ADDED SUCCESSFULLY");
                } catch (e) {
                  print("ERROR: $e");
                }
              }
              ,
              child: Text("Add"),
            ),
          ],
        );
      },
    );

  }
  @override
  void initState()
  {
    super.initState();
    final user = auth.currentUser;
    if (user == null) {
      taskStream = const Stream.empty();
      userId = "";
      return;
    }
    userId = user.uid;

    loadUser();
    taskStream = taskService.getTasksByGroup(userId, widget.groupId);

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Group'),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddGroupDialog();
        },
        child: const Icon(Icons.add),
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

                if (tasks.isEmpty) {
                  return const Center(
                    child: Text('No Assigned Tasks'),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
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

                            ]
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

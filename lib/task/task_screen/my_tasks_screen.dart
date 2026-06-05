import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_shefa/auth/screen/navigator_screen.dart';
import 'package:task_shefa/group_task/group_screens/group_task_ui.dart';
import 'package:task_shefa/task/task_model/task_model.dart';
import 'package:task_shefa/task/task_screen/add_task.dart';
import 'package:task_shefa/task/task_screen/edit_task_screen.dart';
import 'package:task_shefa/task/task_service/task_service.dart';
import 'package:task_shefa/users/models/user_models.dart';
import 'package:task_shefa/users/service/user_service.dart';

class MyTasks extends StatefulWidget {

  const MyTasks({super.key});

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

  final color_completed = Colors.grey;

   Future<void> changeStatus(TaskModel task) async {
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
    taskService.updateTask(task.id!, updatedTask);
    }




 Future<void> deleteTask(TaskModel task) async {
    final shouldDelete = await showDeleteTaskDialog(context, task.title);
    if (shouldDelete == true) {
      taskService.deleteTask(task.id!);
      setState(() {
        taskStream = taskService.getTasks(userId);
      });
    }


   }

   void sortTasksByDate() {
    setState(() {
      taskStream = taskService.getTasks(userId);
      taskStream = taskStream.map((tasks) {
        tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
        return tasks;
      });

    });
  }
  void sortTasksByTitle() {
    setState(() {
      taskStream = taskService.getTasks(userId);
      taskStream = taskStream.map((tasks) {
        tasks.sort((a, b) => a.title.compareTo(b.title));
        return tasks;
      });

    });
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
        title: const Text('My Tasks'),
        backgroundColor: GroupTaskUi.background,

        leading: IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NavigatorScreen()

                )
            );

          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),


      backgroundColor: GroupTaskUi.background,
      body: Column(
        children: [
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Project',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: () {
                    showDialog(context: context, builder: (context) {
                      return AlertDialog(
                        title: Text('Sort Tasks',),
                        content: Text('Select a sorting option:'),
                        actions: [
                          TextButton(

                            onPressed: () async {
                              setState(() {
                                sortTasksByDate();
                              });


                              Navigator.pop(context,true);
                            },
                            child: Text('sort by date',style: TextStyle(
                              color:  GroupTaskUi.primary,
                              fontWeight: FontWeight.bold,
                            ),),
                          ),


                            TextButton(
                          onPressed: () async {
                            setState(() {
                              sortTasksByTitle();


                            });

                            Navigator.pop(context,true);
                          },
                          child: Text('sort A-z',style: TextStyle(
                            color:  GroupTaskUi.primary,
                            fontWeight: FontWeight.bold,)
                      )
                                                    )
                        ],
                      );
                    },

                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                      'Sort by',
                      style: TextStyle(color: GroupTaskUi.primaryDark,),
                    ),
                  ),
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

                final tasks = (snapshot.data ?? [])
                    .where((task) => !task.isCompleted)
                    .toList();

                if (tasks.isEmpty) {
                    return const GroupTaskEmptyState(
                      message: 'No tasks found',
                      hint: 'Create your first task',
                      accent: GroupTaskUi.primary,
                    );
                  }

                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return GroupTaskListTile(
                      task: task,
                      accent: GroupTaskUi.primary,
                      onComplete: () {
                        changeStatus(task);
                      },
                      onDelete: () {
                        deleteTask(task);
                      },
                      onUpdated: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditTaskScreen(task: task)),
                        );
                      },

                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton:FloatingActionButton.extended(
        backgroundColor: GroupTaskUi.primary,
        foregroundColor: Colors.white,
        label: const Text('Add Task'), onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()));


      },
      )
    );
  }
}
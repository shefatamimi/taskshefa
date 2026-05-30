import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_shefa/group_task/group_screens/groub_screen.dart';
import 'package:task_shefa/task/task_model/task_model.dart';
import 'package:task_shefa/task/task_screen/add_task.dart';
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

  void updateTask(TaskModel task) {
    taskService.updateTask(task.id!, task);
    setState(() {
      taskStream = taskService.getTasks(userId);
      if (task.isCompleted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task Completed'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task Not Completed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

  }


  void deleteTask(TaskModel task) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete Task'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                taskService.deleteTask(task.id!);
                setState(() {
                  taskStream = taskService.getTasks(userId);
                });
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        ),
    );

    setState(() {
      taskStream = taskService.getTasks(userId);
    });

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
        title: Text('Hello ${userModel?.name ?? "..."}'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GroubScreen(groupId: '',)

            )
            );

          },
          icon: Icon(Icons.arrow_back),
        )
      ),

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
                        title: Text('Sort Tasks'),
                        content: Text('Select a sorting option:'),
                        actions: [
                          TextButton(

                            onPressed: () async {
                              setState(() {
                                sortTasksByDate();
                              });


                              Navigator.pop(context,true);
                            },
                            child: Text('sort by date'),
                          ),


                            TextButton(
                          onPressed: () async {
                            setState(() {
                              sortTasksByTitle();


                            });

                            Navigator.pop(context,true);
                          },
                          child: Text('sort A-z')
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
                      style: TextStyle(color: Colors.blueGrey),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                        IconButton(
                          onPressed: () async {{
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Task Completed'),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 1),

                              ),
                            );
                            await Future.delayed(const Duration(seconds: 1));

                            await changeStatus(task);
                            }


                          },

                          icon: Icon(
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
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            deleteTask(task);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Task Deleted'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          },
                        ),
                            IconButton(
                              onPressed: () {
                                //shefa

                              }, icon: Icon(
                                Icons.edit,

                            )
                            )
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

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen(

            )),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
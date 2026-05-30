import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_shefa/group_task/group_model/group_model.dart';
import 'package:task_shefa/group_task/group_screens/Low_priority_screen.dart';
import 'package:task_shefa/group_task/group_screens/custimize_group.dart';
import 'package:task_shefa/group_task/group_screens/high_priority_screen.dart';
import 'package:task_shefa/group_task/group_screens/medium_preiority_screen.dart';
import 'package:task_shefa/group_task/group_service/group_service.dart';
import 'package:task_shefa/setting/screens/setting_screen.dart';
import 'package:task_shefa/task/task_model/task_model.dart';
import 'package:task_shefa/task/task_screen/my_tasks_screen.dart';
import 'package:task_shefa/task/task_service/task_service.dart';
import 'package:task_shefa/users/models/user_models.dart';
import 'package:task_shefa/users/service/user_service.dart';

class GroubScreen extends StatefulWidget {
  final String groupId;
  const GroubScreen({super.key, required this.groupId});

  @override
  State<GroubScreen> createState() => _GroubScreenState();
}

class _GroubScreenState extends State<GroubScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final TaskService taskService = TaskService();
  final UserService userService = UserService();
  final FirebaseAuth auth = FirebaseAuth.instance;

  UserModel? userModel;

  late Stream<List<TaskModel>> taskStream;
  late Stream<List<GroupModel>> groupsStream;

  final date = DateTime.now();

  late final user = auth.currentUser;
  late final String userId = user!.uid;
  final List _tasks = [];

  Future<void> loadUser() async {
    final user = await userService.getUser(userId);

    if (!mounted) return;

    setState(() {
      userModel = user;
    });
  }


  double countHighPriorityTasks(List<TaskModel> tasks, String priority) {


    final highTasks = tasks
        .where((task) => task.priority == priority&&task.isCompleted==false)
        .toList();
    print(highTasks);

    return tasks.isEmpty
        ? 0.0
        : highTasks.length / tasks.length;

  }





  @override
  void initState() {
    super.initState();

    loadUser();

    taskStream = taskService.getTasks(userId);
    groupsStream = GroupService().getGroups(userId);
    _tasks.add( taskStream);

  }

  void showAddGroupDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Group"),
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
        onPressed: () async {
        try {
        final newGroup = GroupModel(
        id: null,
        title: _titleController.text,
        description: _descriptionController.text,
        userId: userId,
        );

        await GroupService().addGroup(newGroup);
        Navigator.pop(context);

        print("ADDED SUCCESSFULLY");

        } catch (e) {
        print("ERROR: $e");
        }
        },

        child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  Widget buildPriorityCard({
    required String title,
    required String description,
    required Color color,
    required IconData icon,
    required Widget screen,
    required String priority,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => screen,
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color,
            width: 2,
          ),
          color: Color(0xFFFFF5F5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Container(
                  height: 55,
                  width: 55,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                  ),
                ),

                SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight:
                          FontWeight.bold,
                          color: color,
                        ),
                      ),

                      SizedBox(height: 4),

                      Text(
                        "Important tasks that need immediate attention",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),

                Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Colors.grey,
                ),
              ],
            ),

            SizedBox(height: 16),

            Row(

              children: [
                StreamBuilder<List<TaskModel>>(
                  stream: taskStream,
                  builder: (context, snapshot) {
                    final tasks = snapshot.data ?? [];
                    final highPriorityTasks = tasks
                        .where((task) => task.priority == priority && task.isCompleted==false)
                        .toList();
                    return Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,


                      children: [
                        Text(
                          "${highPriorityTasks.length}",
                          style: TextStyle(
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 230),
                        Text(
                          "${(highPriorityTasks.length / tasks.length * 100).toStringAsFixed(0)}%",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),

                      ],
                    );


                  },


                )
              ],
            ),

            SizedBox(height: 8),

            StreamBuilder<List<TaskModel>>(
              stream: taskStream,
              builder: (context, snapshot) {

                final tasks = snapshot.data ?? [];

                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: countHighPriorityTasks(tasks, priority),
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      color,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Group'),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications_none_sharp,
            ),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    SettingScreen(),
              ),
            );
          },
          icon: Icon(Icons.menu),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),

            Padding(
              padding: EdgeInsets.only(
                left: 10,
                top: 10,
              ),
              child: Text(
                'Your Task by Priority',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight:
                  FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),

            Padding(
              padding:
              const EdgeInsets.only(
                left: 10,
                top: 5,
              ),
              child: Text(
                'Organize and track your tasks by priority level.',
              ),
            ),

            SizedBox(height: 10),

            buildPriorityCard(
              title: "High Priority",
              description:
              "Important tasks",
              color: Colors.red,
              icon: Icons.flag,
              screen: HighPriorityScreen(),
              priority: 'High',

            ),

            buildPriorityCard(
              title: "Medium Priority",
              description:
              "Important tasks",
              color: Colors.orange,
              icon:
              Icons.access_time_rounded,
              screen:
              MediumPreiorityScreen(),
              priority: 'Medium',

            ),

            buildPriorityCard(
              title: "Low Priority",
              description:
              "Important tasks",
              color: Colors.green,
              icon:
              Icons.access_time_rounded,
              screen: LowPriorityScreen(),
              priority: 'Low',
            ),

            SizedBox(height: 10),

            StreamBuilder<List<GroupModel>>(
              stream: groupsStream,
              builder:
                  (context, snapshot) {
                if (!snapshot.hasData ||
                    snapshot.data!.isEmpty) {
                  return SizedBox();
                }

                final groups =
                snapshot.data!;


                return Column(
                  children:
                  groups.map((group) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            CustimizeGroup(
                              groupId: group.id!,
                            ),
                          ),

                        );
                        GroupService()
                            .updateGroup(
                          group.id!,
                          GroupModel(
                            id: group.id,
                            userId: group.userId,
                            title: group.title,
                            description: group.description,
                          ),
                        );
                      },
                      child: Container(
                        margin:
                        EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        padding:
                        EdgeInsets.all(16),
                        decoration:
                        BoxDecoration(
                          borderRadius:
                          BorderRadius
                              .circular(20),
                          border: Border.all(
                            color:
                            Colors.purple,
                            width: 2,
                          ),
                          color:
                          Color(0xFFF7F5FF),
                        ),
                        child: Row(
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                          children: [
                            Container(
                              height: 55,
                              width: 55,
                              decoration:
                              BoxDecoration(
                                color: Colors
                                    .purple,
                                borderRadius:
                                BorderRadius
                                    .circular(
                                    12),
                              ),
                              child: Icon(
                                Icons.folder,
                                color:
                                Colors.white,
                              ),

                            ),




                            SizedBox(
                                width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                                children: [
                                  Text(
                                    group.title,
                                    style:
                                    TextStyle(
                                      fontSize:
                                      18,
                                      fontWeight:
                                      FontWeight
                                          .bold,
                                    ),
                                  ),

                                  SizedBox(
                                      height:
                                      4),

                                  Text(
                                    group
                                        .description,
                                    style:
                                    TextStyle(
                                      fontSize:
                                      13,
                                      color: Colors
                                          .black54,
                                    ),
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,


                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text("Edit Group"),
                                                content: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    TextField(

                                                      controller: _titleController,

                                                      decoration: InputDecoration(labelText: "title"),
                                                    ),
                                                    TextField(
                                                      controller: _descriptionController,

                                                      decoration: InputDecoration(labelText: "Description"),
                                                    ),
                                                  ],
                                                ),


                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("Cancel"),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      try {
                                                        final updatedGroup = GroupModel(
                                                          id: group.id,
                                                          userId: group.userId,
                                                          title: _titleController.text,
                                                          description: _descriptionController.text,
                                                        );
                                                        await GroupService().updateGroup(
                                                          group.id!,
                                                          updatedGroup,
                                                        );
                                                        Navigator.pop(context);
                                                      } catch (e) {
                                                        print("ERROR: $e");
                                                      }
                                                    },
                                                    child: Text("Save"),

                                                  )

                                                ],
                                              );
                                            },
                                          );
                                          GroupService()
                                              .updateGroup(
                                            group.id!,
                                            GroupModel(
                                              id: group.id,
                                              userId: group.userId,
                                              title: group.title,
                                              description: group.description,
                                            ),
                                          );
                                        },
                                        icon: Icon(
                                          Icons.edit,
                                          color: Colors.blue,
                                          size: 30,
                                        ),
                                      ),
                                      IconButton(

                                        onPressed: () {
                                          GroupService()
                                              .deleteGroup(
                                            group.id!,
                                          );
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                          size: 30,

                                        ),
                                      ),


                                    ],
                                  ),

                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "8 Tasks",
                                        style: TextStyle(
                                          fontWeight:
                                          FontWeight.w600,
                                        ),
                                      ),

                                      Text(
                                        "80%",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight:
                                          FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 8),

                                  ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(10),
                                    child: LinearProgressIndicator(
                                      value: 0.8,
                                      minHeight: 8,
                                      backgroundColor:
                                      Colors.grey.shade300,
                                      valueColor:
                                      AlwaysStoppedAnimation<Color>(
                                        Colors.grey,
                                      ),
                                    ),
                                  ),



                                ],

                              ),
                            ),

                            Icon(
                              Icons
                                  .arrow_forward_ios,
                              size: 18,
                              color:
                              Colors.grey,
                            ),



                          ],
                        ),


                      ),
                    );
                  }).toList(),

                );
              },
            ),

            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MyTasks(

                        ),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.circular(
                      20),
                  border: Border.all(
                    color: Colors.blueAccent,
                    width: 2,
                  ),
                  color: Color(0xFFFFF5F5),
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
                  children: [
                    Row(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                      children: [
                        Container(
                          height: 55,
                          width: 55,
                          decoration:
                          BoxDecoration(
                            color: Colors.blue,
                            borderRadius:
                            BorderRadius
                                .circular(
                                12),
                          ),
                          child: Icon(
                            Icons.task,
                            color:
                            Colors.white,
                          ),
                        ),

                        SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                            children: [
                              Text(
                                "Total Tasks",
                                style:
                                TextStyle(
                                  fontSize:
                                  18,
                                  fontWeight:
                                  FontWeight
                                      .bold,
                                  color: Colors
                                      .black87,
                                ),
                              ),

                              SizedBox(
                                  height: 4),

                              Text(
                                "All tasks across all priorities",
                                style:
                                TextStyle(
                                  fontSize:
                                  13,
                                  color: Colors
                                      .black54,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(width: 12),

                        StreamBuilder<List<TaskModel>>(
                          stream: taskStream,

                          builder: (context, snapshot) {

                            final tasks = snapshot.data ?? [];

                            return CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.blue,
                              child: Text(
                                "${tasks.length}",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,


                                ),
                              ),
                            );
                          },
                        ),
                      ],

                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      floatingActionButton:
      FloatingActionButton(
        onPressed: () {
          showAddGroupDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
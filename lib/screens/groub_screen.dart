import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_shefa/screens/Low_priority_screen.dart';
import 'package:task_shefa/screens/add_task.dart';
import 'package:task_shefa/screens/high_priority_screen.dart';
import 'package:task_shefa/screens/medium_preiority_screen.dart';
import 'package:task_shefa/screens/my_tasks_screen.dart';
import 'package:task_shefa/task/task_model/task_model.dart';
import 'package:task_shefa/task/task_service/task_service.dart';
import 'package:task_shefa/users/models/user_models.dart';
import 'package:task_shefa/users/service/user_service.dart';
class GroubScreen extends StatefulWidget {
  const GroubScreen({super.key});

  @override
  State<GroubScreen> createState() => _GroubScreenState();
}

class _GroubScreenState extends State<GroubScreen> {
  final TaskService taskService = TaskService();
  final UserService userService = UserService();
  final FirebaseAuth auth = FirebaseAuth.instance;
  UserModel? userModel;

  late Stream<List<TaskModel>> taskStream;
  final date = DateTime.now();
  late final user = auth.currentUser;
  late final String userId = user!.uid;

  Future<void> loadUser() async {
    final user = await userService.getUser(userId);
    if (!mounted) return;
    setState(() {
      userModel = user;
    });
  }
  @override
  void initState() {
    super.initState();
    loadUser();
    taskStream = taskService.getTasks(userId);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Group',),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.notifications_none_sharp)),
        ],
        leading: IconButton(onPressed: (){}, icon: Icon(Icons.menu)),
        centerTitle: true,
      ),
      body:SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            Padding(
              padding:  EdgeInsets.only(left: 10,top:10),
              child: Text('Your Task by Priority',style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
        
              ),),
            ),
        
            Padding(
              padding: const EdgeInsets.only(left: 10,top: 5),
              child: Text('Organize and track your tasks by priority level.'),
            ),
            SizedBox(height: 10,),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HighPriorityScreen()),
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.redAccent, width: 2),
                  color: Color(0xFFFFF5F5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // icon box
                        Container(
                          height: 55,
                          width: 55,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.flag, color: Colors.white),
                        ),

                        SizedBox(width: 12),

                        // text section
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "High Priority",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
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

                        Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
                      ],
                    ),

                    SizedBox(height: 16),

                    // progress + tasks count
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "8 Tasks",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "80%",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 8),

                    // progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: 0.8,
                        minHeight: 8,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        
            SizedBox(height: 10,),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MediumPreiorityScreen()),
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.orangeAccent, width: 2),
                  color: Color(0xFFFFF5F5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // icon box
                        Container(
                          height: 55,
                          width: 55,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.access_time_rounded, color: Colors.white),
                        ),

                        SizedBox(width: 12),

                        // text section
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Medium Priority",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
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

                        Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
                      ],
                    ),

                    SizedBox(height: 16),

                    // progress + tasks count
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "8 Tasks",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "80%",
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 8),

                    // progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: 0.8,
                        minHeight: 8,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                      ),
                    ),

                  ],
                ),
              ),
            ),
        
            SizedBox(height: 10,),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LowPriorityScreen()),
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.greenAccent, width: 2),
                  color: Color(0xFFFFF5F5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // icon box
                        Container(
                          height: 55,
                          width: 55,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.access_time_rounded, color: Colors.white),
                        ),

                        SizedBox(width: 12),

                        // text section
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Low Priority",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
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

                        Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
                      ],
                    ),

                    SizedBox(height: 16),

                    // progress + tasks count
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "8 Tasks",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "80%",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 8),

                    // progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: 0.8,
                        minHeight: 8,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                    ),

                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyTasks()),
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blueAccent, width: 2),
                  color: Color(0xFFFFF5F5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // icon box
                        Container(
                          height: 55,
                          width: 55,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.task, color: Colors.white),
                        ),
                        SizedBox(width: 12),




                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Total Tasks",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "All tasks across all priorities",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),

                        ),
                        SizedBox(width: 12),

                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.blue,
                          child: Text('25',style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,

                          ),),
                        ),
                        ],
                      )
                  ],
              ),
                        ),
            ),
        ],
            ),
      ),
    );
  }
}

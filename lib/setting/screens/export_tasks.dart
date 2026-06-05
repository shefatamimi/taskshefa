import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_shefa/group_task/group_screens/group_task_ui.dart';
import 'package:task_shefa/group_task/group_service/group_service.dart';
import 'package:task_shefa/setting/service/export_service.dart';
import 'package:task_shefa/task/task_model/task_model.dart';
import 'package:task_shefa/task/task_service/task_service.dart';
import 'package:task_shefa/users/models/user_models.dart';
import 'package:task_shefa/users/service/user_service.dart';
class ExportTasksScreen extends StatefulWidget {

  const ExportTasksScreen({super.key});

  @override
  State<ExportTasksScreen> createState() => _ExportTasksScreenState();

}

class _ExportTasksScreenState extends State<ExportTasksScreen> {

  final user = FirebaseAuth.instance.currentUser;
  late var userId = user!.uid;
  late Stream<List<TaskModel>> taskStream;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final TaskService taskService = TaskService();
  final GroupService groupService = GroupService();
  final UserService userService = UserService();
  UserModel? userModel;




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



  String selectedFormat = '';
  bool allTasks = false;
  bool completedTasks = false;
  bool incompleteTasks = false;
  bool dueDate = false;
  List<TaskModel> tasks = [];





  Widget Export_tasks(String title, String subtitle, IconData icon,String value) {
    return Center(
      child: Container(
        height: 50,
        width: 350,
        decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),

            ]
        ),
        child: Row(
          children: [
            SizedBox(width: 10,),
            Icon(icon, size: 30,),

            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8),
                    child: Text('$title', style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8),
                    child: Text('$subtitle', style: TextStyle(
                      fontSize: 10,
                    ),),
                  ),
                ]
            ),
            SizedBox(width: 110,),
            Spacer(),
            Radio<String>(
                value: value,
                groupValue: selectedFormat,
                onChanged: (value) {
                  setState(() {
                    selectedFormat = value!;
                  });
            }),

          ],
        ),
      ),
    );
  }

  Widget cheack_box(
      String title,
      bool value,
      Function(bool) onChanged,
      ) {
    return Row(
      children: [
        SizedBox(width: 10),

        GestureDetector(
          onTap: () {
            onChanged(!value);
          },
          child: Icon(
            value
                ? Icons.check_box
                : Icons.check_box_outline_blank,
            size: 30,
            color: GroupTaskUi.primaryDark,
          ),
        ),

        SizedBox(width: 10),

        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
        AppBar(
          title: Text('Export Tasks'),

        ),
        body:Padding(
          padding:  EdgeInsets.all(8.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Center(child: Icon(Icons.upload_file_sharp, size: 120)),
                SizedBox(height: 20,),
                Center(
                  child: Text('Export Tasks', style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),),
                ),
                SizedBox(height: 10,),
                Center(
                  child: Text('choose the format you want to export your tasks to', style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      height: 1.5
                  ),),
                ),
                SizedBox(height: 20,),
                Export_tasks('Export as PDF', 'save your tasks as a PDF file', Icons.picture_as_pdf,'PDF'),
                SizedBox(height: 20,),
                Export_tasks('Export as Excel', 'save your tasks as an Excel file', Icons.table_chart,'Excel'),
                SizedBox(height: 20,),
                Export_tasks('Export as CSV', 'save your tasks as a CSV file', Icons.dataset,'CSV'),
                SizedBox(height: 10,),
                Text('Include',style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey
                  ,)),
                SizedBox(height: 10,),
                Container(
                  height: 170,
                  width: 350,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),


                      ]
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                      cheack_box('All Tasks', allTasks, (value) {
                        setState(() {
                          allTasks = value;
                        });
                      }),
                      SizedBox(height: 10,),
                      cheack_box('Completed Tasks', completedTasks, (value) {
                        setState(() {
                          completedTasks = value;
                        });
                      }),
                      SizedBox(height: 10,),
                      cheack_box('Incomplete Tasks', incompleteTasks, (value) {
                        setState(() {
                          incompleteTasks = value;
                        });
                      }),
                      SizedBox(height: 10,),
                      cheack_box('Due Date', dueDate, (value) {
                        setState(() {
                          dueDate = value;
                        });
                      }),
                      SizedBox(height: 10,),

                    ],

                  ),



                ),
                SizedBox(height: 20,),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(250, 50),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.black38),
                      ),
                    ),

                      onPressed: () async {

                          final tasks = await taskService.getTasks(userId).first;

                          List<TaskModel> filteredTasks = [];

                          if (allTasks) {
                            filteredTasks = tasks;
                          } else if (completedTasks) {
                            filteredTasks = tasks.where((t) => t.isCompleted == true).toList();
                          } else if (incompleteTasks) {
                            filteredTasks = tasks.where((t) => t.isCompleted == false).toList();
                          } else {
                            filteredTasks = tasks;
                          }

                          if (dueDate) {
                            filteredTasks = filteredTasks.where((t) => t.dueDate != null).toList();
                          }
                          await generatePdf(filteredTasks);







                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("PDF exported successfully")),
                          );
                                              },



                    child: Text('Export',style: TextStyle(
                    color:GroupTaskUi.primaryDark,
                    fontWeight: FontWeight.bold,

                    fontSize: 30,
                  )
                  ),
                  ),
                )


              ]
          ),
        )
    );
  }
}
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_shefa/auth/screen/login_screen.dart';
import 'package:task_shefa/group_task/group_screens/group_task_ui.dart';
import 'package:task_shefa/setting/screens/about_app_screen.dart';
import 'package:task_shefa/setting/screens/backup_tasks_screen.dart';
import 'package:task_shefa/setting/screens/export_tasks.dart';
import 'package:task_shefa/setting/widget_setting/widget_container.dart';

import 'package:task_shefa/task/task_service/task_service.dart';
import 'package:task_shefa/users/models/user_models.dart';
import 'package:task_shefa/users/service/user_service.dart';
import 'package:task_shefa/users/users_screen/edit_profil_screen.dart';
import 'package:task_shefa/setting/screens/completed_tasks.dart';
class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();

}

class _SettingScreenState extends State<SettingScreen> {

  final FirebaseAuth auth = FirebaseAuth.instance;
  final UserService userService = UserService();
  final TaskService taskService = TaskService();
  UserModel? userModel;
  late final user = auth.currentUser;
   late String userId = user!.uid;





  Future<void> loadUser() async {
    final user = await userService.getUser(userId);

    if (!mounted) return;
    setState(() {
      userModel = user;


    });
  }
  Future<void>deletAllTasks() async {
    final shouldDelete = await showDeleteTaskDialog(context, 'Task');
    if (shouldDelete == true) {
      taskService.deleteAllTasks();
    }

  }


  @override
  void initState() {
    super.initState();
    loadUser();

  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          color: GroupTaskUi.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
      ),
      body:SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              SizedBox(height: 10,),
              Center(
                child: Container(
                  height: 75,
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
                      SizedBox(height: 25,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Welcome ${userModel?.name ?? "..."}', style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,

                          ),),
                          SizedBox(width: 8,),
                          Text('',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,

                            ),),
                          SizedBox(height: 20,),
                        ],
                      ),
                      SizedBox(height: 20,),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20,),
              sectionTitle('Account'),
              SizedBox(height: 10,),
              Center(
                  child: WidgetContainer(title: 'Profile',
                      subtitle: 'View and edit your profile',
                      icon: Icons.person, onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditProfil()),
                    );
                      })),


              SizedBox(height: 20,),
              sectionTitle('Appearance'),
              SizedBox(height: 10,),
              Center(
                child: WidgetContainer(title: 'Dark Mode',
                    subtitle: 'Enable dark mode', icon: Icons.dark_mode,
                    onTap: () {

                    })
              ),
              SizedBox(height: 10,),
              Center(
                child: WidgetContainer(title: 'Theme Color',
                    subtitle: 'Choose a theme color',
                    icon: Icons.color_lens, onTap: () {}),
              ),
              SizedBox(height: 10,),
              Center(
                child: WidgetContainer(title: 'Font Size',
                    subtitle: 'Adjust font size', icon: Icons.text_fields, onTap: () {

                    }),
              ),

              SizedBox(height: 20,),
              sectionTitle('Tasks'),
              SizedBox(height: 10,),
              Center(
                child: WidgetContainer(title: 'Completed Tasks',
                    subtitle: 'View completed tasks', icon: Icons.check_circle_outline, onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CompletedTasks()),
                  );
                }),
              ),
              SizedBox(height: 10,),
              Center(
                child: WidgetContainer(title: 'Export tasks',
                    subtitle: 'Export your tasks to a file', icon: Icons.upload_file_sharp, onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ExportTasksScreen()),
                  );
                    })
              ),
              SizedBox(height: 10,),
              sectionTitle('Backup & Storage'),
              SizedBox(height: 10,),
              Center(
                child: WidgetContainer(title: 'Backup Tasks',
                    subtitle: 'Backup your tasks', icon: Icons.backup_outlined, onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BackupScreen()),
                  );
                }),
              ),
              SizedBox(height: 10,),
              Center(
                child: WidgetContainer(title: 'Delete All Tasks',
                    subtitle: 'permanently delete all tasks', icon: Icons.delete_outline, onTap: () {
                  deletAllTasks();
                }),
              ),
              SizedBox(height: 10,), SizedBox(height: 10,),
              sectionTitle('Other'),
              SizedBox(height: 10,),
              Center(
                child: WidgetContainer(title: 'About App',
                    subtitle: 'Learn more about the app', icon: Icons.info_outline, onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutScreen()),
                  );
                }),
              ),
              SizedBox(height: 10,),
              Center(
                child: InkWell(
                  onTap: () {

                  },

                  child: WidgetContainer(title: 'Logout',
                      subtitle: 'Log out of your account',
                  icon: Icons.logout, onTap: () {
                    auth.signOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                })
                ),
              ),

            ]


        ),
      )


    );
  }
}

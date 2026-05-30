import 'package:flutter/material.dart';
import 'package:task_shefa/group_task/group_screens/groub_screen.dart';
import 'package:task_shefa/task/task_screen/my_tasks_screen.dart';
import 'package:task_shefa/users/users_screen/edit_profil_screen.dart';

class NavigatorScreen extends StatefulWidget {
   NavigatorScreen({super.key,});


  @override
  State<NavigatorScreen> createState() => _NavigatorScreenState();

}

class _NavigatorScreenState extends State<NavigatorScreen> {
  int currentindex = 0;

  late final screens = [
    GroubScreen(groupId: '',),
    MyTasks(),
    EditProfil(),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentindex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentindex,
        onTap: (index) => setState(() => currentindex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Group',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'My Tasks',
          ),

          BottomNavigationBarItem(icon: Icon(Icons.person),
            label: 'Profile',
          )
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

import 'package:task_shefa/screens/add_task.dart';
import 'package:task_shefa/screens/groub_screen.dart';
import 'package:task_shefa/screens/my_tasks_screen.dart';

class NavigatorScreen extends StatefulWidget {
   NavigatorScreen({super.key,});


  @override
  State<NavigatorScreen> createState() => _NavigatorScreenState();

}

class _NavigatorScreenState extends State<NavigatorScreen> {
  int currentindex = 0;

  late final screens = [
    GroubScreen(),
    MyTasks(),
    AddTaskScreen(),
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
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.settings),
            label: 'Settings',
          )
        ],
      ),
    );
  }
}
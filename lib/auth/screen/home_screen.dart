import 'package:flutter/material.dart';
import 'package:task_shefa/screens/navigator_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
        SingleChildScrollView(
          child: Column(

            children: [
              SizedBox(height: 150),
              Padding(
                padding: const EdgeInsets.only(left: 50, right: 50),
                child: Image.asset(
                  'assets/task.png',
                  width: 300,
                  height: 300,
                ),
              ),
              SizedBox(height: 50),
              Text(
                'Task Management & \nTo-Do List',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 10),

              Text(
                "This is a productivity tool designed to help you manage\n"
                    "your tasks and stay organized in a simple\n"
                    "and efficient way.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(250, 50),
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Colors.black38),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NavigatorScreen()),
                  );
                },
                child: Text('     Get Started      >',style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,

                ),),
              ),

            ] ,
          ),
        ),


    );
  }
}

import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About App"),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.task_alt,
                    size: 80,
                    color: Colors.blueGrey,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "TaskShefa",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Version 1.0.0",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            Text(
              "About the App",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            Text(
              "TaskShefa is a simple task management application that helps users organize their daily tasks, track progress, and manage priorities efficiently.",
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),

            SizedBox(height: 20),

            Text(
              "Features",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 10),

            featureItem("Create and manage tasks easily"),
            featureItem("Organize tasks by priority"),
            featureItem("Track progress visually"),
            featureItem("Custom task groups"),
            featureItem("Simple and clean UI"),
            featureItem("Firebase real-time sync"),

            Spacer(),

            Center(
              child: Text(
                "Made with ❤️ using Flutter",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget featureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 18),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
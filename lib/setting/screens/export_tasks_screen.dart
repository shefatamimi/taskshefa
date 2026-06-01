import 'package:flutter/material.dart';
class ExportTasksScreen extends StatefulWidget {
  const ExportTasksScreen({super.key});

  @override
  State<ExportTasksScreen> createState() => _ExportTasksScreenState();
}

class _ExportTasksScreenState extends State<ExportTasksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
        AppBar(
        title: Text('Export Tasks'),
        centerTitle: true,
      ),
      body:Center(
        child: Column(


          children: [
            SizedBox(height: 50,),
            Icon(Icons.file_upload, size: 100),
            SizedBox(height: 20,),
            Text('Export Tasks', style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),),
            SizedBox(height: 10,),
            Text('choose the format you want to export your tasks to', style: TextStyle(
                fontSize: 12,
                color: Colors.black54,
                height: 1.5
            ),),
            SizedBox(height: 20,),
            Container(
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
                  Icon(Icons.picture_as_pdf, size: 30,),

                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8),
                          child: Text('Export as PDF', style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8),
                          child: Text('save your tasks as a PDF file', style: TextStyle(
                            fontSize: 10,
                          ),),
                        ),
                      ]
                  ),
                  SizedBox(width: 160,),
                  Icon(Icons.arrow_forward_ios, size: 20),




                ],
              ),
            ),




            ]
        ),
      )
    );
  }
}

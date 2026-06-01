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

      ),
      body:Padding(
        padding:  EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            SizedBox(height: 40,),
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
            Center(
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
                    SizedBox(width: 110,),
                    Radio(value: '', groupValue: '', onChanged: (value){
                      setState(() {
                        value = value;
                        if(value == ''){
                          value = 'PDF';
                          print(value);

                        }
                      });
                    }),

                  ],
                ),
              ),
            ),

            SizedBox(height: 20,),
            Center(
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
                    Icon(Icons.table_chart, size: 30,),

                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8),
                            child: Text('Export as Excel', style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8),
                            child: Text('save your tasks as an Excel file', style: TextStyle(
                              fontSize: 10,
                            ),),
                          ),
                        ]
                    ),
                    SizedBox(width: 100,),
                    Radio(value: '', groupValue: '', onChanged: (value){
                      setState(() {
                        value = value;
                        if(value == ''){
                          value = 'Excel';
                          print(value);

                        }
                      });
                    }),

                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
            Center(
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
                    Icon(Icons.dataset, size: 30,),

                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8),
                            child: Text('Export as CSV', style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8),
                            child: Text('save your tasks as a CSV file', style: TextStyle(
                              fontSize: 10,
                            ),),
                          ),
                        ]
                    ),
                    SizedBox(width: 110,),
                    Radio(value: '', groupValue: '', onChanged: (value){
                      setState(() {
                        value = value;
                        if(value == ''){
                          value = 'Excel';
                          print(value);

                        }
                      });
                    }),

                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
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
                  Row(

                    children: [
                      SizedBox(width: 10,),
                      Icon(Icons.check_box_outlined, size: 30,),
                      SizedBox(width: 10,),
                      Text('All Tasks', style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),),
                      SizedBox(width: 1
                      ),


                    ]
                   ),
                  SizedBox(height: 10,),

                  Row(
                      children: [
                        SizedBox(width: 10,),
                        Icon(Icons.check_box_outlined, size: 30,),
                        SizedBox(width: 10,),
                        Text('Completed Tasks', style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),),
                        SizedBox(width: 1
                        ),


                      ]
                  ),
                  SizedBox(height: 10,),
                  Row(
                      children: [
                        SizedBox(width: 10,),
                        Icon(Icons.check_box_outlined, size: 30,),
                        SizedBox(width: 10,),
                        Text('uncompleted Tasks', style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),),
                        SizedBox(width: 1
                        ),
                      ]
                  ),
                  SizedBox(height: 10,),
                  Row(
                      children: [
                        SizedBox(width: 10,),
                        Icon(Icons.check_box_outlined, size: 30,),
                        SizedBox(width: 10,),
                        Text('Due Date', style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),),
                        SizedBox(width: 1
                        ),


                      ]
                  ),
                  SizedBox(height: 10,),



                ],
              ),



            )

            ]
        ),
      )
    );
  }
}

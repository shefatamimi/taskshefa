import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_shefa/setting/service/backup_service.dart';

class BackupScreen extends StatefulWidget {
  const BackupScreen({super.key});

  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Backup & Restore',style: TextStyle(color: Colors.black87),),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios,color: Colors.black87,),
        ),
      ),
      body:
      Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 33),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('Backup',style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),),
            ),
            SizedBox(height: 10,),
            Center(
              child: Container(
                height: 150,
                width:330,
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
                child:Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 20),
                        child: CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.blueGrey,
                          child: Icon(Icons.cloud_upload,size: 44,color: Colors.white,),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 40,right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Create Backup',style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87
                            )),
                            SizedBox(height: 10,),
                            Text('Create a backup of your tasks',style: TextStyle(
                                fontSize: 10,
                                color: Colors.black87

                            ),),
                            SizedBox(
                              height: 30,
                            ),

                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top:68),
                        child: Icon(Icons.arrow_forward_ios,size: 20),
                      ),


                    ]

                ),
              ),
            ),
            SizedBox(height: 5,),
            Center(
              child: Container(
                height: 50,
                width:330,
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
                child:Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 10),
                        child: Icon(Icons.access_time,color: Colors.black87,),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15,right: 30),
                        child: Text('No Backup Created',style: TextStyle(
                          fontSize: 12,

                          color: Colors.black45,
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () async{
                            try {
                              final userId = FirebaseAuth.instance.currentUser!.uid;
                              await BackupService.backupTasks(userId);
                              await BackupService.backupGroups(userId);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Backup created successfully'),
                                ),
                              );

                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Backup failed'),
                                ),
                              );
                            }


                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text('Backup Now',style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),),
                        ),
                      ),
                      SizedBox(height: 10,),

                    ]
                ),


              ),
            ),
            SizedBox(height: 55,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('Restore',style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),),
            ),
            SizedBox(height: 10,),
            Center(
              child: Container(
                height: 150,
                width:330,
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
                child:Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 20),
                        child: CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.blueGrey,
                          child: Icon(Icons.cloud_download,size: 44,color: Colors.white,),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 40,right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,


                          children: [
                            Text('Restore Backup',style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87
                            )),
                            SizedBox(height: 10,),
                            Text('Restore a backup of your tasks',style: TextStyle(
                                fontSize: 10,
                                color: Colors.black87

                            ),),
                            SizedBox(
                              height: 30,
                            ),

                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top:68),
                        child: Icon(Icons.arrow_forward_ios,size: 20),
                      ),


                    ]

                ),
              ),
            ),
            SizedBox(height: 10,),
            Center(
              child: Container(
                height: 50,
                width:330,
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
                child:Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 10),
                        child: Icon(Icons.insert_drive_file_rounded,color: Colors.black87,),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15,right: 40),
                        child: Text('No Backup Found',style: TextStyle(
                          fontSize: 12,

                          color: Colors.black45,
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () async{
                            try {
                              await BackupService.restoreTasks();
                              await BackupService.restoreGroups();



                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Restore completed successfully'),
                                ),
                              );

                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Restore failed'),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text('Restore Now',style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),),
                        ),
                      ),
                      SizedBox(height: 10,),

                    ]
                ),


              ),
            ),


          ]

      ),



    );
  }
}

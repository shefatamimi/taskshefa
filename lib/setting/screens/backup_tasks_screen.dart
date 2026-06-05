import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_shefa/group_task/group_screens/group_task_ui.dart';
import 'package:task_shefa/setting/service/backup_service.dart';

class BackupScreen extends StatefulWidget {
  const BackupScreen({super.key});

  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {

  Widget backup_restore(String title, String subtitle, IconData icon) {
    return Container(
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
                backgroundColor:GroupTaskUi.primary,
                child: Icon(icon,size: 44,color: Colors.white,),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40,right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$title',style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87
                  )),
                  SizedBox(height: 10,),
                  Text('$subtitle',style: TextStyle(
                      fontSize: 10,
                      color: Colors.black87

                  ),),
                  SizedBox(
                    height: 30,
                  ),

                ],
              ),
            ),
              Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Icon(Icons.arrow_forward_ios,size: 20)),
            ),


          ]

      ),
    );



  }



  Future<void> restoreData() async {
    try {
      await BackupService.restoreTasks();
      await BackupService.restoreGroups();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Restore completed successfully'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Restore failed'),
        ),
      );
    }
  }

  Future<void> backupData() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      await BackupService.backupTasks(userId);
      await BackupService.backupGroups(userId);



      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Backup completed successfully'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Backup failed'),
        ),
      );
    }
  }


  Widget back_restore_button(String title, String subtitle, IconData icon, {VoidCallback? onPressed}) {
    return Container(
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
              child: Icon(icon,size: 30,color: Colors.black87,),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15,right: 40),
              child: Text('$subtitle',style: TextStyle(
                fontSize: 12,

                color: Colors.black45,
              )),
            ),
           Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed:onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GroupTaskUi.primaryDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text('$title ',style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),),
                ),
              ),

            SizedBox(height: 10,),

          ]
      ),


    );
  }

  Widget sectionTitle(String title) {
    return
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text('$title',style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color:GroupTaskUi.primaryDark,
      ),),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Backup & Restore',style: TextStyle(color: Colors.black87),),
        backgroundColor: Colors.white,
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
            sectionTitle('Backup'),
            SizedBox(height: 10,),

            Center(
              child: backup_restore('Backup Tasks',
                  'Backup your tasks',
                  Icons.backup_outlined),
            ),
            SizedBox(height: 5,),
            Center(
              child: back_restore_button('Backup Now',
                  'Click to backup',
                  Icons.insert_drive_file_rounded,
                  onPressed: () {
                    backupData();
                  }
              ),
            ),
            SizedBox(height: 55,),
            sectionTitle('Restore'),
            SizedBox(height: 10,),
            Center(
              child: backup_restore('Restore Tasks',
                  'Restore your tasks',
                  Icons.restore_outlined),

            ),
            SizedBox(height: 10,),
            Center(
              child: back_restore_button('Restore Now',
                  'No Backup Found',
                  Icons.restore_outlined,
                  onPressed: () {
                    restoreData();
                  }
              ),
            ),


          ]

      ),

    );
  }
}

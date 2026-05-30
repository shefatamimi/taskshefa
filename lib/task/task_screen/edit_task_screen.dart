import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_shefa/task/task_model/task_model.dart';
import 'package:task_shefa/users/models/user_models.dart';
import 'package:task_shefa/users/service/user_service.dart';
import 'package:task_shefa/task/task_service/task_service.dart';

class EditTaskScreen extends StatefulWidget {
  final TaskModel task;
  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();

}

class _EditTaskScreenState extends State<EditTaskScreen> {


  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _priorityController;
  late TextEditingController _alertController;


  final TaskService taskService = TaskService();
  final auth = FirebaseAuth.instance;
  late final user = auth.currentUser;
  final UserService userService = UserService();
  late String userId = user!.uid;
  UserModel? userModel;

  Future<void> loadUser() async {
    final user = await userService.getUser(userId);
    if (!mounted) return;
    setState(() {
      userModel = user;

    });
  }
  Future <void> updateTask(TaskModel task) async {
    final updatedTask = TaskModel(
      id: task.id,
      title: _titleController.text,
      description: _descriptionController.text,
      dueDate: task.dueDate,
      priority: _priorityController.text,
      isCompleted: task.isCompleted,
      userId: task.userId,
      alert: _alertController.text,
      groupId: task.groupId,
    );
    await taskService.updateTask(task.id!, updatedTask);
    Navigator.pop(context);

  }
  @override
  void initState() {
    super.initState();

    final user = auth.currentUser;
    if (user == null) {
      userId = "";
      return;
    }
    userId = user.uid;

    loadUser();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
    _priorityController = TextEditingController(text: widget.task.priority);
    _alertController = TextEditingController(text: widget.task.alert);
  }
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priorityController.dispose();
    _alertController.dispose();
    super.dispose();
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task'),
        centerTitle: true,
      ),
      body:
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height: 50,),
                CircleAvatar(
                  backgroundColor: Colors.white54,
                  radius: 80,
                  child: Icon(
                    Icons.drive_file_rename_outline,
                    size: 120,
                    color: Colors.blueGrey,
                  )
                ),
                SizedBox(height: 40,),

                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Priority'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: Text('High'),
                                onTap: () {
                                  setState(() =>
                                  _priorityController.text = 'High');
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                title: Text('Medium'),
                                onTap: () {
                                  setState(() =>
                                  _priorityController.text = 'Medium');
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                title: Text('Low'),
                                onTap: () {
                                  setState(() =>
                                  _priorityController.text = 'Low');
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                title: Text('None'),
                                onTap: () {
                                  setState(() =>
                                  _priorityController.text = 'None');
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                     
                      readOnly: true,
                      controller: _priorityController,
                      decoration: InputDecoration(
                        labelText: 'Priority',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Alert'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: Text('None'),
                                onTap: () {
                                  setState(() =>
                                  _alertController.text = 'None');
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                title: Text('5 Minutes'),
                                onTap: () {
                                  setState(() =>
                                  _alertController.text = '5 Minutes');
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                title: Text('10 Minutes'),
                                onTap: () {
                                  setState(() =>
                                  _alertController.text = '10 Minutes');
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },

                  child: AbsorbPointer(
                    child: TextFormField(
                      readOnly: true,
                      controller: _alertController,
                      decoration: InputDecoration(
                        labelText: 'Alert',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50),
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
                    updateTask(widget.task);
                  },
                  child: Text('Save',style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,


                  ),),
                ),
                SizedBox(height: 16),

              ]

                    ),
          ),

        )
    );
  }
}

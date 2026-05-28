import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_shefa/task/task_model/task_model.dart';
import 'package:task_shefa/task/task_screen/my_tasks_screen.dart';
import 'package:task_shefa/task/task_service/task_service.dart';

class AddTaskScreen extends StatefulWidget {


  AddTaskScreen({super.key});

  final date = DateTime.now();

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  final taskService = TaskService();
  final auth = FirebaseAuth.instance;
  late final user = auth.currentUser;
  late final String userId = user!.uid;


  String alertValue = 'None';
  String priorityValue = 'None';

  Future<void> addTask() async {
    final task = TaskModel(
      id: null,
      title: _titleController.text,
      description: _descriptionController.text,
      dueDate: DateTime.now(),
      userId: userId,
      priority: priorityValue ?? 'None',
      alert: alertValue,
      groupId: 'general',
      isCompleted: false,
    );

    await taskService.addTask(task);
  }

  int selectedIndex = 0;

  List<DateTime> days = List.generate(
    7,
        (index) => DateTime.now().add(Duration(days: index)),
  );

  TimeOfDay? startTime;
  TimeOfDay? endTime;

  Future<void> pickTime(bool isStart) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [

              // 🔹 TOP CARD
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                padding: EdgeInsets.all(12),
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Today',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                        Text(
                          'Date: ${widget.date.day}/${widget.date.month}/${widget.date.year}',
                          style: TextStyle(color: Colors.white,
                            fontSize: 15
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Time: ${widget.date.hour}:${widget.date.minute}',
                          style: TextStyle(color: Colors.white,
                            fontSize: 15
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,

                        ),
                      ],
                    ),
                    Icon(Icons.calendar_today, color: Colors.white, size: 40),
                  ],
                ),
              ),
              SizedBox(height: 10),

              // 🔹 DAYS
              SizedBox(
                height: 70,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    bool isSelected = index == selectedIndex;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Container(
                        width: 45,
                        margin: EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.deepPurple
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            days[index].day.toString(),
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 10),

              // 🔹 TITLE
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 10),

              // 🔹 DESCRIPTION
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 20),

              // 🔹 TIME
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () => pickTime(true),
                    child: Container(
                      width: 150,
                      padding: EdgeInsets.all(12),
                      color: Colors.deepPurple,
                      child: Column(
                        children: [
                          Text('Start',
                              style: TextStyle(color: Colors.white)),
                          Text(
                            startTime == null
                                ? "Select"
                                : startTime!.format(context),
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => pickTime(false),
                    child: Container(
                      width: 150,
                      padding: EdgeInsets.all(12),
                      color: Colors.deepPurple,
                      child: Column(
                        children: [
                          Text('End',
                              style: TextStyle(color: Colors.white)),
                          Text(
                            endTime == null
                                ? "Select"
                                : endTime!.format(context),
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // 🔥 PRIORITY + ALERT (جنب بعض)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  // PRIORITY
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Priority'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: Text('High'),
                                onTap: () {
                                  setState(() => priorityValue = 'High');
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                title: Text('Medium'),
                                onTap: () {
                                  setState(() => priorityValue = 'Medium');
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                title: Text('Low'),
                                onTap: () {
                                  setState(() => priorityValue = 'Low');
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                title: Text('None'),
                                onTap: () {
                                  setState(() => priorityValue = 'None');
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 150,
                      padding: EdgeInsets.all(12),
                      color: Colors.blueGrey,
                      child: Column(
                        children: [
                          Text('Priority',
                              style: TextStyle(color: Colors.white)),
                          Text(priorityValue,
                              style: TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ),
                  ),

                  // ALERT
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Alert'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: Text('None'),
                                onTap: () {
                                  setState(() => alertValue = 'None');
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                title: Text('5 Minutes'),
                                onTap: () {
                                  setState(() => alertValue = '5 Minutes');
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                title: Text('10 Minutes'),
                                onTap: () {
                                  setState(() => alertValue = '10 Minutes');
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 150,
                      padding: EdgeInsets.all(12),
                      color: Colors.blueGrey,
                      child: Column(
                        children: [
                          Text('Alert',
                              style: TextStyle(color: Colors.white)),
                          Text(alertValue,
                              style: TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

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
                onPressed: () async {
                  await addTask();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyTasks()),
                  );
                },
                child: Text('Create Task',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,)

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
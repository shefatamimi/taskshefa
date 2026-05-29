import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_shefa/task/task_model/task_model.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addTask(TaskModel task) async {
    await _firestore.collection('tasks').add(task.toMap());
  }

  Future<void> updateTask(String id, TaskModel task) async {
    await _firestore
        .collection('tasks')
        .doc(id)
        .set(task.toMap(), SetOptions(merge: true));
  }

  Future<void> deleteTask(String id) async {
    await _firestore.collection('tasks').doc(id).delete();
  }

  Stream<List<TaskModel>> getTasks(String userId) {
    return FirebaseFirestore.instance
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) =>
            TaskModel.fromJson({...doc.data(), 'id': doc.id})
        ).toList());
  }

  Stream<List<TaskModel>> getTasksByGroup(
      String userId,
      String groupId,
      ) {
    return _firestore
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .where('groupId', isEqualTo: groupId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        return TaskModel.fromJson({
          ...data,
          'id': doc.id,
        });
      }).toList();
    });
  }

  Future<void> deleteAllTasks() async {
    final tasks = await _firestore.collection('tasks').get();
    for (final task in tasks.docs) {
      await _firestore.collection('tasks').doc(task.id).delete();
    }
  }
  }

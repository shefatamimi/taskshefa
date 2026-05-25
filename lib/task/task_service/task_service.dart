//firestore
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_shefa/task/task_model/task_model.dart';


class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addTask(TaskModel task) async {
    await _firestore.collection('tasks').add(task.toMap());
  }

  Future<void> updateTask(String id, TaskModel task) async {
    await _firestore.collection('tasks').doc(id).update(task.toMap());
  }

  Future<void> deleteTask(String id) async {
    await _firestore.collection('tasks').doc(id).delete();
  }

  Stream<List<TaskModel>> getTasks(String userId, {bool? isCompleted}) {
    Query query = _firestore.collection('tasks')
        .where('userId', isEqualTo: userId);

    if (isCompleted != null) {
      query = query.where('isCompleted', isEqualTo: isCompleted);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        return TaskModel.fromJson({
          ...data,
          'id': doc.id,
        });
      }).toList();
    });
  }
}
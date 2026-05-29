import 'package:cloud_firestore/cloud_firestore.dart';

class BackupService {
  // =========================
  // BACKUP TASKS
  // =========================
  static Future<void> backupTasks(String userId) async {
    final tasksSnap = await FirebaseFirestore.instance
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .get();

    final batch = FirebaseFirestore.instance.batch();

    for (var doc in tasksSnap.docs) {
      final backupRef = FirebaseFirestore.instance
          .collection('backup_tasks')
          .doc(doc.id);

      batch.set(backupRef, doc.data());
    }

    await batch.commit();
  }

  // =========================
  // RESTORE TASKS
  // =========================
  static Future<void> restoreTasks() async {
    final backupSnap = await FirebaseFirestore.instance
        .collection('backup_tasks')
        .get();

    final batch = FirebaseFirestore.instance.batch();

    for (var doc in backupSnap.docs) {
      final newRef = FirebaseFirestore.instance
          .collection('tasks')
          .doc();

      batch.set(newRef, doc.data());
    }

    await batch.commit();
  }

  // =========================
  // BACKUP GROUPS
  // =========================
  static Future<void> backupGroups(String userId) async {
    final groupsSnap = await FirebaseFirestore.instance
        .collection('groups')
        .where('userId', isEqualTo: userId)
        .get();

    final batch = FirebaseFirestore.instance.batch();

    for (var doc in groupsSnap.docs) {
      final backupRef = FirebaseFirestore.instance
          .collection('backup_groups')
          .doc(doc.id);

      batch.set(backupRef, doc.data());
    }

    await batch.commit();
  }

  // =========================
  // RESTORE GROUPS
  // =========================
  static Future<void> restoreGroups() async {
    final backupSnap = await FirebaseFirestore.instance
        .collection('backup_groups')
        .get();

    final batch = FirebaseFirestore.instance.batch();

    for (var doc in backupSnap.docs) {
      final newRef = FirebaseFirestore.instance
          .collection('groups')
          .doc();

      batch.set(newRef, doc.data());
    }

    await batch.commit();
  }

  // =========================
  // DELETE BACKUP (optional)
  // =========================
  static Future<void> clearBackup() async {
    final tasks = await FirebaseFirestore.instance.collection('backup_tasks').get();
    final groups = await FirebaseFirestore.instance.collection('backup_groups').get();

    final batch = FirebaseFirestore.instance.batch();

    for (var d in tasks.docs) {
      batch.delete(d.reference);
    }

    for (var d in groups.docs) {
      batch.delete(d.reference);
    }

    await batch.commit();
  }
}
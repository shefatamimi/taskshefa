import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';

class BackupService {

  // ================= BACKUP TASKS =================
  static Future<void> backupTasks(String userId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('tasks')
          .where('userId', isEqualTo: userId)
          .get();

      List<Map<String, dynamic>> data = snapshot.docs.map((doc) {
        final map = doc.data();

        // 🔥 حل مشكلة Timestamp
        map.forEach((key, value) {
          if (value is Timestamp) {
            map[key] = value.toDate().toIso8601String();
          }
        });

        return map;
      }).toList();

      final jsonString = jsonEncode(data);

      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/tasks_backup.json');

      await file.writeAsString(jsonString);

      print("✅ TASKS BACKUP DONE: ${file.path}");
    } catch (e) {
      print("❌ BACKUP ERROR: $e");
    }
  }

  // ================= RESTORE TASKS =================
  static Future<void> restoreTasks() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/tasks_backup.json');

      if (!await file.exists()) {
        print("❌ No backup file found");
        return;
      }

      final jsonString = await file.readAsString();
      final List data = jsonDecode(jsonString);

      for (var item in data) {
        await FirebaseFirestore.instance
            .collection('tasks')
            .add(Map<String, dynamic>.from(item));
      }

      print("✅ TASKS RESTORE DONE");
    } catch (e) {
      print("❌ RESTORE ERROR: $e");
    }
  }

  // ================= BACKUP GROUPS =================
  static Future<void> backupGroups(String userId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('groups')
          .where('userId', isEqualTo: userId)
          .get();

      List<Map<String, dynamic>> data =
      snapshot.docs.map((doc) => doc.data()).toList();

      final jsonString = jsonEncode(data);

      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/groups_backup.json');

      await file.writeAsString(jsonString);

      print("✅ GROUPS BACKUP DONE");
    } catch (e) {
      print("❌ GROUP BACKUP ERROR: $e");
    }
  }

  // ================= RESTORE GROUPS =================
  static Future<void> restoreGroups() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/groups_backup.json');

      if (!await file.exists()) return;

      final jsonString = await file.readAsString();
      final List data = jsonDecode(jsonString);

      for (var item in data) {
        await FirebaseFirestore.instance
            .collection('groups')
            .add(Map<String, dynamic>.from(item));
      }

      print("✅ GROUPS RESTORE DONE");
    } catch (e) {
      print("❌ GROUP RESTORE ERROR: $e");
    }
  }
}
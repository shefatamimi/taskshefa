import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  String? id;
  final String groupId;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool isCompleted;
  final String userId;
  final String priority;
  final String alert;

  TaskModel({
    this.id,
    required this.groupId,
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
    required this.userId,
    this.priority = 'None',
    this.alert = 'None',
  });

  factory TaskModel.fromJson(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      groupId: map['groupId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      dueDate: DateTime.parse(map['dueDate']),
      isCompleted: map['isCompleted'] ?? false,
      userId: map['userId'] ?? '',
      priority: map['priority'] ?? 'Medium',
      alert: map['alert'] ?? 'None',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'groupId': groupId,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted,
      'userId': userId,
      'priority': priority,
      'alert': alert,
    };
  }
}
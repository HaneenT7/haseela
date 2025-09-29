import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum TaskStatus { assigned, pending, completed, approved }

class Task {
  final String id;
  final String taskName;
  final double allowance;
  final String status;
  final String priority;
  final DateTime? dueDate;
  final DateTime createdAt;
  final DateTime? completedDate;
  final DocumentReference assignedBy;
  final IconData? categoryIcon;
  final Color? categoryColor;
  final String? completedImagePath;
  final String? image;

  Task({
    required this.id,
    required this.taskName,
    required this.allowance,
    required this.status,
    required this.priority,
    this.dueDate,
    required this.createdAt,
    this.completedDate,
    required this.assignedBy,
    this.categoryIcon,
    this.categoryColor,
    this.completedImagePath,
    this.image,
  });

  factory Task.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Handle assignedBy field - it could be a DocumentReference or a string path
    DocumentReference assignedByRef;
    if (data['AssignedBy'] is DocumentReference) {
      assignedByRef = data['AssignedBy'] as DocumentReference;
    } else if (data['AssignedBy'] is String) {
      // Convert string path to DocumentReference
      String path = data['AssignedBy'] as String;
      assignedByRef = FirebaseFirestore.instance.doc(path);
    } else {
      // Fallback to a default reference if neither
      assignedByRef =
          FirebaseFirestore.instance.collection('Parents').doc('parent001');
    }

    return Task(
      id: doc.id,
      taskName: data['taskName'] ?? '',
      allowance: (data['allowance'] ?? 0).toDouble(),
      status: data['status'] ?? 'assigned',
      priority: data['priority'] ?? 'medium',
      dueDate: data['dueDate'] != null
          ? (data['dueDate'] as Timestamp).toDate()
          : null,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      completedDate: data['completedDate'] != null
          ? (data['completedDate'] as Timestamp).toDate()
          : null,
      assignedBy: assignedByRef,
      completedImagePath: data['completedImagePath'],
      image: data['image'],
    );
  }

  // Add category icon based on task name/priority
  Task withCategoryIcon() {
    IconData? icon;
    Color? color;

    String taskLower = taskName.toLowerCase();

    if (taskLower.contains('clean') ||
        taskLower.contains('room') ||
        taskLower.contains('house')) {
      icon = Icons.home;
      color = Colors.orange;
    } else if (taskLower.contains('homework') ||
        taskLower.contains('study') ||
        taskLower.contains('math')) {
      icon = Icons.calculate;
      color = Colors.blue;
    } else if (taskLower.contains('water') ||
        taskLower.contains('plant') ||
        taskLower.contains('garden')) {
      icon = Icons.local_florist;
      color = Colors.green;
    } else if (taskLower.contains('dish') ||
        taskLower.contains('kitchen') ||
        taskLower.contains('cook')) {
      icon = Icons.restaurant;
      color = Colors.purple;
    } else if (taskLower.contains('read') || taskLower.contains('book')) {
      icon = Icons.book;
      color = Colors.indigo;
    } else if (taskLower.contains('exercise') ||
        taskLower.contains('sport') ||
        taskLower.contains('run')) {
      icon = Icons.fitness_center;
      color = Colors.red;
    } else {
      // Default based on priority
      switch (priority.toLowerCase()) {
        case 'high':
          icon = Icons.priority_high;
          color = Colors.red;
          break;
        case 'medium':
          icon = Icons.task;
          color = Colors.orange;
          break;
        case 'low':
          icon = Icons.low_priority;
          color = Colors.green;
          break;
        default:
          icon = Icons.assignment;
          color = Colors.grey;
      }
    }

    return Task(
      id: id,
      taskName: taskName,
      allowance: allowance,
      status: status,
      priority: priority,
      dueDate: dueDate,
      createdAt: createdAt,
      completedDate: completedDate,
      assignedBy: assignedBy,
      categoryIcon: icon,
      categoryColor: color,
      completedImagePath: completedImagePath,
      image: image,
    );
  }

  TaskStatus get taskStatus {
    switch (status.toLowerCase()) {
      case 'completed':
        return TaskStatus.completed;
      case 'pending':
        return TaskStatus.pending;
      case 'approved':
        return TaskStatus.approved;
      default:
        return TaskStatus.assigned;
    }
  }
}

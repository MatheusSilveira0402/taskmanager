enum TaskStatus { pending, progress, completed }
enum TaskPriority { low, medium, high }

extension TaskStatusExtension on TaskStatus {
  String get value {
    switch (this) {
      case TaskStatus.pending:
        return 'pending';
      case TaskStatus.progress:
        return 'progress';
      case TaskStatus.completed:
        return 'completed';
    }
  }

  static TaskStatus fromString(String value) {
    switch (value) {
      case 'progress':
        return TaskStatus.progress;
      case 'completed':
        return TaskStatus.completed;
      case 'pending':
      default:
        return TaskStatus.pending;
    }
  }
}

extension TaskPriorityExtension on TaskPriority {
  String get value {
    switch (this) {
      case TaskPriority.low:
        return 'low';
      case TaskPriority.high:
        return 'high';
      case TaskPriority.medium:
      return 'medium';
    }
  }

  static TaskPriority fromString(String value) {
    switch (value) {
      case 'low':
        return TaskPriority.low;
      case 'high':
        return TaskPriority.high;
      case 'medium':
      default:
        return TaskPriority.medium;
    }
  }
}

class TaskModel {
  late final String id;
  final String userId;
  final String title;
  final String? description;
  final TaskStatus status;
  final TaskPriority priority;
  final DateTime createdAt;
  final DateTime? completedAt;
  final DateTime? scheduledAt;

  TaskModel({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    this.status = TaskStatus.pending,
    this.priority = TaskPriority.medium,
    DateTime? createdAt,
    this.completedAt,
    this.scheduledAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      userId: map['user_id'],
      title: map['title'],
      description: map['description'],
      status: TaskStatusExtension.fromString(map['status'] ?? 'pending'),
      priority: TaskPriorityExtension.fromString(map['priority'] ?? 'medium'),
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : DateTime.now(),
      completedAt: map['completed_at'] != null
          ? DateTime.parse(map['completed_at'])
          : null,
      scheduledAt: map['scheduled_at'] != null
          ? DateTime.parse(map['scheduled_at'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
  final map = <String, dynamic>{
    'user_id': userId,
    'title': title,
    'description': description,
    'status': status.name,
    'priority': priority.name,
    'scheduled_at': scheduledAt?.toIso8601String(),
    'created_at': createdAt.toIso8601String(),
    'completed_at': completedAt?.toIso8601String(),
  };

  // Evita enviar um id vazio (''), pois isso quebra no Supabase
  if (id.isNotEmpty) {
    map['id'] = id;
  }

  return map;
}

  TaskModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    TaskStatus? status,
    TaskPriority? priority,
    DateTime? createdAt,
    DateTime? completedAt,
    DateTime? scheduledAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      scheduledAt: scheduledAt ?? this.scheduledAt,
    );
  }
}

/// Enumeração que representa o status de uma tarefa.
enum TaskStatus { pending, progress, completed, delete }

/// Enumeração que representa a prioridade de uma tarefa.
enum TaskPriority { low, medium, high }

/// Extensão para [TaskStatus] que adiciona funcionalidades extras.
extension TaskStatusExtension on TaskStatus {
  /// Retorna o valor em formato de string associado ao status da tarefa.
  String get value {
    switch (this) {
      case TaskStatus.pending:
        return 'pending';
      case TaskStatus.progress:
        return 'progress';
      case TaskStatus.completed:
        return 'completed';
      case TaskStatus.delete:
        return 'delete';
    }
  }

  /// Converte uma string para o valor correspondente de [TaskStatus].
  ///
  /// Se a string não corresponder a um valor conhecido, o status retornado será
  /// o [TaskStatus.pending] por padrão.
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

/// Extensão para [TaskPriority] que adiciona funcionalidades extras.
extension TaskPriorityExtension on TaskPriority {
  /// Retorna o valor em formato de string associado à prioridade da tarefa.
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

  /// Converte uma string para o valor correspondente de [TaskPriority].
  ///
  /// Se a string não corresponder a um valor conhecido, a prioridade retornada será
  /// o [TaskPriority.medium] por padrão.
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

/// Modelo que representa uma tarefa no sistema.
class TaskModel {
  /// Identificador único da tarefa.
  late final String id;

  /// Identificador do usuário associado à tarefa.
  final String userId;

  /// Título da tarefa.
  final String title;

  /// Descrição opcional da tarefa.
  final String? description;

  /// Status atual da tarefa.
  late TaskStatus status;

  /// Prioridade da tarefa.
  final TaskPriority priority;

  /// Data e hora em que a tarefa foi criada.
  final DateTime createdAt;

  /// Data e hora em que a tarefa foi concluída, se aplicável.
  final DateTime? completedAt;

  /// Data e hora em que a tarefa foi agendada, se aplicável.
  final DateTime? scheduledAt;

  /// Construtor da classe [TaskModel], responsável por inicializar os campos.
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

  /// Cria uma instância de [TaskModel] a partir de um mapa de dados.
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      userId: map['user_id'],
      title: map['title'],
      description: map['description'],
      status: TaskStatusExtension.fromString(map['status'] ?? 'pending'),
      priority: TaskPriorityExtension.fromString(map['priority'] ?? 'medium'),
      createdAt:
          map['created_at'] != null ? DateTime.parse(map['created_at']) : DateTime.now(),
      completedAt:
          map['completed_at'] != null ? DateTime.parse(map['completed_at']) : null,
      scheduledAt:
          map['scheduled_at'] != null ? DateTime.parse(map['scheduled_at']) : null,
    );
  }

  /// Converte a instância de [TaskModel] para um mapa de dados.
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

  /// Cria uma cópia da instância de [TaskModel] com valores modificados.
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

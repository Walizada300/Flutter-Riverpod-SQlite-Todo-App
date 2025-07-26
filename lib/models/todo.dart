class Todo {
  final int? id;
  final String title;
  final bool isDone;
  final DateTime createdAt;

  Todo({
    this.id,
    required this.title,
    required this.isDone,
    required this.createdAt,
  });

  Todo copyWith({int? id, String? title, bool? isDone, DateTime? createdAt}) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Todo.fromMap(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      isDone: json['isDone'] == 1,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isDone': isDone ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

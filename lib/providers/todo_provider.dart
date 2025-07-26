import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo.dart';
import '../db/todo_database.dart';

class TodoNotifier extends StateNotifier<List<Todo>> {
  TodoNotifier() : super([]) {
    loadTodos();
  }

  Future<void> loadTodos() async {
    final todos = await TodoDatabase.instance.readAllTodos();
    state = todos;
  }

  Future<void> addTodo(String title) async {
    final newTodo = Todo(
      title: title,
      isDone: false,
      createdAt: DateTime.now(),
    );
    final savedTodo = await TodoDatabase.instance.create(newTodo);
    state = [savedTodo, ...state];
  }

  Future<void> toggleDone(Todo todo) async {
    final updated = todo.copyWith(isDone: !todo.isDone);
    await TodoDatabase.instance.update(updated);
    state = [
      for (final t in state)
        if (t.id == todo.id) updated else t,
    ];
  }

  Future<void> deleteTodo(Todo todo) async {
    await TodoDatabase.instance.delete(todo.id!);
    state = state.where((t) => t.id != todo.id).toList();
  }
}

final todoProvider = StateNotifierProvider<TodoNotifier, List<Todo>>((ref) {
  return TodoNotifier();
});

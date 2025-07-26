import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/todo_provider.dart';
import '../models/todo.dart';

class HomeScreen extends ConsumerWidget {
  final TextEditingController controller = TextEditingController();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoProvider);
    final notDoneTodos = todos.where((todo) => !todo.isDone).toList();
    final doneTodos = todos.where((todo) => todo.isDone).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("📝 Task Manager"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Add a new task...',
                prefixIcon: const Icon(Icons.add_task),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                filled: true,
                fillColor: Colors.blue.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  ref.read(todoProvider.notifier).addTodo(value.trim());
                  controller.clear();
                }
              },
            ),
          ),

          Expanded(
            child:
                todos.isEmpty
                    ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inbox, size: 80, color: Colors.grey),
                          SizedBox(height: 12),
                          Text('No tasks yet!', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    )
                    : ListView(
                      padding: const EdgeInsets.all(12),
                      children: [
                        if (notDoneTodos.isNotEmpty) ...[
                          const Text(
                            "⏳ Tasks To Do",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...notDoneTodos.map(
                            (todo) => TodoCard(todo: todo, ref: ref),
                          ),
                          const SizedBox(height: 16),
                        ],
                        if (doneTodos.isNotEmpty) ...[
                          const Text(
                            "✅ Completed Tasks",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...doneTodos.map(
                            (todo) => TodoCard(todo: todo, ref: ref),
                          ),
                        ],
                      ],
                    ),
          ),
        ],
      ),
    );
  }
}

class TodoCard extends StatelessWidget {
  final Todo todo;
  final WidgetRef ref;

  const TodoCard({super.key, required this.todo, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        onTap: () => ref.read(todoProvider.notifier).toggleDone(todo),
        leading: Checkbox(
          value: todo.isDone,
          onChanged: (_) => ref.read(todoProvider.notifier).toggleDone(todo),
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isDone ? TextDecoration.lineThrough : null,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          'Created: ${DateFormat('yyyy/MM/dd – HH:mm').format(todo.createdAt)}',
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => ref.read(todoProvider.notifier).deleteTodo(todo),
        ),
      ),
    );
  }
}

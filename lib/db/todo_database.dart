import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/todo.dart';

class TodoDatabase {
  static final TodoDatabase instance = TodoDatabase._init();

  static Database? _database;

  TodoDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('todos.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE todos (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      isDone INTEGER NOT NULL,
      createdAt TEXT NOT NULL
    )
    ''');
  }

  Future<Todo> create(Todo todo) async {
    final db = await instance.database;
    final id = await db.insert('todos', todo.toMap());
    return todo.copyWith(id: id);
  }

  Future<List<Todo>> readAllTodos() async {
    final db = await instance.database;
    final result = await db.query('todos', orderBy: 'createdAt DESC');
    return result.map((json) => Todo.fromMap(json)).toList();
  }

  Future<int> update(Todo todo) async {
    final db = await instance.database;
    return db.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return db.delete('todos', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

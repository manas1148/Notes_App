import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/note.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'notes_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        content TEXT,
        date TEXT,
        category TEXT
      )
    ''');
  }

  Future<int> insertNote(Note note) async {
    final Database db = await database;
    return await db.insert('notes', note.toMap());
  }

  Future<List<Note>> getNotes({String? searchQuery, String? category}) async {
    final Database db = await database;
    List<Map<String, dynamic>> maps;
    
    if (searchQuery != null && category != null) {
      maps = await db.query(
        'notes',
        where: 'category = ? AND (title LIKE ? OR content LIKE ?)',
        whereArgs: [category, '%$searchQuery%', '%$searchQuery%'],
        orderBy: 'date DESC',
      );
    } else if (searchQuery != null) {
      maps = await db.query(
        'notes',
        where: 'title LIKE ? OR content LIKE ?',
        whereArgs: ['%$searchQuery%', '%$searchQuery%'],
        orderBy: 'date DESC',
      );
    } else if (category != null) {
      maps = await db.query(
        'notes',
        where: 'category = ?',
        whereArgs: [category],
        orderBy: 'date DESC',
      );
    } else {
      maps = await db.query('notes', orderBy: 'date DESC');
    }

    return List.generate(maps.length, (i) => Note.fromMap(maps[i]));
  }

  Future<int> updateNote(Note note) async {
    final Database db = await database;
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final Database db = await database;
    return await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<String>> getCategories() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      columns: ['DISTINCT category'],
    );
    return maps.map((map) => map['category'] as String).toList();
  }
}

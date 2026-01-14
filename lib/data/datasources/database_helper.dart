import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:city_care/data/models/report_model.dart';

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
    String path = join(await getDatabasesPath(), 'citycare.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE reports(
            id TEXT PRIMARY KEY,
            title TEXT,
            description TEXT,
            latitude REAL,
            longitude REAL,
            status TEXT,
            isDraft INTEGER,
            aiSuggestion TEXT,
            createdAt TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertDraft(ReportModel report) async {
    final db = await database;
    await db.insert('reports', report.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<ReportModel>> getDrafts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('reports', where: 'isDraft = ?', whereArgs: [1]);
    return List.generate(maps.length, (i) => ReportModel.fromJson(maps[i]));
  }

  Future<void> deleteDraft(String id) async {
    final db = await database;
    await db.delete('reports', where: 'id = ?', whereArgs: [id]);
  }
}

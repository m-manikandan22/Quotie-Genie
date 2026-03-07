import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final dbPath = join(docsDir.path, 'quotie_genie.db');
    return await databaseFactoryFfi.openDatabase(dbPath,
        options: OpenDatabaseOptions(
            version: 1,
            onCreate: (db, version) async {
              await db.execute('''
          CREATE TABLE predictions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            timestamp TEXT,
            weight REAL,
            fragile INTEGER,
            peak_season INTEGER,
            customer_segment TEXT,
            historical_win_rate REAL,
            win_probability REAL,
            recommended_price REAL,
            expected_margin REAL
          )
          ''');
            }));
  }

  Future<int> insertPrediction(Map<String, dynamic> prediction) async {
    final db = await database;
    return await db.insert('predictions', prediction);
  }

  Future<List<Map<String, dynamic>>> getPredictions() async {
    final db = await database;
    return await db.query('predictions', orderBy: 'timestamp DESC');
  }

  Future<int> deletePrediction(int id) async {
    final db = await database;
    return await db.delete('predictions', where: 'id = ?', whereArgs: [id]);
  }
}

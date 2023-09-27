import 'package:crypto/View/Baza/Dionica.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DatabaseHelper {
  static const int _version = 1;
  static const String _dbName = "Dionice1.db";
  static String kupljeneDioniceTable = "create table kupljeneDionice (id INTEGER PRIMARY KEY autoincrement, kolicina INTEGER, slika TEXT NOT NULL, dionicaId TEXT NOT NULL, simbol TEXT NOT NULL, ime TEXT NOT NULL, cijena DOUBLE);";

  static Future<Database> _getDB() async {
    return openDatabase(join(await getDatabasesPath(), _dbName),
        onCreate: (db, version) async {
        
     
        await db.execute(kupljeneDioniceTable);
  },
  version: _version);
  }

  
  
  //----------------------------------DIONICE--------------------------------------------------------------

  static Future<int> addDionica(Dionica dionica) async {
    final db = await _getDB();
    return await db.insert("kupljeneDionice", dionica.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateDionica(Dionica dionica) async {
    final db = await _getDB();
    return await db.update("kupljeneDionice", dionica.toJson(),
        where: 'id = ?',
        whereArgs: [dionica.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteDionica(Dionica dionica) async {
    final db = await _getDB();
    return await db.delete(
      "kupljeneDionice",
      where: 'id = ?',
      whereArgs: [dionica.id],
    );
  }

  static Future<List<Dionica>?> getAllDionice() async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query("kupljeneDionice");

    if (maps.isEmpty) {
      return null;
    }
    return List.generate(maps.length, (index) => Dionica.fromJson(maps[index]));
  }
}
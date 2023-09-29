
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


Database? _database;
Database? _picdatabase;
List WholeDataList = [];

class studentDatabase {
  Future get database async {
    if (_database != null) _database!;
    _database = await initializeDB('Student.db');
    return _database;
  }

  Future initializeDB(String filepath) async {
    final dbpath = await getDatabasesPath();
    final path = join(dbpath, filepath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE IF NOT EXISTS student(id INTEGER PRIMARY KEY ,
name TEXT,
age INTEGER,
gender TEXT,
onclass INTEGER,
image TEXT
)

    ''');
  }

  Future addDatatoDB(
      {String? name, int? age, String? gender, int? onclass, String? image}) async {
    final db = await database;
    final row = {
      'name': name,
      'age': age,
      'gender': gender,
      'onclass': onclass,
    };
    await db.insert(
      "student",
      row,
    );
    print(row);
    return 'added';
  }

  Future<List<Map<String, dynamic>>> readDataFromDB(
      {int limit = 20, int offset = 0}) async {
    final db = await database;
    final data = await db.query(
      "student",
      columns: ['id', 'name', 'age', 'gender', 'onclass'],
    );
    return data;
  }

  Future DeletestudfromDB({id}) async {
    final db = await database;
    await db!.delete("student", where: "id=?", whereArgs: [id]);
  }

  Future updatefromDB(
      {int? id, String? name, int? age, int? onclass, String? gender, String? image}) async {
    final db = await database;
    int rowsUpdated = await db!.update(
      "student",
      {
        'name': name,
        'age': age,
        'gender': gender,
        'onclass': onclass,
        'image': image
      },
      where: 'id = ?',
      whereArgs: [id],
    );
    return rowsUpdated;
  }
}





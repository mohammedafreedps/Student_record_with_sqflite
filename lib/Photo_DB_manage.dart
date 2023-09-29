import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


Database? _database;
List WholeImageList = [];

class ImageDatabase{
  Future get database async{
    if(_database!=null) return _database;
    _database = await _initializeDB("pic.db");
    return _database;
  }

  Future deleteAllImageData()async{
    final db = await database;
    await db.delete("pics");
  }

  Future _initializeDB(String filepath)async{
    final dbpath = await getDatabasesPath();
    final Path = join(dbpath, filepath);
    return await openDatabase(Path,version: 1, onCreate: _createDB);
    
  }

  Future _createDB (Database db, int version)async{
    await db.execute(''' 
    CREATE TABLE IF NOT EXISTS pics(id INTEGER PRIMARY KEY,
    image TEXT NOT NULL
     )
    ''');
  }

  Future addImageLocally({String? image})async{
    final db = await database;
    await db.insert('pics',{'image':image});
    print('${image}added to databe successfully');
    return 'added';
  }

  Future readImageData()async{
    final db = await database;
    final allImage = await db!.query("pics");
    WholeImageList=allImage;
    print(WholeImageList);
    return WholeImageList;
  }

  Future updateImage({name, id})async{
    final db = await database;
    int dbupdateid = await db.rawUpdate('UPDATE pics SET image = ? WHERE id==?',[name,id]);
    return dbupdateid;
  }

  Future DeleteImage({id})async{
    final db = await database;
    await db.delete("pics",where: 'id=?',whereArgs:[id]);
  }
}
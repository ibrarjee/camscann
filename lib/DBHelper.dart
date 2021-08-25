import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseename = "internetspeed";
  static final _dastabaseversion = 1;
  static final table = "my_table";
  static final columnId = "id";
  static final columnDownload = "downloadrate";
  static final columnUpload = "uploadrate";
  static final columnping = "ping";
  var dbTable;
  static Database _database;

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentdirectory = await getApplicationDocumentsDirectory();
    String path = join(documentdirectory.path, _databaseename);
    return await openDatabase(path,
        version: _dastabaseversion, onCreate: _onCreate);
  }
  Future _onCreate(Database db, int version) async {
    await db.execute(
      '''CREATE TABLE $table(
       $columnId INTEGER PRIMARY KEY,
        $columnDownload INTEGER NOT NULL,
        $columnUpload INTEGER NOT NULL,
        $columnping INTEGER NOT NULL
       
        )
    ''',
    );
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    try {
      return await db.insert(table, row);
    } catch (e) {
      print("THIS IS MY EXCEPTION");
      print(e);
    }
  }
  Future<int> delete(Map<String,dynamic> row)async{
    Database db = await instance.database;
    try{return await db.delete(table);}
    catch(e){
      print(e);
    }
  }

  Future<List<Map<String, dynamic>>> queryallrows() async {
    Database db = await instance.database;
    var f = await db.query(table);

    return f;
  }

  Future<int> deletedata(int id) async{
    Database db = await instance.database;
    //var result = await db.rawDelete('DELETE FROM $table WHERE $columnId = $columnId');
    var result = await db.delete(table,where: "id = ?",whereArgs: [id]);
    return result;
  }
}

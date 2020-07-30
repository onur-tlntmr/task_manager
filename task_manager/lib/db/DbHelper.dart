import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_manager/models/Task.dart';

class DbHelper {
  final String tblTask = "Tasks";
  final String colId = "Id";
  final String colTitle = "Title";
  final String colBeginDate = "BeginDate";
  final String colFinishedDate = "FinishedDate";
  final String colStatus = "Status";

  static final DbHelper _dbHelper = DbHelper._internal(); // singleton object
  static Database _db; // db objesi

  DbHelper._internal(); // default constructor

  factory DbHelper(){
    return _dbHelper; // surekli ayni instace'i donderir
  }


  Future<Database> get db async {
    if (_db == null)
      _db = await initializeDb();

    return _db;
  }


  Future<Database> initializeDb() async {
    // baglanti saylayan method
    Directory directory = await getApplicationDocumentsDirectory();

    String path = directory.path + "tasks.db";

    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  void _createDb(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $tblTask($colId INTEGER PRIMARY KEY AUTOINCREMENT , $colTitle TEXT, $colBeginDate TEXT, "
            "$colFinishedDate TEXT, $colStatus TEXT )");
  }


  Future<int> insert(Task task) async {
    final Database db = await this.db;


    return await db.insert(tblTask, task.toMap());
  }


  Future<int> update(Task task) async {
    final Database db = await this.db;

    var result = db.update(
        tblTask, task.toMap(), where: "$colId=?", whereArgs: [task.id]);
    print("Update: Title: ${task.title}");
    return result;
  }


  Future<int> delete(int id) async {
    final Database db = await this.db;


    var result = db.delete(tblTask, where: "$colId=?", whereArgs: [id]);

    print("Delete");

    return result;
  }


  void clearDb()async{
    final Database db = await this.db;

    db.delete(tblTask);

  }

  Future<List> getTasks() async {
    final Database db = await this.db;

    List result = await db.rawQuery("SELECT * FROM $tblTask ORDER BY $colBeginDate");
    return result;
  }

  Future<List> getTaskByDayStr() async{
    final Database db = await this.db;



  }


}
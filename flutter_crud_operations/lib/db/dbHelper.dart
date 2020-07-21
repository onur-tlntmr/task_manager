import 'dart:io';

import 'package:flutter_crud_operations/model/Note.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper{
  final String tblNote = "Notes";
  final String colId = "Id";
  final String colTitle = "Title";
  final String colContent = "Content";


  static final DbHelper _dbHelper = DbHelper._internal(); // singleton object
  static Database _db; // db objesi

  DbHelper._internal(); // default constructor

  factory DbHelper(){
    return _dbHelper; // surekli ayni instace'i donderir
  }


  Future<Database> get db async{
    if(_db == null)
      _db = await initializeDb();

    return _db;
    
  }


 Future<Database> initializeDb()async { // baglanti saylayan method
    Directory directory = await getApplicationDocumentsDirectory();

    String path = directory.path + "notes.db";

    return await openDatabase(path,version: 1,onCreate: _createDb);

 }
  void _createDb(Database db , int version) async{

    await db.execute("CREATE TABLE $tblNote($colId INTEGER PRIMARY KEY AUTOINCREMENT , $colTitle TEXT, $colContent TEXT)");

  }


  Future<int> insert(Note note) async{

    final Database db = await this.db;


    return await db.insert(tblNote,note.toMap());
  }



  Future<int> update(Note note) async{
    final Database db = await this.db;
    
    var result = db.update(tblNote, note.toMap(),where: "$colId=?",whereArgs: [note.id]);

    return result;
  }


  Future<int> delete(int id) async{
    final Database db = await this.db;


    var result =  db.delete(tblNote,where: "$colId=?",whereArgs: [id]);
    //var result = db.rawDelete("DELETE FROM $tblNote WHERE $colId = $id"); //ikinci yol

    return result;
  }


  Future<List> getNotes() async{
    final Database db = await this.db;

    var result = await db.rawQuery("SELECT * FROM $tblNote");

    return  result;

  }




}
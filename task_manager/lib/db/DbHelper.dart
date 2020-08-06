import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_manager/models/Task.dart';

/*
* Database crud operasyonlarindan sorumlu sinif
* Bu sinif singleton olup tum methodlari async olarak yazilmistir
*
* */

class DbHelper {
  final String tblTask = "Tasks"; //Task adi
  //Kolonlarin adi
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


  Future<Database> get db async { //singleton db objesi olusturur
    if (_db == null)
      _db = await initializeDb();
    return _db;
  }


  Future<Database> initializeDb() async { //DB baglantisini yapan ve donduren method
    Directory directory = await getApplicationDocumentsDirectory();

    String path = directory.path + "tasks.db";

    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  void _createDb(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $tblTask($colId INTEGER PRIMARY KEY AUTOINCREMENT , $colTitle TEXT, $colBeginDate TEXT, "
            "$colFinishedDate TEXT, $colStatus TEXT )");
  }

/*
* Bazi crud operation'lar yapilan isleme bagli olarak sonuc donderir
*
* Result olarak 1 donmesi islemin hatali sonuclandigini gosterir
*
* */

  Future<int> insert(Task task) async { //Database'e task objesini ekler ve operasyon kodunu donderir

    return await _db.insert(tblTask, task.toMap()); //param1: tablo adi, param2: task verileri
  }


  Future<int> update(Task task) async { //Parametre olarak aldigi task'i guncelleyen method


    var result = _db.update(
        tblTask, task.toMap(), where: "$colId=?", whereArgs: [task.id]);

    return result; //Operation sonucunu donderir
  }


  Future<int> delete(int id) async { //Id'si verilen taski siler

    var result = _db.delete(tblTask, where: "$colId=?", whereArgs: [id]);

    return result;//Operation sonucunu donerir
  }



  Future<List> getTasks() async { //Tum tasklari  geri donduren method

    List result = await _db.rawQuery("SELECT * FROM $tblTask ORDER BY $colBeginDate"); //Tasklari baslangic zamanlarina gore siralar
    return result;  //Operation sonucunu donderir
  }




}
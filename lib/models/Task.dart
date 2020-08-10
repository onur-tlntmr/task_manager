/*
* Task model'i
*
* */



class Task {
  int _id;
  String _title;
  DateTime _beginDate;
  DateTime _finishedDate;
  String _status;


  Task(); //Default constructor

  Task.wihtParams( //Parametreli constructor
      this._title, this._beginDate, this._finishedDate, this._status);

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  DateTime get beginDate => _beginDate;

  set beginDate(DateTime value) {
    _beginDate = value;
  }

  DateTime get finishedDate => _finishedDate;

  set finishedDate(DateTime value) {
    _finishedDate = value;
  }

  String get status => _status;

  set status(String value) {
    _status = value;
  }

  Map<String, dynamic> toMap() { //Task'i map halinde donderir
    var map = Map<String, dynamic>();

    map["id"] = _id;
    map["title"] = _title;
    map["status"] = _status;
    map["beginDate"] = _beginDate.toString();
    map["finishedDate"] = _finishedDate.toString();

    return map;
  }

  Task.fromObject(dynamic o) { //Farkli tipte gelen verilerden task olsuturan constructor
    this._id = o["Id"];        //Ornek olarak yukardaki map gibi
    this._title = o["Title"];
    this._status = o["Status"];
    this._beginDate = DateTime.parse(o["BeginDate"]);
    this._finishedDate = DateTime.parse(o["FinishedDate"]);
  }
}

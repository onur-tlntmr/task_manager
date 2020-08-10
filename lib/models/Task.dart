/*
* Task model'i
*
* */
class Task {
  int id;
  String title;
  DateTime beginDate;
  DateTime finishedDate;
  String status;

  Task(); //Default constructor

  Task.wihtParams(
      //Parametreli constructor
      this.title,
      this.beginDate,
      this.finishedDate,
      this.status);

  Map<String, dynamic> toMap() {
    //Task'i map halinde donderir
    var map = Map<String, dynamic>();

    map["id"] = id;
    map["title"] = title;
    map["status"] = status;
    map["beginDate"] = beginDate.toString();
    map["finishedDate"] = finishedDate.toString();

    return map;
  }

  Task.fromObject(dynamic o) {
    //Farkli tipte gelen verilerden task olsuturan constructor
    this.id = o["Id"]; //Ornek olarak yukardaki map gibi
    this.title = o["Title"];
    this.status = o["Status"];
    this.beginDate = DateTime.parse(o["BeginDate"]);
    this.finishedDate = DateTime.parse(o["FinishedDate"]);
  }
}

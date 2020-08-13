/*
* Task model'i
*
* */
class Task {
  int id; //Task id'si
  String title; //Task basligi
  DateTime beginDate; //Task'in baslangic zamani
  DateTime finishedDate; //Task'in bitis zamani
  String status; //task'in durumu
  Duration beginAlarmDuration; //Alarm'in task'in baslangicindan
  //Ne kadar once baslayacagi

  Task(); //Default constructor

  Task.wihtParams(
      //Parametreli constructor
      this.title,
      this.beginDate,
      this.finishedDate,
      this.status,
      this.beginAlarmDuration);

  Map<String, dynamic> toMap() {
    //Task'i map halinde donderir
    var map = Map<String, dynamic>();

    map["id"] = id;
    map["title"] = title;
    map["status"] = status;
    map["beginDate"] = beginDate.toString();
    map["finishedDate"] = finishedDate.toString();

    if (beginAlarmDuration != null) //Girilen sure null degilse

      map["beginAlarmDuration"] =
          beginAlarmDuration.inMilliseconds; //milisaniye cinsinden map'a gonder

    //zaten null ise degiskene atama yapilmadigi icin null olacaktir

    return map;
  }

  Task.fromObject(dynamic o) {
    //Map'tan task olusturmak icin kullanilir
    this.id = o["Id"]; //Ornek olarak yukardaki map gibi
    this.title = o["Title"];
    this.status = o["Status"];
    this.beginDate = DateTime.parse(o["BeginDate"]);
    this.finishedDate = DateTime.parse(o["FinishedDate"]);

    final int durationMilliSeconds = o["BeginAlarmDuration"];

    if (durationMilliSeconds != null) { //Eger sure var ise ekle
      
      this.beginAlarmDuration = Duration(
          milliseconds: o["BeginAlarmDuration"]); //Milisaniye cinsinden kullan
    }

    //Sure yoksa zaten null olacaktir
  }
}

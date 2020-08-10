import 'dart:async';
import 'package:task_manager/models/Task.dart';
import 'package:task_manager/source/DataSource.dart';
import 'package:task_manager/source/Observer.dart';
import 'package:task_manager/utils/DataUpdateConfig.dart';

/* Zamanla degismesi gerek tasklarin durumunu kontrol eden servis */
class DataUpdaterService extends Observer {
  Timer _timer; //Periyodik islem icin gerekli

  final DataSource _dataSource = DataSource(); //DB operasyonlari icin gerekli

  List<Task> taskList = List(); //Task listesinin tutuldugu yapi

  Future<DataUpdateConfig>
      _configFuture; //Servis'in yapilandirma ayarlarinin bulundugu nesne

  static final DataUpdaterService _updaterService =
      DataUpdaterService._interal(); //singleton obj olusturuluyor

  DataUpdaterService._interal() {//Default constructor
    _configFuture = DataUpdateConfig.createInstance(); //Yapilandirma sinifi Future olarak aliniyor
  }

  factory DataUpdaterService() {
    //Singleton get methodu
    return _updaterService; //Singleton olark kendi donderir.
  }

  void getList() {
    //Task verilerini verir
    _dataSource.getTasks().then((value) {
      //Data List aliniyor
      value.forEach((element) {
        //Elemanlar arasinda geziliyor
        taskList.add(Task.fromObject(
            element)); // Her eleman task'a donusturulup collection'a atiliyor
      });
    });
  }

  void startService() { //Uzaktan servisi baslatir
    //Timer'i baslatir
    _startTimer();
  }

  void closeService() {//Servisi kapatir
    //Timer'i iptal eder
    _timer.cancel();
  }

  _startTimer() { //Timer'i config sinfindaki degere gore baslatan method
    _configFuture.then((conf) { //ConfigFuture DataUpdateConfig nesnesi  olarak aliniyor
      createTimer(conf.periodSeconds); //icindeki periyod suresine gore timer baslatiliyor
    });
  }

  Timer createTimer(int periodSeconds) { //Verilen period suresine gore timer olusturan method
    return Timer.periodic(Duration(seconds: periodSeconds), (timer) {
      getList(); //Veriler alinir

      DateTime current = DateTime.now(); // Simdiki zaman

      taskList.forEach((element) {
        //Her task geziliyor
        if (current.isAfter(element.finishedDate) && //eger task bitmis ise ve
                element.status == "waiting" ||
            element.status == "running") {
          //bekliyor veya devam ediyor durumunda ise
          element.status = "incomplete"; //tamamlanmamis olarak guncelle

          _dataSource.update(element); //update'i veri tabanina yansit
        }
      });
      taskList.clear(); //eski listesi temizle
    });
  }

  @override
  void update() {
    //UI tarafindan veriler guncellenir ise
    getList(); //Listeyi gunceller
  }
}

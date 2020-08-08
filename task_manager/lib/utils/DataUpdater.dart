import 'dart:async';
import 'package:task_manager/models/Task.dart';
import 'package:task_manager/source/DataSource.dart';
import 'package:task_manager/source/Observer.dart';

/* Zamanla degismesi gerek tasklarin durumunu kontrol eden servis */
class DataUpdaterService extends Observer {
  Timer _timer; //Periyodik islem icin gerekli

  final DataSource _dataSource = DataSource(); //DB operasyonlari icin gerekli

  List<Task> taskList = List(); //Task listesinin tutuldugu yapi

  static final DataUpdaterService _updaterService = //singleton obj olusturuluyor
      DataUpdaterService._interal();

  DataUpdaterService._interal(); //Default constructor

  factory DataUpdaterService() { //Singleton get methodu
    return _updaterService; //
  }

  void getList() { //Task verilerini verir
    _dataSource.getTasks().then((value) { //Data List aliniyor
      value.forEach((element) { //Elemanlar arasinda geziliyor
        taskList.add(Task.fromObject(element)); // Her eleman task'a donusturulup collection'a atiliyor
      });
    });
  }

  void startService() { //Timer'i baslatir
    _startTimer();
  }

  void closeService() { //Timer'i iptal eder
    _timer.cancel();
  }

  _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 15), (timer) { //Her 15 saniyede bir calisan timer

      getList(); //Veriler alinir

      DateTime current = DateTime.now(); // Simdiki zaman

      taskList.forEach((element) { //Her task geziliyor
        if (current.isAfter(element.finishedDate) && //eger task bitmis ise ve
            element.status == "waiting" || element.status == "running") { //bekliyor veya devam ediyor durumunda ise
          element.status = "incomplete"; //tamamlanmamis olarak guncelle

          _dataSource.update(element); //update'i veri tabanina yansit
        }
      });
      taskList.clear(); //eski listesi temizle
    });
  }

  @override
  void update() { //UI tarafindan veriler guncellenir ise
    getList(); //Listeyi gunceller
  }
}

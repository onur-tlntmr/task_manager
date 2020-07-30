import 'dart:async';
import 'package:intl/intl.dart';
import 'package:task_manager/models/Task.dart';
import 'package:task_manager/source/DataSource.dart';
import 'package:task_manager/source/Observer.dart';

class DataUpdaterService extends Observer {
  Timer _timer;

  final DataSource _dataSource = DataSource();

  List<Task> taskList = List();

  static final DataUpdaterService _updaterService = //singleton obj
      DataUpdaterService._interal();

  DataUpdaterService._interal();

  factory DataUpdaterService() { //Singleton nesne olusturur
    return _updaterService;
  }

  void getList() { //Task verilerini verir
    _dataSource.getTasks().then((value) {
      value.forEach((element) {
        taskList.add(Task.fromObject(element));
      });
    });
  }

  void startService() { //Timer'i baslatir
    _startTimer();
  }

  void closeService() { //Timer'i kapatir
    _timer.cancel();
  }

  _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) { //Her 15 saniyede bir calisan timer

      getList();

      DateTime current = DateTime.now(); // Simdi zaman

      taskList.forEach((element) { //Her task geziliyor
        if (current.isAfter(element.finishedDate) && //eger task bitmis ise ve
            element.status == "waiting") { //hala bekliyor konumda ise
          element.status = "incomplete"; //tamamlanmamis olarak guncelle

          _dataSource.update(element); //update'i veri tabanina yansit
        }
      });
      taskList.clear(); //eski listesi temizle
    });
  }

  @override
  void update() {

    getList();

  }
}

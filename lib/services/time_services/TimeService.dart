import 'dart:async';
import 'package:task_manager/services/time_services/TimeObservable.dart';
import 'package:task_manager/services/time_services/TimeObserver.dart';
import 'package:task_manager/services/IService.dart';

/*
 * Bu sinif zamani saniye olarak sayar 
 * Her degisimde kendi observer'larini tetikler.
 * 
 */

class TimeService implements TimeObservable, IService {
  static TimeService _timeService = TimeService.internal();

  List<TimeObserver> _observers; //Observerlarin tutuldugu collection

  Timer _timer; //periodik islemleri yapan timer

  DateTime realTime; //gercek zamani tutar

  final Duration _duration = Duration(seconds: 1); //Eklenecek zamani tutar
  //Islemler saniye hassiyetinde oldugu icin degerin degistirilmemesi gerekir.

  TimeService.internal() {
    _observers = List(); //list guncelleniyor
  }

  factory TimeService() {
    return _timeService;
  }

  Timer _createTimer() {
    //Timer'i olsuturan method
    realTime =
        DateTime.now(); //timer baslamadan once simdiki zaman ataniyor
    return Timer.periodic(_duration, (timer) {
      //1'er saniye araliginda calisan tier
      realTime = realTime.add(_duration); //simdiki zamana 1 saniye ekleniyor
      notfiyAll(); //gozlemciler tetikleniyor
    });
  }

  @override
  void startService() {
    //Servisi baslatan method
    _timer =
        _createTimer(); //Timer initalize edilince kendiliginden baslayacatir
  }

  @override
  void notfiyAll() {
    //Tum observer'larin guncellenmesini saglayan method
    _observers.forEach((observer) {
      //Tum observer'lar geziliyor
      observer.timeChanged(realTime); //Zamanin degisti bildirliyor
    });
  }

  @override
  void register(TimeObserver observer) {
    //Observer ekleme
    _observers.add(observer);
  }

  @override
  void unregister(TimeObserver observer) {
    //Observer cikarma
    _observers.remove(observer);
  }

  @override
  void closeService() {
    //Servisi kapatan method
    _timer.cancel(); //timer iptal edilir
    _observers.clear(); //liste temizlenir
  }
}

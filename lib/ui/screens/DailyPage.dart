import 'package:flutter/material.dart';
import 'package:task_manager/models/Task.dart';
import 'package:task_manager/services/time_services/TimeObserver.dart';
import 'package:task_manager/services/time_services/TimeService.dart';
import 'package:task_manager/services/data_service/DataSource.dart';
import 'package:task_manager/services/data_service/Observer.dart';
import 'package:task_manager/ui/widgets/TaskCard.dart';
import 'package:task_manager/utils/DateUtils.dart';

//Gunluk tasklari gosteren sayfa

class DailyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DailyState();
  }
}

/*
 * Bu sinif gunluk tasklari gosterir
 * Veri degisimleri icin observer sinifi olarak implemente edilmistir
 * Clock icin ise TimeObserver implemete edilmistir
 */
class DailyState extends State implements Observer, TimeObserver {
  final DataSource _dataSource = DataSource(); //Data islemleri icin gerekli

  final DateUtils _utils = DateUtils(); //Bazi tarih formatlamalari icin gerekli

  TimeService _timeService =
      TimeService(); //Saniye  degisimlerini takip etmek icin gerekli

  List<Task> list; //Tasklarin listesi

  var clockTime; //Usteki zamanin goruntuleyen degisken

  var w, h; // Ekran genisligi ve yuksekligini verir

  @override
  Widget build(BuildContext context) {
    calculateScreenSize(context); // Ekran boyutlarini hesaplar

    return Container(
      child: Column(
        children: <Widget>[
          dateWidget(),
          Expanded(
            child: createListView(),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    //State yonetimi basladiginda
    super.initState();

    clockTime = _timeService.realTime; //timeServis'ten zaman aliniyor

    _timeService.register(this); //Time observer olarak servise ekleniyor
    _dataSource.register(this); // Observer olarak kendini ekler
  }

  @override
  void dispose() {
    super.dispose();
    _timeService.unregister(this);
    _dataSource.unregister(
        this); // Artik ekranda render yapilamacagi icin observerList'ten cikarilir
  }

  void calculateScreenSize(BuildContext context) {
    //Farkli cozunurlukerde reusable olmasi icin
    w = MediaQuery.of(context).size.width; //ekran cozunurlukleri hesaplanir
    h = MediaQuery.of(context).size.height;
  }

  Widget createCard(Task task) {
    //Verilen task objesinden card olusturur
    return TaskCardWidget(
      task: task,
      onUpdate: () {
        getData(); //Task uzerinde herhangi bir update oldugunda
        //Ui'in guncellemesi icin datalar guncellenir
      },
    );
  }

  ListView createListView() {
    //Kartlardan listView olsuturur

    if (list == null) //eger liste bos ise doldurulur
      getData();

    return ListView.builder(
        //ListView builder eder
        itemCount: list.length,
        itemBuilder: (BuildContext context, int position) {
          return createCard(list[position]); //Listedeki elemandan cardWidget'i
        }); //render eder
  }

  void getData() {
    List<Task> dataTask = List(); // Bos liste olusturuyor

    DateTime current = DateTime.now(); //Simdiki zaman seciliyor

    //task listesini olsuturur
    var taskFuture =
        _dataSource.getTasksWithDate(current); //DB operasyonlari icin gerekli

    Task task;
    taskFuture.then((data) {
      data.forEach((element) {
        //elemanlar arasindan geziliyor

        task = Task.fromObject(element); //kayit task objesine donusturuluyor
        dataTask.add(task); //task ekeleniyor
      });
    });

    setState(() {
      //Ui'in guncellenmesi icin task tetikleniyor
      list = dataTask;
    });
  }

  Widget dateWidget() {
    //Ekranda tarih ve saat gosteren widget

    return Column(
      children: <Widget>[
        Text(_utils.dateFormatter(clockTime), //Tarih ve saatini gosterir
            style: TextStyle(fontSize: w * 0.04)),
        Text(
          _utils.getLocalDay(clockTime), //Gunu string olarak gosterir
          style: TextStyle(fontSize: w * 0.07),
        )
      ],
    );
  }

  @override
  void update() {
    //Datalarda herhangi bir degisiklik oldugunda sayfayi gunceller
    getData();
  }

  void updateClock(DateTime newTime) {
    //clockTime'i guncelleyerek ui tetiklenmesini saglar
    setState(() {
      clockTime = newTime;
    });
  }

  @override
  timeChanged(DateTime newTime) {
    //TimeServis'teki zaman degisince
    updateClock(newTime); //ui'daki saat guncellenmesi saglanir
  }
}

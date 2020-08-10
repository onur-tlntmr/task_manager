import 'dart:async';
import 'package:flutter/material.dart';
import 'package:task_manager/models/Task.dart';
import 'package:task_manager/source/DataSource.dart';
import 'package:task_manager/source/Observer.dart';
import 'package:task_manager/ui/widgets/TaskCard.dart';
import 'package:task_manager/utils/DateUtils.dart';

//Gunluk tasklari gosteren sayfa

class DailyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return DailyState();
  }
}
class DailyState extends State with Observer {

  final DataSource _dataSource = DataSource(); //Data islemleri icin gerekli

  final DateUtils _utils = DateUtils(); //Bazi tarih formatlamalari icin gerekli

  List<Task> list;

  var current = DateTime.now(); //Usteki zamanin goruntuleyen degisken

  var w, h; // Ekran genisligi ve yuksekligini verir

  Timer _clockTimer; //Saat bilgisini guncelleyen timer

  @override
  Widget build(BuildContext context) {

    calculateScreenSize(context); // Ekran boyutlarini hesaplar

    return Container(
      child:Column(
        children: <Widget>[
          dateWidget(),
          Expanded(
            child: createListView(),
          )
        ],
      ) ,
    );


  }

  @override
  void initState() { //State yonetimi basladiginda
    super.initState();
    _startTimer(); //Clock Timer'i baslatir
    _dataSource.register(this); // Observer olarak kendini ekler
  }


  @override
  void dispose() {
    super.dispose();
    _clockTimer.cancel(); //Disopse edilince ise timer iptal edilir
    _dataSource.unregister(this); // Artik ekranda render yapilamacagi icin observerList'ten cikarilir
  }

  void _startTimer() { //Her saniyde simdiki zamani'e gunceller
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        current = current.add(const Duration(seconds: 1));
      });
    });
  }

  void calculateScreenSize(BuildContext context) { //Farkli cozunurlukerde reusable olmasi icin
    w = MediaQuery.of(context).size.width;         //ekran cozunurlukleri hesaplanir
    h = MediaQuery.of(context).size.height;
  }

  Widget createCard(Task task) { //Verilen task objesinden card olusturur
    return TaskCardWidget(
      task: task,
      onUpdate: () {
        getData(); //Task uzerinde herhangi bir update oldugunda
                  //Ui'in guncellemesi icin datalar guncellenir
      },
    );
  }



  ListView createListView() { //Kartlardan listView olsuturur

    if(list == null) //eger liste bos ise doldurulur
      getData();

    return ListView.builder( //ListView builder eder
        itemCount: list.length,
        itemBuilder: (BuildContext context, int position) {
          return createCard(list[position]); //Listedeki elemandan cardWidget'i
        });                                  //render eder
  }
  void getData() { //task listesini olsuturur
    var taskFuture = _dataSource.getTasks(); //DB operasyonlari icin gerekli


    List<Task> dataTask = List(); // Bos liste olusturuyor

    DateTime current = DateTime.now(); //Simdiki zaman seciliyor

    taskFuture.then((data) {
      data.forEach((element) { //elemanlar arasindan geziliyor

        Task task = Task.fromObject(element);
        if(task.beginDate.day == current.day) //task'in gunu simdiki gun ise
          dataTask.add(task); //task ekeleniyor
      });
    });

    setState(() { //Ui'in guncellenmesi icin task tetikleniyor
      list = dataTask;
    });
  }

  Widget dateWidget() { //Ekranda tarih ve saat gosteren widget

    return Column(
      children: <Widget>[
        Text(_utils.dateFormatter(current), //Tarih ve saatini gosterir
            style: TextStyle(fontSize: w * 0.04)),
        Text(
          _utils.getLocalDay(current), //Gunu string olarak gosterir
          style: TextStyle(fontSize: w * 0.07),
        )
      ],
    );
  }

  @override
  void update() { //Datalarda herhangi bir degisiklik oldugunda sayfayi gunceller
    getData();
  }
}

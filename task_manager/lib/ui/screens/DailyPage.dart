import 'dart:async';
import 'package:flutter/material.dart';
import 'package:task_manager/models/Task.dart';
import 'package:task_manager/source/DataSource.dart';
import 'package:task_manager/source/Observer.dart';
import 'package:task_manager/ui/widgets/TaskCard.dart';
import 'package:task_manager/utils/Utils.dart';
import 'dart:developer' as developer;
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

  final Utils _utils = Utils(); //Bazi tarih formatlamalari icin gerekli

  List<Task> list;

  var current = DateTime.now();

  var w, h; // Ekran genisligi ve yuksekligini verir

  Timer _timer;

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

  //Disopse edilince ise timer cikarilir
  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
    _dataSource.unregister(this); // Artik ekranda render yapilamacagi icin observerList'ten cikarilir
  }

  void _startTimer() { //Her saniyde saat'e bir saniye ekler
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        current = current.add(const Duration(seconds: 1));
      });
    });
  }

  void calculateScreenSize(BuildContext context) { //Farkli cozunurlukerde reusable olmasi icin gerkekli
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
  }

  Widget createCard(Task task) { //Verilen task objesinden car olusturur
    return TaskCardWidget(
      task: task,
      onUpdate: () {
        getData();
      },
    );
  }



  ListView createListView() { //Kartlardan listView olsuturur

    if(list == null) //eger liste bos ise doldurulur
      getData();

    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (BuildContext context, int position) {
          return createCard(list[position]);
        });
  }

  void getData() { //task listesini olsuturur
    var taskFuture = _dataSource.getTasks();

    List<Task> dataTask = List();

    DateTime current = DateTime.now(); //Simdiki zaman seciliyor

    taskFuture.then((data) {
      data.forEach((element) { //elemanlar arasindan geziliyor

        Task task = Task.fromObject(element);
        if(task.beginDate.day == current.day) //task'in gunu simdiki gun ise
          dataTask.add(task); //task ekeleniyor
      });
    });

    setState(() {
      list = dataTask;
    });
  }

  Widget dateWidget() { //Ekranda tarih ve saat gosteren widget
    DateTime dateTime = DateTime.now();

    return Column(
      children: <Widget>[
        Text(_utils.dateFormatter(current),
            style: TextStyle(fontSize: w * 0.04)),
        Text(
          _utils.getLocalDay(dateTime),
          style: TextStyle(fontSize: w * 0.07),
        )
      ],
    );
  }

  @override
  void update() { //Datalarda herhangi bir degisiklik oldugunda sayfayi guncller
    getData();
  }
}

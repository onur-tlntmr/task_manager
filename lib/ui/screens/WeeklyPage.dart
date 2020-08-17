import 'package:flutter/material.dart';
import 'package:task_manager/models/Task.dart';
import 'package:task_manager/models/TaskGroup.dart';
import 'package:task_manager/services/data_service/DataSource.dart';
import 'package:task_manager/services/data_service/Observer.dart';
import 'package:task_manager/ui/widgets/TaskGroupWidget.dart';
import 'package:task_manager/utils/DateUtils.dart';


/* Haftalik Tasklari gostern sayfa*/
class WeeklyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {

    return WeeklyState();
    
  }
}

class WeeklyState extends State<WeeklyPage> with Observer {
  final DataSource _dataSource = DataSource(); //Db operasyonlari icin gerekli
  final DateUtils _utils = DateUtils(); //Custom Date formati icin kullanilacak

  Map<String, TaskGroup> _listGroup; //TaskGrouplarinin tutulacagi yapi

  @override
  Widget build(BuildContext context) {// Sayfadaki Main Widget
    return Container(
      child: createListView(),
    );
  }

  //////Observer yonetimi///////////////
  @override
  void initState() {
    super.initState();
    _dataSource.register(this);
  }

  @override
  void dispose() {
    super.dispose();
    _dataSource.unregister(this);
  }
  ///////////////////////////////////////


  //Bu method db'den tasklari cekip gruplar ve _listGroup degiskenini degistirerek ui'yi gunceller
  void getListGroups() {
    Map<String, TaskGroup> list = Map(); //TaskGruplarini tutan yapi

    var taskFuture = _dataSource.getTasks(); //Tasklar future olarak aliniyor

    taskFuture.then((data) { //alinan future collection olarak kullaniliyor
      data.forEach((element) {//icindeki her bir datayi gezer

        Task t = Task.fromObject(element); // datayi task'a donustur
        DateTime beginDate = t.beginDate; //Baslangic zamani
        DateTime current = DateTime.now(); //simdiki zaman
        DateTime afterOneWeek =
            current.add(Duration(days: 7)); //Bir hafta sonrasini hesaplar

        String title; //Group basligi


        //Eger bugun veya yarin ise ozel olarak basligi yazar
        if (current.day == beginDate.day)
          title = "Bugün";
        else if (beginDate.day - current.day == 1)
          title = "Yarın";

        else
          title = _utils.getLocalDay(beginDate);

        //Saglanmasi gereken kosullar: bir haftalik sure zarfinda olmasi ve is'in gecmis olmamasi
        if (beginDate.isBefore(afterOneWeek) && current.isBefore(beginDate)) {
          TaskGroup taskGroup = TaskGroup(); // Yeni bir taskGroup olusturuluyor
          taskGroup.title = title; //Basligina gun'u veriyoruz

          if (!list.containsKey(title)) // gun ekli degilse
            list.putIfAbsent(title, () => taskGroup); //ekle

          list[title].taskList.add(t); //task listesine de ekele

        }
      });
    });

    setState(() {
      //state tetikleniyor
      _listGroup = list;
    });
  }

  TaskGroupWidget createTaskGroupWidget(TaskGroup taskGroup) {
    //TaskGroup objesinden Widget olusturan method
    return TaskGroupWidget(
      taskGroup: taskGroup,
      onUpdate: () {
        update(); //Task uzerinde islem yapildigi zaman ui'yi gunceller
      },
    );
  }

  @override
  void update() {
    getListGroups(); //Veritabanindan guncell bilgilerle ui gunceller
  }


  ListView createListView() {
    //listGroup'lardan bir liste olusturur
    if (_listGroup == null) getListGroups(); // veri yoksa getirilir

    return ListView.builder(
        itemCount: _listGroup.length,
        itemBuilder: (BuildContext context, int position) {
          //map'a index uzerinden erisebilmek icin anahtarlari listeye donusturuyoruz
          List keys = _listGroup.keys.toList();

          String title = keys[position]; //positiondaki anahtar aliniyor

          return createTaskGroupWidget(
              _listGroup[title]); //TaskGroupWidget'i olusturur
        });
  }
}

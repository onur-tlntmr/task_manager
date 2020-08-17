import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/models/Task.dart';
import 'package:task_manager/models/TaskGroup.dart';
import 'package:task_manager/services/data_service/DataSource.dart';
import 'package:task_manager/services/data_service/Observer.dart';
import 'package:task_manager/ui/widgets/TaskGroupWidget.dart';

//Bir aylik eventleri gosteren sayfa
class MonthlyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    
    return MonthlyState();
  }
}

class MonthlyState extends State<MonthlyPage> with Observer {
  //Observer page !!!!

  final DataSource _dataSource = DataSource(); //Veri iletisimi icin gerekli
  Map<int, TaskGroup> _listGroup; //Tarihleri taskGroup olarak gruplar
  //Ornegin: 27 mayis 2020'deki tarihine sahip taskGrouplar

  @override
  Widget build(BuildContext context) {

    return Container(
      child: createListView(),
    );

  }

  ////////Observer nesne icin yonetim
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

////////////////////////////////////

  @override
  void update() {
    // Verilerde guncelleme olunca calisan method

    getListGroups(); //Veriler veritabanindan tekrar cekilir
  }

  void getListGroups() {
    //Verileri guncelleyen method
    Map<int, TaskGroup> list = Map();

    var taskFuture = _dataSource.getTasks();//db'den future olarak veriler alindi


    taskFuture.then((data) {//Future olarak alinan veri kendi tipine donusturuldu

      data.forEach((element) {
        // tum veriler gezildi
        Task task =
            Task.fromObject(element); //alinan veri task obj donusturuldu

        DateTime beginDate = task.beginDate; //Taskin baslangic zamani tutuluyor

        DateTime current = DateTime.now(); //Simdiki zaman

        DateTime afterOneMonth =
            current.add(new Duration(days: 30)); //Simdiki Zamandan bir ay sonrasi


        //İslem sonraki bir aylik zaman dilimi icersinde ise ve baslangic zamani gecmemis ise
        if (beginDate.isBefore(afterOneMonth) && current.isBefore(beginDate)) {

          int beginDay; //baslangic gunu

          beginDay = beginDate.day; //Gun atamasi yapiliyor

          if (!list.containsKey(beginDay)) {
            // daha once gune ait taskGroup yoksa collection'da bir tane olusturuluyor

            TaskGroup taskGroup = TaskGroup();

            //Baslik baslangic zamani ay gun olarak ayarlaniyor
            taskGroup.title = DateFormat.MMMd("tr_TR").format(task.beginDate);

            list.putIfAbsent(beginDay, () => taskGroup); //Collection'a ekleniyor
          }

          list[beginDay].taskList.add(task); //task kendi grubuna ekleniyor
        }
      });
    });

    setState(() {
      //State tetiklendi
      _listGroup = list;
    });
  }

  TaskGroupWidget createTaskGroupWidget(TaskGroup taskGroup) {
    //TaskGroup widget olsturuldu
    return TaskGroupWidget(
      taskGroup: taskGroup,
      onUpdate: () {
        update(); //Task uzerinde bir guncelleme yapilinca ui guncellenir
      },
    );
  }

  ListView createListView() {
    if (_listGroup == null) getListGroups(); //eger collection bos ise doldur

    return ListView.builder(
        //Colection'daki verilere gore listView olusturur
        itemCount: _listGroup.length,
        itemBuilder: (BuildContext context, int position) {
          //map'a index uzerinden erisebilmek icin anahtarlari listeye donusturuyoruz
          List keys = _listGroup.keys.toList();

          var key = keys[position]; //Position'daki key aliniyor

          return createTaskGroupWidget(_listGroup[key]); //Degerdeki taskGroup render ediliyor
        });
  }
}

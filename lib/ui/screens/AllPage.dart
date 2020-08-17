import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/models/Task.dart';
import 'package:task_manager/models/TaskGroup.dart';
import 'package:task_manager/services/data_service/DataSource.dart';
import 'package:task_manager/services/data_service/Observer.dart';
import 'package:task_manager/ui/widgets/TaskGroupWidget.dart';


//Tum eventleri gosteren sayfa
class AllPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    
    return AllState();
  }
}

class AllState extends State<AllPage> with Observer {
  //Observer page !!!!

  final DataSource _dataSource = DataSource(); //Veri iletisimi icin gerekli
  //
  Map<String, TaskGroup> _listGroup; //Tarihleri taskGroup olarak gruplar
  //Ornegin: 27 mayis 2020'deki tarihine sahip taskGrouplar

  @override
  Widget build(BuildContext context) {
    
    return Container(
      child: createListView(),
    );
  }

  ////////Observer nesne yonetimi
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

    getListGroups();
  }

  void getListGroups() {//Veritabanindan verileri cekip kendi icinde gruplar
    // map halinde saklar

    Map<String, TaskGroup> list = Map(); //Map yapisi Date Tarihi => TaskGroup

    var taskFuture = _dataSource.getTasks(); //tasklar future olarak aliniyor

    taskFuture.then((data) { //Future'dan kendi tipine donustuluyor
      //db'den future olarak veriler alindi

      data.forEach((element) {
        // tum veriler geziliyor
        Task task =
            Task.fromObject(element); //elemen olarak alinan veri task'a donusturuluyor


        String strDate = DateFormat.yMMMMd("tr_TR") //Tarihi gun, ay ve yil
            .format(task.beginDate);                //olarak formatlar

        if (!list.containsKey(strDate)) { //daha once map'ta oyle bir key yoksa

          TaskGroup taskGroup = TaskGroup(); //taskGroup olusturuluyor


          //Baslangic zamani 'gun ay yil' seklinde baslik olarak ekleniyor
          taskGroup.title = DateFormat.yMMMMd("tr_TR")
              .format(task.beginDate);

          list.putIfAbsent( //yeni eleman olarak ekleniyor
              strDate, () => taskGroup); //Task grubu, collection'a ekle
        }
        list[strDate].taskList.add(task); //Task gerekli taskGroup'a eklendi
      });
    });

    setState(() {
      //State tetiklendi
      _listGroup = list; //_listGroup guncellendi
    });
  }

  TaskGroupWidget createTaskGroupWidget(TaskGroup taskGroup) {
    //TaskGroup nesnesinden TaskGroupWidget olusturan method
    return TaskGroupWidget(
      taskGroup: taskGroup,
      onUpdate: () {
        update(); //TaskGroup'taki data guncellendiginde calisacak olan method
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

          var key = keys[position]; //anahtar aliniyor

          return createTaskGroupWidget(
              _listGroup[key]); //anahtardaki task group render ediliyor
        });
  }
}

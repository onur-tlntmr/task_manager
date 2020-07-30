import 'package:flutter/material.dart';
import 'package:task_manager/models/Task.dart';
import 'package:task_manager/models/TaskGroup.dart';
import 'package:task_manager/source/DataSource.dart';
import 'package:task_manager/source/Observer.dart';
import 'package:task_manager/ui/widgets/TaskGroupWidget.dart';
import 'package:task_manager/utils/Utils.dart';

class WeeklyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WeeklyState();
  }
}

class WeeklyState extends State<WeeklyPage> with Observer {

  final DataSource _dataSource = DataSource();
  final Utils _utils = Utils();

  Map<String, TaskGroup> _listGroup;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: createListView(),
    );
  }

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

  @override
  void update() {
    // TODO: implement update

    getListGroups();
  }

  void getListGroups() {
    Map<String, TaskGroup> list = Map();

    var taskFuture = _dataSource.getTasks();



      taskFuture.then((data) {
        //tasklari future olarak veritabanindan al
        data.forEach((element) {
          //icindeki her bir datayi kullan
          Task t = Task.fromObject(element); // datayi task'a donustur
          DateTime dateTime = t.beginDate;
          String day = _utils.getLocalDay(dateTime);

          DateTime afterOneWeek = DateTime.now().add(Duration(days: 7)); //Bir hafta sonrasini hesaplar

          //eger aranan gun ise ve en fazla bir hafta sonranin ise
          if (dateTime.isBefore(afterOneWeek)) {

            TaskGroup taskGroup = TaskGroup(); // Yeni bir taskGroup olusturuluyor
            taskGroup.title = day; //Basligina gun'u veriyoruz

            if (!list.containsKey(day)) // gun ekli degilse
              list.putIfAbsent(day, () => taskGroup); //ekle


            list[day].taskList.add(t); //task listesine de ekele
          }

      });
    });

    setState(() {//state tetikleniyor
      _listGroup = list;
    });
  }

  TaskGroupWidget createTaskGroupWidget(TaskGroup taskGroup) { //TaskGroup objesinden Widget olusturan method
    return TaskGroupWidget(
      taskGroup: taskGroup,
      onUpdate: () {
        update();
      },
    );
  }

  ListView createListView() { //listGroup'lardan bir liste olusturur
    if (_listGroup == null) getListGroups(); // veri yoksa getirilir

    return ListView.builder(
        itemCount: _listGroup.length,
        itemBuilder: (BuildContext context, int position) {

          //map'a index uzerinden erisebilmek icin anahtarlari listeye donusturuyoruz
          List keys = _listGroup.keys.toList();

          String title = keys[position]; //positiondaki anahtar aliniyor

          return createTaskGroupWidget(_listGroup[title]); //TaskGroupWidget'i olsturuluyor
        });
  }
}

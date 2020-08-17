import 'package:flutter/material.dart';
import 'package:task_manager/models/Task.dart';
import 'package:task_manager/services/data_service/DataSource.dart';
import 'package:task_manager/utils/DateUtils.dart';

//TaskCarWidget tasklari gosterir

class TaskCardWidget extends StatefulWidget {

  final Task task; //Task nesnesi

  final Function onUpdate; //Herhangi bir evente tetiklenecek method

  const TaskCardWidget({@required this.task, this.onUpdate});

  @override
  _TaskCardState createState() => _TaskCardState();

}

class _TaskCardState extends State<TaskCardWidget> {

  Map<String, IconData> iconMap = { //Duruma gore secilecek iconllar
    'waiting': Icons.access_time,
    'incomplete': Icons.cancel,
    'complete': Icons.check,
    'running': Icons.play_circle_outline
  };

  final DateUtils _utils = DateUtils(); //Saat tarih icin gerekli
  final DataSource _dataSource = DataSource(); //Eventler icin gerekli


  @override
  Widget build(BuildContext context) {
    //Ust siniftaki variable'lar aliniyor
    Task task = widget.task;

    //Zamanlarin formatlanmis sekli ornek olarak: '8 Agu 17:37'
    var _beginDate = _utils.dateFormatter(task.beginDate); //Baslangic zamani
    var _finishedDate = _utils.dateFormatter(task.finishedDate); //Bitis zamani


    return Card(

      child: ListTile(
        //Task'in basina durmunu belirten icon getirilir
        leading: IconButton(icon: Icon(iconMap[task.status]),onPressed: ()=>{},), //Onpressed bos birakiliyor
        title: Text(widget.task.title), //Card basligi olarak ta task'in basligi getirilir
        subtitle: Text("$_beginDate\n$_finishedDate"),//Altina da baslangic ve bitis tarihleri alt alta yazar

        onTap: () {
          checkedTask(task); //Task'a tiklaninca checkTask methodu cagirilir
        },

        trailing: IconButton( //Silme butonu
          icon: Icon(Icons.delete),
          onPressed: () {
            deleteTask(task); //tiklaninca deleteTask tetiklenir
          },
        ),

      ),

    );
  }

  void deleteTask(Task task) async { //Veri Tabanindan task silinir
    await _dataSource.delete(task);
    widget.onUpdate(); //UI'in guncellenmesi icin callback fonksiyon tetiklenir
  }

  void checkedTask(Task task) { //Taskin onaylanmasini saglayan method
    DateTime current = DateTime.now(); //Simdiki zaman

    if (task.status == "waiting" || task.status == //Task'in durumunu guncelleyen kosul:
        "running") { // Islem bekleyen veya devam eden durumda ise
      task.status = "complete"; //Tamamlandi olarak isaretlenir
      _dataSource.update(task); //Db guncellenir
      widget.onUpdate(); //UI icin callback func tetiklenir
    }

    //Task'in durumunu geri alan mehod
    else if (task.finishedDate.isAfter(current)) { //Eger task bitmemis ise

      if (task.beginDate.isAfter(current))
        task.status = "waiting";
      else
        task.status = "running";

      _dataSource.update(task); //Db guncelleniyor
      widget.onUpdate(); //UI icin callback func tetiklenir
    }
  }
}
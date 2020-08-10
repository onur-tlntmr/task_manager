
import 'package:flutter/material.dart';
import 'package:task_manager/models/Task.dart';
import 'package:task_manager/models/TaskGroup.dart';
import 'package:task_manager/ui/widgets/TaskCard.dart';

//Tasklari grup halinde gosterilmesini saglayan method
class TaskGroupWidget extends StatefulWidget{

  final TaskGroup taskGroup; //TaskGroup modeli
  final Function onUpdate; //Tasklarin etkilesimi icin callback function

  TaskGroupWidget({@required this.taskGroup,this.onUpdate});


  @override
  State<StatefulWidget> createState() {
    return GroupListState();
  }
}


class GroupListState extends State<TaskGroupWidget>{

  var screenHeight ; //Ekran yuksekligi

  List<Task> taskList;

  @override
  Widget build(BuildContext context) {

    screenHeight = MediaQuery.of(context).size.height; //ekranin yuksekligi atanir

    taskList  = widget.taskGroup.taskList; //tasklarin listesi

    return Column( //Title ve TaskListesi alt alta siralanir
      children: <Widget>[
        createHeader(),
        createListView(),
      ],
    );
  }


  Widget createHeader(){ //TaskGroup'un basligini olsuturan method
    return
      Container(
        alignment: Alignment.centerLeft,
        child: Text(
          widget.taskGroup.title,
          style: TextStyle(fontSize: screenHeight * 0.06, color: Colors.red[700]),
        ),
      );
  }

  Widget createListView() { //Tasklari listView'a ceviren method

    return ListView.builder(
        scrollDirection: Axis.vertical, //Dikey olarak scroll edilmesini saglar
        physics: ClampingScrollPhysics(),//Grouplar kendi aralarinda scroll edilmemesi icin gerekli
        shrinkWrap: true, //Nested listview kullanmak icin gerekli
        itemCount: taskList.length,
        itemBuilder: (BuildContext context, int position) {
          return TaskCardWidget(task: taskList[position],onUpdate: widget.onUpdate,); //Tasklist render ediliyor ve
                                                                              // callback method task'a gönderiliyor
        });
  }


}
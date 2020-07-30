
import 'package:flutter/material.dart';
import 'package:task_manager/models/Task.dart';
import 'package:task_manager/models/TaskGroup.dart';
import 'package:task_manager/ui/widgets/TaskCard.dart';

class TaskGroupWidget extends StatefulWidget{

  final TaskGroup taskGroup;
  final Function onUpdate;

  TaskGroupWidget({@required this.taskGroup,this.onUpdate});



  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return GroupListState();
  }
}


class GroupListState extends State<TaskGroupWidget>{

  var h ;

  List<Task> taskList;

  @override
  Widget build(BuildContext context) {

    h = MediaQuery.of(context).size.height; //ekranin boyu alinir

    taskList  = widget.taskGroup.taskList; //tasklarin listesi

    return Column(
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
          style: TextStyle(fontSize: h * 0.06, color: Colors.red[700]),
        ),
      );
  }

  Widget createListView() { //Tasklari listView'a ceviren method

    return ListView.builder(
        scrollDirection: Axis.vertical,
        physics: ClampingScrollPhysics(),//Grouplar kendi aralarinda scroll edilmemesi icin gerekli
        shrinkWrap: true, //Nested listview kullanmak icin gerekli
        itemCount: taskList.length,
        itemBuilder: (BuildContext context, int position) {
          return TaskCardWidget(task: taskList[position],onUpdate: widget.onUpdate,);
        });
  }


}
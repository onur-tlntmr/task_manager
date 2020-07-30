
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

    h = MediaQuery.of(context).size.height;

    print("Gün ${widget.taskGroup.title}");

    taskList  = widget.taskGroup.taskList;

    return Column(
      children: <Widget>[
        createHeader(),
        createListView(),
      ],
    );
  }


  Widget createHeader(){
    return
      Container(
        alignment: Alignment.centerLeft,
        child: Text(
          widget.taskGroup.title,
          style: TextStyle(fontSize: h * 0.06, color: Colors.red[700]),
        ),
      );
  }

  Widget createListView() {

    return ListView.builder(
        scrollDirection: Axis.vertical,
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: taskList.length,
        itemBuilder: (BuildContext context, int position) {
          return TaskCardWidget(task: taskList[position],onUpdate: widget.onUpdate,);
        });
  }


}
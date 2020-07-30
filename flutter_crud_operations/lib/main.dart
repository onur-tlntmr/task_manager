import 'package:flutter/material.dart';
import 'package:flutter_crud_operations/screens/noteList.dart';


void main() {
  runApp(MyApp());

}


class MyApp extends StatelessWidget {

  NoteList noteList;

  @override
  Widget build(BuildContext context) {


    noteList = NoteList();



    return MaterialApp(
      title: "Simpe Note",

      home: Scaffold(
        appBar: AppBar(
          title: Text("Simple Note"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: (){

              },
            )
          ],

        ),


        body: noteList,
      ),

    );
  }

//  void goToAdd(BuildContext context) async {
//    bool result = await Navigator.push(
//        context, MaterialPageRoute(builder: (context) => NoteAdd()));
//    if (result) getData();
//  }

}






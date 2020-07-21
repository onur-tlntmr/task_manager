import 'package:flutter/material.dart';
import 'package:flutter_crud_operations/screens/noteList.dart';


void main() {
  runApp(MyApp());

}


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: "CRUD Demo",

      home: Scaffold(
        appBar: AppBar(
          title: Text("Simple Note"),
        ),
        body: NoteList(),
      ),

    );
  }
}






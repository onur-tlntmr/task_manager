import 'package:flutter/material.dart';
import 'package:flutter_crud_operations/db/dbHelper.dart';
import 'package:flutter_crud_operations/model/Note.dart';

class NoteAdd extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NoteAddState();
  }
}

class NoteAddState extends State {

  DbHelper dbHelper = DbHelper();

  bool isUpdate = false;

  TextEditingController txtTitle = TextEditingController();
  TextEditingController txtContent = TextEditingController();

  var style = TextStyle(fontSize: 16, fontWeight: FontWeight.w400);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return WillPopScope(
      onWillPop: () async {

        return true;

      },
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("Add Note"),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 30, left: 10, right: 10),
          child: Column(
            children: <Widget>[
              TextField(
                controller: txtTitle,
                decoration: InputDecoration(
                    fillColor: Colors.blue,
                    filled: true,
                    labelText: "Title",
                    labelStyle: style),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: BoxDecoration(
                  color: Colors.amberAccent,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: TextField(
                  controller: txtContent,
                  decoration: InputDecoration(labelText: "Content"),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  expands: true,
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.check),
          onPressed: () {

            Note note = Note.withParams(txtTitle.text,txtContent.text);

            insertNote(note);
            goToList();
          },
        ),
      ),
    );
  }

  void insertNote(Note note){
    dbHelper.insert(note);
    isUpdate = true;
  }

  void goToList(){
    Navigator.pop(context, isUpdate);
  }

}

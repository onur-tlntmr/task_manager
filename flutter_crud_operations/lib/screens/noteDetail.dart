import 'package:flutter/material.dart';
import 'package:flutter_crud_operations/db/dbHelper.dart';
import 'package:flutter_crud_operations/model/Note.dart';

class NoteDetail extends StatefulWidget {
  Note note;

  NoteDetail(this.note);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NoteDetailState(note);
  }
}

class NoteDetailState extends State {
  DbHelper _dbHelper;
  Note note;
  final TextEditingController txtController = TextEditingController();

  bool isUpdate = false;

  NoteDetailState(this.note);


  @override
  void initState() {
    txtController.text = note.content;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    _dbHelper = DbHelper();


    return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, isUpdate);
          return true;
        },
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            title: Text(note.title),
          ),
          body: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.8,
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                decoration: BoxDecoration(
                    color: Colors.amberAccent,
                    borderRadius: (BorderRadius.all(Radius.circular(10)))),
                child: TextField(
                  maxLines: null,
                  autofocus: false,
                  keyboardType: TextInputType.multiline,
                  controller: txtController,
                  decoration: InputDecoration(border: InputBorder.none),

                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {

              note.content =txtController.text;
              _dbHelper.update(note);
              isUpdate = true;

            },
            child: Icon(Icons.update),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        ));
  }






  @override
  void dispose() {
    txtController.dispose();
    super.dispose();
  }
}

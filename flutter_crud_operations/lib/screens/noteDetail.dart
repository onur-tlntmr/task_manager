import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_operations/model/Note.dart';

class NoteDetail extends StatelessWidget {
  Note note;

  NoteDetail(this.note);

  final TextEditingController txtController = TextEditingController();
  FocusNode myFocusNode;





  @override
  Widget build(BuildContext context) {
      txtController.text = note.content;
      myFocusNode = FocusNode();
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(note.title),
      ),
      body: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.7,
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            decoration: BoxDecoration(
                color: Colors.amberAccent,
                borderRadius: (BorderRadius.all(Radius.circular(10)))),
            child: TextField(
              maxLines: null,
              autofocus: false,
              expands: true,
              keyboardType: TextInputType.multiline,
              controller: txtController,
              decoration: InputDecoration(border: InputBorder.none),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.update),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }


}



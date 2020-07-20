import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_operations/db/DbHelper.dart';
import 'package:flutter_crud_operations/model/Note.dart';

class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NoteListState();
  }

}

class NoteListState extends State {
  final DbHelper dbHelper = DbHelper();

  List<Note> notes;

  @override
  Widget build(BuildContext context) {
    if (notes == null) {
      notes = List();
      getData();
    }

    return Scaffold(
      body: noteListItems(),
    );
  }

  ListView noteListItems() {
    return ListView.builder(
        itemCount: notes.length,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            color: Colors.amberAccent,
            elevation: 2,
            child: ListTile(
              leading: CircleAvatar(
                child: Text("A"),
              ),
              title: Text(this.notes[position].title),
              subtitle: Text(this.notes[position].content),
              onTap: () {
                print("Note: Title: "+this.notes[position].title);
              },

            ),
          );
        }
    );
  }



  void getData(){
    var noteFuture = dbHelper.getNotes(); //notelari future seklinde alir

    noteFuture.then((data){ // data list tipinde alinir
      List<Note> noteData = List(); // yeni liste olsuturlur

      // veriler note tipine donusturulerek yeni listeye eklenir
      data.forEach((element) {noteData.add(Note.fromObject(element));});

      setState(() {
        notes = noteData; // yeni liste sinif'a gonderilir

      });

    });

  }

}

import 'package:flutter/material.dart';
import 'package:flutter_crud_operations/db/DbHelper.dart';
import 'package:flutter_crud_operations/model/Note.dart';
import 'package:flutter_crud_operations/screens/noteAdd.dart';
import 'package:flutter_crud_operations/screens/noteDetail.dart';

class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NoteListState();
  }
}

class NoteListState extends State {
  final DbHelper dbHelper = DbHelper(); //db operationlari icin

  List<Note> notes; // notlarin bulundugu yapi

  @override
  Widget build(BuildContext context) { // bos ise veriler eklenir
    if (notes == null) {
      notes = List();
      getData();
        }

  return Scaffold(
        body: noteListItems(), floatingActionButton: floatingActionButton());
  }

  ListView noteListItems() { //note itemler liste yapilir
    return ListView.builder(
        itemCount: notes.length,
        itemBuilder: (BuildContext context, int position) {
          return createCard(notes[position]);
        });
  }

  Card createCard(Note note) { //note objesinden card'i olusturan method
    return Card(
      color: Colors.amberAccent,
      elevation: 2,
      child: ListTile(
        title: Text(
          note.title,
          maxLines: 1, //title tek satir olmasi icin
        ),
        subtitle: Text(
          note.content,
          maxLines: 2, // en icerik en fazla iki satir olabilir
        ),
        onTap: () {
          goToDetail(note); // tiklaninca noteDetail sayfasina gider
        },
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () => {deleteNote(note)}, //silme operasiyonu
        ),
      ),
    );
  }

  void getData() {
    var noteFuture =  dbHelper.getNotes(); //notelari future seklinde alir

    noteFuture.then((data) {
      // data list tipinde alinir
      List<Note> noteData = List(); // yeni liste olsuturlur

      // veriler note tipine donusturulerek yeni listeye eklenir
      data.forEach((element) {
        noteData.add(Note.fromObject(element));
      });

      setState(() {
        notes = noteData; // yeni liste sinif'a gonderilir
      });
    });
  }

  void goToDetail(Note note) async { //detail goturen method
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => NoteDetail(note))); //note bilgisiyle donderilir

    if (result) getData(); //geri gelirken guncelleme gerekiyorsa ekran guncellenir
  }

  void goToAdd() async {
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => NoteAdd()));
    if (result) getData();
  }

  void deleteNote(Note note) async{
    int result = await dbHelper.delete(note.id);
    if(result == 1)
      getData();
  }

  FloatingActionButton floatingActionButton() {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        goToAdd();
      },
    );
  }
}

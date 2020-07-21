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

  bool isInsert = false;
  TextEditingController titleController = TextEditingController(); // text degerlerini almak icin gerekli
  TextEditingController contentController = TextEditingController();

  var style = TextStyle(fontSize: 16, fontWeight: FontWeight.w400);


  bool titleIsNotBlank() {//basligin bos olup olamadigini bildiren method
    String str = titleController.text.trim();
    return str.isNotEmpty;
  }

  @override
  void initState() {

  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return WillPopScope(
      onWillPop: () async {

        if(titleIsNotBlank()) { // eger baslik bos degilse
          Note note = Note.withParams(titleController.text, contentController.text); //yeni note olsutur
          await insertNote(note); //kaydedilmesini bekle

        }

          Navigator.pop(context, isInsert); //sonra onceki ekrana git

        return true; //geri gidilmesi icin gerekli
      },
      child: Scaffold(
        resizeToAvoidBottomPadding: false, //klavye acilinca ekran tasmamasi icin gerekli
        appBar: AppBar(
          title: Text("Add Note"),
        ),
        body: Padding(
            padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
            child: mainWidget()),


      ),
    );
  }

  Widget mainWidget() {
    return Column(
      children: <Widget>[
        TextField(
          controller: titleController,
          decoration: InputDecoration(
              fillColor: Colors.blue,
              filled: true,
              labelText: "Title",
              labelStyle: style),
        ),
        Container(
          margin: EdgeInsets.only(top: 5),
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: Colors.amberAccent,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: TextField(
            controller: contentController,
            decoration: InputDecoration(labelText: "Content"),
            keyboardType: TextInputType.multiline,
            maxLines: null,
            expands: true,
          ),
        )
      ],
    );
  }

  void insertNote(Note note) async { // not ekleyen method
    var result = await dbHelper.insert(note);

    if (result != 1)
      this.isInsert = true;


  }







}

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
  final TextEditingController txtController = TextEditingController(); //content controller objesi

  bool isUpdate = false; // Yeni icerigin durumu belirten degisken

  NoteDetailState(this.note); // note objesi constructor ile aliniyor


  @override
  void initState() { //ilk olusturuldugunda
    txtController.text = note.content; // eskinote content'in icine yazilir
    _dbHelper = DbHelper(); //udate operasyonu icin gerekli
    txtController.addListener(() { //content degisirse
      note.content = txtController.text; //note objesi guncellenir
      updateContent(); // veri tabani guncellenir
    });
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return WillPopScope( //geri gitme eventi icin gerekli
        onWillPop: () async {
          Navigator.pop(context, isUpdate); // geri gidilince guncelleme bilgiside gonderilir
          return true;
        },
        child: Scaffold(
          resizeToAvoidBottomPadding: false, //klavye cikince ekranda tasma olmamamsi icin
          appBar: AppBar(
            title: Text(note.title), //baslik note basligi ile guncellenir
          ),
          body: detailView()
        ));
  }


Widget detailView(){
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width, // ekranin tum genisligi alinir
          height: MediaQuery.of(context).size.height * 0.8, //uzunlugun %80'i alinir
          margin: EdgeInsets.all(5), //her yerden 5 margin verilir
          decoration: BoxDecoration(
              color: Colors.amberAccent, //rengi
              borderRadius: (BorderRadius.all(Radius.circular(10)))),
          child: TextField(
            maxLines: null, //satir sayisi en buyuk olarak secilir
            autofocus: false, // girilir girilme duzenleme acilmamasi icin
            keyboardType: TextInputType.multiline,
            controller: txtController, //onceki controller atanir
            decoration: InputDecoration(border: InputBorder.none), // cerceve iptal edilri

          ),
        ),
      ],
    );
}





void updateContent () async{ //content i db'den guncelleyen method
   var result =  await _dbHelper.update(note);

   if(result==1) // ekleme basariliysa
    this.isUpdate = true; // note listesine ger doner
}

  @override
  void dispose() { //life cycle'dan cikirinca
    txtController.dispose(); // controller de cikariliyor
    super.dispose();
  }
}

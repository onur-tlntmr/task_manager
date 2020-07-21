class Note {
  int _id;
  String _title;
  String _content;

  Note(this._title);

  Note.withParams(this._title, this._content);

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get title => _title;

  String get content => _content;

  set content(String value) {
    _content = value;
  }

  set title(String value) {
    _title = value;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map["id"] = _id;
    map["title"] = _title;
    map["content"] = _content;

    return map;
  }

  Note.fromObject(dynamic o){
    this._id = o["Id"];
    this._title = o["Title"];
    this._content = o["Content"];
  }

}

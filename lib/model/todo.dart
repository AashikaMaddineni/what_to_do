import 'package:flutter/material.dart';

class ToDoItem extends StatelessWidget {
  int _id;
  String _itemName;
  String _itemContent;
  String _dateCreated;


  ToDoItem(this._itemName, this._itemContent, this._dateCreated);

  ToDoItem.map(dynamic obj) {
    this._itemName = obj["itemName"];
    this._itemContent = obj["itemContent"];
    this._dateCreated = obj["dateCreated"];
    this._id = obj["id"];
  }

  String get itemName => _itemName;
  String get itemContent => _itemContent;
  String get dateCreated => _dateCreated;
  int get id => _id;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["itemName"] = _itemName;
    map["itemContent"] = _itemContent;
    map["dateCreated"] = _dateCreated;

    if (_id != null) {
      map["id"] = _id;
    }

    return map;
  }

  ToDoItem.fromMap(Map<String, dynamic> map) {
    this._itemName = map["itemName"];
    this._itemContent = map["itemContent"];
    this._dateCreated = map["dateCreated"];
    this._id = map["id"];
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.all(8.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(
                _itemName,
                style: new TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.9),
              ),
              new Text(
                _itemContent,
                style: new TextStyle(
                    color: Colors.black,
                    fontSize: 14.9),
              ),
              new Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: new Text(
                  "Created on: $_dateCreated",
                  style: new TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontStyle: FontStyle.italic),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

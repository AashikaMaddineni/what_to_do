import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:what_to_do/model/todo.dart';
import 'package:what_to_do/util/database_client.dart';
import 'package:what_to_do/util/date_formatter.dart';

class RemainderScreen extends StatefulWidget {
  @override
  _RemainderScreenState createState() => new _RemainderScreenState();
}

class _RemainderScreenState extends State<RemainderScreen> {
  TextEditingController controller = new TextEditingController();
  final TextEditingController _textEditingController =
  new TextEditingController();
  final TextEditingController _textEditingController1 =
  new TextEditingController();
  var db = new DatabaseHelper();
  final List<ToDoItem> _itemList = <ToDoItem>[];

  @override
  void initState() {
    super.initState();
    _textEditingController.clear();
    _textEditingController1.clear();
    _readDoList();
  }

  void _handleSubmitted(String text, String text1) async {
    _textEditingController.clear();
    _textEditingController1.clear();
    ToDoItem noDoItem = new ToDoItem(text, text1, dateFormatted());
    int savedItemId = await db.saveItem(noDoItem);
    ToDoItem addedItem = await db.getItem(savedItemId);
    setState(() {
      _itemList.insert(0, addedItem);
    });
    print("Item saved id: $savedItemId");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: Text("QuickRemainder"),
        backgroundColor: Colors.red,
        actions: <Widget>[

          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: (
                ) {
            },
          ),
          Padding(
            padding: EdgeInsets.only(right: 15.0),
          ),
        ],
      ),
      body: new Column(
        children: <Widget>[
          new Flexible(
            child: new ListView.builder(
                padding: new EdgeInsets.all(8.0),
                reverse: false,
                itemCount: _itemList.length,
                itemBuilder: (_, int index) {
                  return new Card(
                    color: Colors.white,
                    child: new ListTile(
                      title: (_itemList[index]),
                      onLongPress: () => _udateItem(_itemList[index], index),
                      trailing: new Listener(
                        key: new Key(_itemList[index].itemName),
                         child: new Icon(
                          Icons.remove_circle,
                          color: Colors.redAccent,
                        ),
                        onPointerDown: (pointerEvent) =>
                            _deleteToDo(_itemList[index].id, index),
                  ),
                    ),
                  );
                }),
          ),
          new Divider(
            height: 1.0,
          )
        ],
      ),
      floatingActionButton: new FloatingActionButton(
          tooltip: "Add Item",
          backgroundColor: Colors.redAccent,
          child: new ListTile(
            title: new Icon(Icons.add),
          ),
          onPressed: _showFormDialog),
    );
  }

  void _showFormDialog() {
    var alert = new AlertDialog(
      content: new Column(
         children: <Widget>[
          Container(
              child:
              new TextField(
                  controller: _textEditingController,
                  autofocus: true,
                  decoration: new InputDecoration(
                  labelText: "Heading",
                  hintText: "eg. Wakeup fast",
                  icon: new Icon(Icons.note_add, color: Colors.red, ))
              ),
          ),
           new Expanded(
             child:
             new TextField(
                 maxLines: null,
                 keyboardType: TextInputType.multiline,
                 controller: _textEditingController1,
                 autofocus: true,
                 decoration: new InputDecoration(
                     labelText: "Description",
                     hintText: "eg. Do some exercise",
                     icon: new Icon(Icons.article_sharp,color: Colors.red,))
             ),

           ),

         ],
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () {
              _handleSubmitted(_textEditingController.text, _textEditingController1.text);
              _textEditingController.clear();
              _textEditingController1.clear();
              Navigator.pop(context);
            },
            child: Text("Save")),
        new FlatButton(
            onPressed: () => Navigator.pop(context), child: Text("Cancel"))
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  _readDoList() async {
    List items = await db.getItems();
    items.forEach((item) {
      // NoDoItem noDoItem = NoDoItem.fromMap(item);
      setState(() {
        _itemList.add(ToDoItem.map(item));
      });
      // print("Db items: ${noDoItem.itemName}");
    });
  }

  _deleteToDo(int id, int index) async {
    debugPrint("Deleted Item!");

    await db.deleteItem(id);
    setState(() {
      _itemList.removeAt(index);
    });
  }

  _udateItem(ToDoItem item, int index) {
    _textEditingController.text = _itemList[index].itemName;
    _textEditingController1.text = _itemList[index].itemContent;
    var alert = new AlertDialog(
      title: new Text("Update Item"),
      content: new Column(
        children: <Widget>[
          Container(
            child:
            new TextField(
                style: new TextStyle(
                  color: Colors.red,
                ),
                controller: _textEditingController,
                autofocus: true,
                decoration: new InputDecoration(
                    icon: new Icon(Icons.note_add, color: Colors.red, ))
            ),
          ),

          new Expanded(
              child: new TextField(
                style: new TextStyle(
                    color: Colors.red,
                    ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
                controller: _textEditingController1,
                autofocus: true,
                decoration: new InputDecoration(
                    icon: new Icon(Icons.article_sharp,color: Colors.red,)),
              ))
        ],
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () async {
              ToDoItem newItemUpdated = ToDoItem.fromMap({
                "itemName": _textEditingController.text,
                "itemContent": _textEditingController1.text,
                "dateCreated": dateFormatted(),
                "id": item.id
              });

              _handleSubmittedUpdate(index, item); //redrawing the screen
              await db.updateItem(newItemUpdated); //updating the item
              setState(() {
                _readDoList(); // redrawing the screen with all items saved in the db
              });
              Navigator.pop(context);
            },
            child: new Text("Update")),

        new FlatButton(
                  onPressed: () async {
                 _textEditingController.clear();
                 _textEditingController1.clear();
                },
                   child: new Text("Clear")),

         new FlatButton(
            onPressed: () => Navigator.pop(context), child: new Text("Cancel")),

      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  void _handleSubmittedUpdate(int index, ToDoItem item) {
    setState(() {
      _itemList.removeWhere((element) {
        _itemList[index].itemName == item.itemName;
        _itemList[index].itemContent == item.itemContent;
      });
    });
  }

}

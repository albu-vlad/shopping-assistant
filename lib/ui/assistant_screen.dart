import 'package:flutter/material.dart';
import 'package:shopping_assistant/model/shopping_item.dart';
import 'package:shopping_assistant/uitil/database_client.dart';
import 'package:shopping_assistant/uitil/date_formater.dart';

class AssistantScreen extends StatefulWidget {
  @override
  _AssistantScreenState createState() => new _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  final TextEditingController _textEditingController = new TextEditingController();
  var db = new DatabaseHelper();
  final List<ShoppingItem> _itemList = <ShoppingItem>[];


  @override
  void initState() {
    super.initState();
    _readShoppingItemList();
  }

  void _handleSubmit(String text) async {
    _textEditingController.clear();
    ShoppingItem shoppingItem = new ShoppingItem(text, dateFormatted());
    int savedItemId = await  db.saveItem(shoppingItem);

    ShoppingItem addedItem = await db.getItem(savedItemId);
    setState(() {
      _itemList.insert(0, addedItem);
    });
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      body: new Column(
        children: <Widget>[
          new Flexible(child:
              new ListView.builder(
                padding: new EdgeInsets.all(8.0),
                reverse: false,
                itemCount: _itemList.length,
                itemBuilder: (_, int index){
                  return new Card(
                    color: Colors.white,
                    child:  new ListTile(
                      title: _itemList[index],
                      onLongPress: () =>
                          _updateShoppingItem(_itemList[index], index),
                      trailing: new Listener(
                        key: new Key(_itemList[index].itemName),
                        child: new Icon(Icons.remove_circle_outline,
                          color: Colors.pinkAccent,
                        ),
                        onPointerDown: (pointerEvent) =>
                        _deleteShoppingItem(_itemList[index].id, index),
                      ),
                    ),
                  );
                }
              ),
          ),
          new Divider(
            height: 1.0,
          ),
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        tooltip: "Add new Item",
        backgroundColor: Colors.pinkAccent,
        child: new ListTile(
          title: new Icon(Icons.add),
        ),
        onPressed: _showFormDialogue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

 void _showFormDialogue() {
    var alert = new AlertDialog(
      content: new Row(
        children: <Widget>[
          new Expanded(child: new TextField(
            controller:  _textEditingController,
            autofocus: true,
            decoration: new InputDecoration(
              labelText: "Item",
              hintText: "eg. buy item",
              icon: new Icon(Icons.note_add)
            ),
          ))
        ],
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: (){
              _handleSubmit(_textEditingController.text);
              _textEditingController.clear();
              Navigator.pop(context);
            },
            child: Text("Save")
        ),
        new FlatButton(onPressed: () => Navigator.pop(context),
            child: Text("Cancel")
        )
      ],
    );
    showDialog(context: context,
        builder: (_) {
          return alert;
        });
 }
  _readShoppingItemList() async {
    List items = await db.getItems();
    items.forEach((item) {
//      ShoppingItem shoppingItem = new ShoppingItem.map(items);
      setState(() {
        _itemList.add(ShoppingItem.map(item));
      });
    });
  }

  _deleteShoppingItem(int id, int index) async {
    await db.deleteItem(id);

    setState(() {
      _itemList.removeAt(index);
    });
  }

  _updateShoppingItem(ShoppingItem item, int index) {
    var alert = new AlertDialog(
      title: new Text("Update item"),
      content: new Row(
        children: <Widget>[
          new Expanded(child: new TextField(
            controller:  _textEditingController,
            autofocus: true,
            decoration: new InputDecoration(
                labelText: "Item",
                hintText: "eg. edit item",
                icon: new Icon(Icons.update)
            ),
          ))
        ],
      ),
      actions: <Widget>[
        new FlatButton(
            onPressed: () async {
              ShoppingItem newItemUpdated = ShoppingItem.fromMap(
                {
                  "itemName": _textEditingController.text,
                  "dateCreated": dateFormatted(),
                  "id": item.id
                }
              );
              _handleSubmitUpdate(index, item );

              await db.updateItem(newItemUpdated);
              setState(() {
                _readShoppingItemList();
              });
              _textEditingController.clear();
              Navigator.pop(context);
            },
            child: Text("Update")
        ),
        new FlatButton(onPressed: () => Navigator.pop(context),
            child: Text("Cancel")
        )
      ],
    );
    showDialog(context: context,
        builder: (_) {
          return alert;
        });
  }

  void _handleSubmitUpdate(int index, ShoppingItem item) {
    setState(() {
      _itemList.removeWhere((element) {
        _itemList[index].itemName == item.itemName;
      });

    });
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/enums/ErrorEnum.dart';
import 'package:todo/models/item.dart';
import 'package:todo/util/toastUtil.dart';

class Home extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  var items = List<Item>();

  _HomePageState() {
    _load();
  }

  int count = 0;
  final List<int> colorCodes = <int>[600, 500, 100, 200];
  var item = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Center(child: Icon(Icons.menu)),
        title: TextFormField(
          controller: item,
          key: Key('title'),
          keyboardType: TextInputType.text,
          style: TextStyle(color: Colors.white, fontSize: 17),
          decoration: InputDecoration(labelText: "Novo item"),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text('Total items: ${items.length}')),
          )
        ],
      ),
      body: _listView(context),
      floatingActionButton: _floatingActionButton(),
    );
  }

  _floatingActionButton() {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: _add,
    );
  }

  _listView(BuildContext context) {
    return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, int index) {
          var item = items[index];
          return Card(
            child: ListTile(
              // leading: FlutterLogo(size: 56.0),
              leading: Checkbox(
                  value: item.done,
                  key: Key(item.id.toString()),
                  onChanged: (value) {
                    setState(() {
                      item.done = value;
                    });
                    _save();
                  }),
              title: Text(item.title),
              subtitle: Text(item.description.toString()),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _remove(item);
                },
              ),
            ),
          );
        });
  }

  _add() {
    if (item.text.isEmpty) {
      ToastUtil.showMessage('Favor preencher o nome do item!', ErrorEnum.ERROR.toString().split('.').last);
      return;
    }

    setState(() {
      items.add(new Item(
          id: items.length + 1,
          title: item.text,
          description: null,
          done: false));
    });

    item.clear();

    _save();
  }

  _remove(Item item) {
    setState(() {
      items.removeWhere((x) => x.id == item.id);
    });

    _save();
  }

  Future _load() async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('items');

    if (data != null) {
      Iterable decode = jsonDecode(data);
      List<Item> items = decode.map((f) => Item.fromJson(f)).toList();

      if (items != null) {
        this.items = items;
      }
    }
  }

  _save() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('items', jsonEncode(items));
  }
}

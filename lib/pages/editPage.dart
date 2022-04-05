import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:oyojoho/pages/mainPage.dart';

class EditPage extends StatefulWidget {
  EditPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() {
    return EditPageState();
  }
}

class EditPageState extends State<EditPage> {
  String titleValue = "";
  String titleBody = "";
  int nowIndex = 0;
  int argsIndex = 0;

  void changeItem(lyricsListArgs, nowIndex, num) {
    if (nowIndex + num < 0) {
      return;
    }
    // print(lyricsListArgs[nowIndex]);
    // print(nowIndex);
    // print(num);
    // print(lyricsListArgs[nowIndex + num]);
    // print(lyricsListArgs[nowIndex + num][0]);
    // print(lyricsListArgs[nowIndex + num][1]);
    setState(() {
      this.titleValue = lyricsListArgs[nowIndex + num][1];
      this.titleBody = lyricsListArgs[nowIndex + num][0];
      this.nowIndex = nowIndex + num;
    });
  }

  @override
  Widget build(BuildContext context) {
    final LyricsArguments args = ModalRoute.of(context).settings.arguments;

    // @override
    // void initState() {
    if(argsIndex != args.index) {
      // print(args.index);
      setState(() {
        this.titleValue = args.title;
        this.titleBody = args.body;
        this.nowIndex = args.index;
        this.argsIndex = args.index;
      });
    }

    return new Scaffold(
        appBar: new AppBar(title: new Text('Navigator')),
        body: new Container(
            padding: new EdgeInsets.all(32.0),
            child: new Center(
                child: new Column(children: <Widget>[
              Container(
                margin: new EdgeInsets.all(0.0),
                padding: new EdgeInsets.all(12.0),
                child: Text(
                  titleValue,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.red,
                  ),
                ),
              ),
              Container(
                margin: new EdgeInsets.all(0.0),
                padding: new EdgeInsets.all(12.0),
                child: (titleBody.length > 200
                    ? Text(
                        titleBody,
                        style: TextStyle(fontSize: 12),
                      )
                    : Text(titleBody)),
              ),
            ]))),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: IconButton(
                  onPressed: () {
                    changeItem(args.lyricsListNew, nowIndex, -1);
                  },
                  icon: Icon(Icons.arrow_back)),
              label: '前',
            ),
            BottomNavigationBarItem(
              icon: IconButton(
                  onPressed: () {
                    changeItem(args.lyricsListNew, nowIndex, 1);
                  },
                  icon: Icon(Icons.arrow_forward)),
              label: '後',
            ),
          ],
        ));
  }
}

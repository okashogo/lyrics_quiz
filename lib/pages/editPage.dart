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
  String _textTitle = '';
  String _textBody = '';

  void _handleTextTitle(String title) {
    // print('before title:' + title);
    setState(() {
      _textTitle = title;
    });
    // print('after title:' + title);
  }

  void _handleTextBody(String body) {
    // print('before body:' + body);
    setState(() {
      _textBody = body;
    });
    // print('after body:' + _textBody);
  }

  void deleteLyrics(String initTitle) async {
    var client = http.Client();
    try {
      var requestTitle = _textTitle;
      print(initTitle);

      if (_textTitle == "") {
        requestTitle = initTitle;
      }
      print('requestTitle:' + requestTitle);
      print('https://l3e7bib57k.execute-api.us-east-1.amazonaws.com/prod?title=' + requestTitle);

      var url = Uri.parse('https://l3e7bib57k.execute-api.us-east-1.amazonaws.com/prod?title=' + requestTitle);
      var response = await http.delete(
        url,
        // body: jsonEncode({
        //   'title': _textTitle,
        // }),
        headers: {"Content-Type": "application/json"},
      );
      // client.delete(url,
      // headers: {"Content-Type": "application/json"},
      // body: jsonEncode({
      //     'title': _textTitle,
      //   }))
      print(response);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      Navigator.of(context).pop();
    } finally {
      client.close();
    }
  }

  void addLyrics(String initTitle, String initBody) async {
    var client = http.Client();

    var requestTitle = _textTitle;
    var requestBody = _textBody;

    if (_textTitle == "") {
      requestTitle = initTitle;
    }
    if (_textBody == "") {
      requestBody = initBody;
    }
    print('requestTitle:' + requestTitle);
    print('requestBody:' + requestBody);
    if (requestTitle != "" || requestBody != "") {
      try {
        var url = Uri.parse(
            'https://l3e7bib57k.execute-api.us-east-1.amazonaws.com/prod/');
        var response = await http.post(
          url,
          body: jsonEncode({
            'title': requestTitle,
            'body': requestBody,
          }),
          headers: {"Content-Type": "application/json"},
        );
        print(response);
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        Navigator.of(context).pop();
      } finally {
        client.close();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final LyricsArguments args = ModalRoute.of(context).settings.arguments;

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Navigator'),
      ),
      body: new Container(
        padding: new EdgeInsets.all(32.0),
        child: new Center(
            child: new Column(
          children: <Widget>[
            Text('名前'),
            TextFormField(
                initialValue: args.title,
                enabled: true,
                // 入力数
                style: TextStyle(color: Colors.red),
                obscureText: false,
                maxLines: 1,
                onChanged: _handleTextTitle,
              ),
            Container(
              padding: new EdgeInsets.all(20.0),
              child: Text('説明'),
            ),
            Container(
              padding: new EdgeInsets.all(12.0),
              child: Text(args.body),
            ),
            // TextField(
            //   enabled: true,
            //   // 入力数
            //   style: TextStyle(color: Colors.red),
            //   obscureText: false,
            //   maxLines: 1,
            //   onChanged: _handleTextSongTitle,
            //   // controller: TextFormField(initialValue,: args.title),
            // ),
            // Text('説明'),
            // Text(args.body),
            // TextFormField(
            //   initialValue: args.body,
            //   enabled: true,
            //   // 入力数
            //   style: TextStyle(color: Colors.black),
            //   obscureText: false,
            //   maxLines: 1,
            //   onChanged: _handleTextBody,
            // ),
            // ElevatedButton(
            //   onPressed: () => addLyrics(args.title, args.body),
            //   child: new Text('追加'),
            //   style: ElevatedButton.styleFrom(
            //     primary: Colors.green, //ボタンの背景色
            //   ),
            // ),
            // ElevatedButton(
            //   onPressed: () => deleteLyrics(args.title),
            //   child: new Text('削除'),
            //   style: ElevatedButton.styleFrom(
            //     primary: Colors.red, //ボタンの背景色
            //   ),
            // ),
            // ElevatedButton(
            //   onPressed: () => Navigator.of(context).pop(),
            //   child: new Text('戻る'),
            // ),
          ],
        )),
      ),
    );
  }
}

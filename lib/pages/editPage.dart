import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:lyrics_quiz/pages/mainPage.dart';

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

  void deleteLyrics() async {
    var client = http.Client();
    try {
      var url = Uri.parse('https://l3e7bib57k.execute-api.us-east-1.amazonaws.com/prod/');
      var response = await http.post(
        url,
        body: jsonEncode({
          'title': _textTitle,
          'body': _textBody,
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

  void addLyrics(String initTitle, String initBody) async {
    var client = http.Client();
    if (_textTitle != "") {
      setState(() {
        _textBody = initTitle;
      });
    }
    if (_textBody != "") {
      setState(() {
        _textBody = initBody;
      });
    }
    print('title:' + _textTitle);
    print('title:' + _textTitle);
    print('body:' + _textBody);
    if (_textTitle != "" || _textBody != "") {
      try {
        var url = Uri.parse(
            'https://l3e7bib57k.execute-api.us-east-1.amazonaws.com/prod/');
        var response = await http.post(
          url,
          body: jsonEncode({
            'title': _textTitle,
            'body': _textBody,
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
            Text('歌手、曲名(大塚愛の、さくらんぼ)'),
            TextFormField(
              initialValue: args.title,
              enabled: true,
              // 入力数
              style: TextStyle(color: Colors.red),
              obscureText: false,
              maxLines: 1,
              onChanged: _handleTextTitle,
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
            Text('歌詞'),
            TextFormField(
              initialValue: args.body,
              enabled: true,
              // 入力数
              style: TextStyle(color: Colors.black),
              obscureText: false,
              maxLines: 1,
              onChanged: _handleTextBody,
            ),
            ElevatedButton(
              onPressed: () => addLyrics(args.title, args.body),
              child: new Text('追加'),
              style: ElevatedButton.styleFrom(
                primary: Colors.green, //ボタンの背景色
              ),
            ),
            ElevatedButton(
              // onPressed: () => deleteLyrics(args.title),
              child: new Text('削除'),
              style: ElevatedButton.styleFrom(
                primary: Colors.red, //ボタンの背景色
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: new Text('戻る'),
            ),
          ],
        )),
      ),
    );
  }
}

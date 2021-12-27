import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddPage extends StatefulWidget {
  AddPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() {
    return AddPageState();
  }
}

class AddPageState extends State<AddPage> {
  String _textTitle = '';
  String _textBody = '';
  void _handleTextSongTitle(String title) {
    print(title);
    setState(() {
      _textTitle = title;
    });
  }

  void _handleTextlyrics(String body) {
    setState(() {
      _textBody = body;
    });
  }

  void addLyrics() async {
    var client = http.Client();
    try {
      var url = Uri.parse(
          'https://l3e7bib57k.execute-api.us-east-1.amazonaws.com/prod/');
      var response = await http.post(url,
        body: jsonEncode({
          'title': _textTitle,
          'body': _textBody,
        }),
        headers: {
          "Content-Type": "application/json"
        },
      );
      print(response);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      Navigator.of(context).pop();
    } finally {
      client.close();
    }
  }

  @override
  Widget build(BuildContext context) {
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
            TextField(
              enabled: true,
              // 入力数
              style: TextStyle(color: Colors.red),
              obscureText: false,
              maxLines: 1,
              onChanged: _handleTextSongTitle,
            ),
            Text('歌詞'),
            TextField(
              enabled: true,
              // 入力数
              style: TextStyle(color: Colors.black),
              obscureText: false,
              maxLines: 1,
              onChanged: _handleTextlyrics,
            ),
            ElevatedButton(
              onPressed: addLyrics,
              child: new Text('追加'),
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

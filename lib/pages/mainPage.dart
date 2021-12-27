import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }
}

class MainPageState extends State<MainPage> {
  final title = '歌詞当てクイズ';

  final String _value = '';

  List<List<String>> lyricsListNew = [];

  @override
  void initState() {
    super.initState();

    print("initState!!!");
    cached();
  }

  void cached() async {
    var client = http.Client();
    try {
      var url = Uri.parse(
          'https://l3e7bib57k.execute-api.us-east-1.amazonaws.com/prod/');
      var response = await http.get(url);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      Map<String, dynamic> responseList = jsonDecode(response.body);
      print(responseList);
      print(responseList['Items']);
      print("responseItem");
      List<List<String>> lyricsListTmp = [];
      for (var responseItem in responseList['Items']) {
        print(responseItem['title']);
        print(responseItem['body']);
        lyricsListTmp.add([
          responseItem['body'],
          responseItem['title'],
        ]);
      }

      print(lyricsListTmp);
      setState(() {
        lyricsListNew = lyricsListTmp;
      });

      // print(await client.get(uri));
    } finally {
      client.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text(title),
          backgroundColor: Colors.orange,
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.cached,
                color: Colors.white,
              ),
              onPressed: cached,
            ),
            IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pushNamed("/add").then((value) => cached()),
            ),
          ],
        ),
        body: ListView(
            children: lyricsListNew
                .map(
                  (lyrics) => ListTile(
                      leading: Icon(
                        Icons.music_note,
                      ),
                      title: Text(lyrics[0].length >= 10
                          ? lyrics[0].substring(0, 10)
                          : lyrics[0]),
                      onTap: () => ttsSpeak(lyrics[0]),
                      onLongPress: () => {},
                      trailing: IconButton(
                          onPressed: () => ttsSpeak('正解は、、、' + lyrics[1]),
                          icon: Icon(Icons.recommend))),
                )
                .toList())
        );
  }
}

ttsSpeak(String text) async {
  WidgetsFlutterBinding.ensureInitialized();
  final FlutterTts tts = FlutterTts();
  await tts.setSpeechRate(0.4);
  await tts.setVolume(1.0);
  await tts.speak(text);
}

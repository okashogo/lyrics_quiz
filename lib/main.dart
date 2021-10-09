import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  final title = '歌詞当てクイズ';
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView(
          children: lyricsList
              .map(
                (lyrics) => ListTile(
                  leading: Icon(
                    Icons.map,
                  ),
                  title: Text(lyrics.substring(0, 5)),
                  onTap: () => ttsSpeak(lyrics),
                ),
              )
              .toList()),
      // body: ListView(children: [
      //   ListTile(
      //     leading: Icon(
      //       Icons.map,
      //     ),
      //     title: Text(lyricsList[0].substring(0, 5)),
      //     onTap: () => ttsSpeak(0),
      //   ),
      //   ListTile(
      //     leading: Icon(Icons.photo_album),
      //     title: Text(lyricsList[1].substring(0, 5)),
      //     onTap: () => ttsSpeak(1),
      //   ),
      //   ListTile(
      //     leading: Icon(Icons.phone),
      //     title: Text(lyricsList[2].substring(0, 5)),
      //     onTap: () => ttsSpeak(2),
      //   ),
      // ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // await tts.setVoice({'name': 'ja-jp-x-jab-local', 'locale': 'ja-JP'});
          // await tts.setVoice({'name': 'ja-jp-x-jad-local', 'locale': 'ja-JP'});
          // await tts.setVoice({'name': 'ja-jp-x-jac-local', 'locale': 'ja-JP'});
          // await tts.setVoice({'name': 'ja-jp-x-htm-local', 'locale': 'ja-JP'});

          // text
          // await tts.speak(
          //       '手帳を開くと、もう、'
          //       '2年たつなぁって、'
          //       'やっぱり、実感するね、、'
          //       'なんだか、照れたりするね、、'
          //       'そういや、ひどいこともされたし、、'
          //       'ひどいことも、いったし、、',
          // );
        },
        child: Icon(Icons.play_arrow),
      ),
    ),
  ));
}

ttsSpeak(String text) async {
  WidgetsFlutterBinding.ensureInitialized();
  final FlutterTts tts = FlutterTts();
  await tts.setSpeechRate(0.4);
  await tts.speak(text);
}

const List<String> lyricsList = const <String>[
  '手帳を開くと、もう、'
      '2年たつなぁって、'
      'やっぱり、実感するね、、'
      'なんだか、照れたりするね、、'
      'そういや、ひどいこともされたし、、'
      'ひどいことも、いったし、、',
  '泥だらけの、走馬灯に酔う、こわばる心、'
      '震える手は、掴みたいものがある、それだけさ、、'
      '夜の匂いに、空睨んでも、'
      '変わっていけるのは、自分自身だけ、それだけさ',
  '君の髪や、瞳だけで、胸が痛いよ、、'
      '同じ時を、吸いこんで、離したくないよ、、'
      '遥か昔から知る、その声に、'
      '生まれて、はじめて、何を言えばいい？',
  '少し間が空いて、君がうなずいて、僕らの心、満たされてく、あいで、'
      'ぼくらまだ旅の途中で、またこれから先も、'
      '何十年続いていけるような未来へ',
  '友達の嘘も、'
      '転がされる愛も、'
      '何から信じていいんでしょうね、、'
      '大人になってもきっと、'
      '宝物は褪せないよ、'
      '大丈夫だから、'
      '今わさ、'
      '青に飛び込んで居よう',
  '握りしめた手、離すことなく、思いは強く、永遠誓う、、'
      '永遠の淵、きっと僕は言う、思い変わらず、同じ言葉を、'
      'それでも足りず、涙にかわり、喜びになり、'
      '言葉にできず、ただ抱きしめる',
  'あの手紙は、すぐにでも、捨てて欲しい、と言ったのに、'
      '少しだけ眠い、冷たい水で、こじあけて、'
      '今、せかされるように、飛ばされるように、通り過ぎてく',
  'いつの時代も、悲しみを、避けては、通れないけれど、'
      '笑顔を見せて、今を生きていこう、'
      '今を生きていこう',
];
// void main() {
//   runApp(MyApp());
// }

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

import 'package:oyojoho/pages/csv/ouyoujouhoTango.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }
}

class MainPageState extends State<MainPage> {
  final String title = '応用情報';

  final String _value = '';

  List<List<String>> lyricsListNew = [];
  bool repeatMode = false;
  int global_lyrics_count = 0;
  int sleep_time = 3;

  @override
  void initState() {
    super.initState();

    print("initState!!!");
    cached();
  }

  void cached() async {
    OyojohoTango oyojohoTangoList = OyojohoTango();
    List<Map<String, String>> responseList =
        oyojohoTangoList.oyojohoTangoList();
    // print(responseList);
    // print(responseList['Items']);
    // print("responseItem");
    List<List<String>> lyricsListTmp = [];
    for (var responseItem in responseList) {
      // print(responseItem['title']);
      // print(responseItem['body']);
      lyricsListTmp.add([
        responseItem['body'],
        responseItem['title'],
      ]);
    }

    // print(lyricsListTmp);
    setState(() {
      lyricsListNew = lyricsListTmp;
      global_lyrics_count = 0;
    });
  }

  void shuffle() async {
    List<List<String>> lyricsListTmp = lyricsListNew;
    lyricsListTmp.shuffle(new Random());
    setState(() {
      lyricsListNew = lyricsListTmp;
      global_lyrics_count = 0;
    });
  }

  var _scrollController = ScrollController();
  void repeat() async {
    setState(() {
      repeatMode = !repeatMode;
    });
    int lyrics_count = 0;
    for (var lyricsItem in lyricsListNew) {
      lyrics_count++;
      if (repeatMode && lyrics_count > global_lyrics_count) {
        setState(() {
          global_lyrics_count = lyrics_count;
        });
        await ttsSpeak(lyricsItem[1]);
        await Future.delayed(Duration(seconds: sleep_time));
        // print('aaaa');
        // print(_scrollController.position.maxScrollExtent * lyrics_count / lyricsListNew.length);
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent * (lyrics_count > 4 ? lyrics_count - 4 : 0) / lyricsListNew.length,
          duration: Duration(seconds: 1),
          curve: Curves.bounceOut,
        );
        if (lyrics_count == lyricsListNew.length) {
          setState(() {
            repeatMode = !repeatMode;
            global_lyrics_count = 0;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // var _scrollController = ScrollController();
    return new Scaffold(
        appBar: AppBar(
          title: Text(title),
          backgroundColor: Colors.orange,
          centerTitle: false,
          actions: <Widget>[
            DropdownButton<String>(
              value: sleep_time.toString(),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String newValue) {
                setState(() {
                  sleep_time = int.parse(newValue);
                });
              },
              items: <String>[
                '0',
                '1',
                '2',
                '3',
                '4',
                '5',
                '6',
                '7',
                '8',
                '9',
                '10'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            IconButton(
              icon: Icon(
                (repeatMode) ? Icons.pause : Icons.repeat,
                color: Colors.white,
              ),
              onPressed: repeat,
            ),
            IconButton(
              icon: Icon(
                Icons.shuffle,
                color: Colors.white,
              ),
              onPressed: shuffle,
            ),
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
              onPressed: () => Navigator.of(context)
                  .pushNamed("/add")
                  .then((value) => cached()),
            ),
          ],
        ),
        body: Scrollbar(
            child: ListView(
                controller: _scrollController,
                children: lyricsListNew.length != 0
                    ? lyricsListNew
                        .asMap()
                        .map((index, lyrics) => MapEntry(
                              index,
                              ListTile(
                                  leading: Icon(
                                    (index + 1 > global_lyrics_count)
                                        ? Icons.music_note
                                        : Icons.music_off,
                                  ),
                                  title: Text(lyrics[1]),
                                  onTap: () => ttsSpeak(lyrics[0]),
                                  onLongPress: () =>
                                      Navigator.of(context).pushNamed("/edit",
                                          arguments: LyricsArguments(
                                            lyrics[1],
                                            lyrics[0],
                                            index,
                                            lyricsListNew,
                                          )),
                                  trailing: IconButton(
                                      onPressed: () => ttsSpeak(lyrics[1]),
                                      icon: Icon(Icons.recommend))),
                            ))
                        .values
                        .toList()
                    : lyricsList
                        .map(
                          (lyrics) => ListTile(
                              leading: Icon(
                                Icons.music_note,
                              ),
                              title: Text(lyrics[0].length >= 10
                                  ? lyrics[0].substring(0, 10)
                                  : lyrics[0]),
                              onTap: () => ttsSpeak(lyrics[0]),
                              onLongPress: () => Navigator.of(context)
                                  .pushNamed("/edit",
                                      arguments: LyricsArguments(
                                        lyrics[1],
                                        lyrics[0],
                                        1,
                                        lyricsList,
                                      ))
                                  .then((value) => cached()),
                              trailing: IconButton(
                                  onPressed: () =>
                                      ttsSpeak('正解は、、、' + lyrics[1]),
                                  icon: Icon(Icons.recommend))),
                        )
                        .toList())));
  }
}

class LyricsArguments {
  final String title;
  final String body;
  final int index;
  final List<List<String>> lyricsListNew;

  LyricsArguments(this.title, this.body, this.index, this.lyricsListNew);
}

const List<List<String>> lyricsList = const <List<String>>[
  [
    '手帳を開くと、もう、'
        '2年たつなぁって、'
        'やっぱり、実感するね、、'
        'なんだか、照れたりするね、、'
        'そういや、ひどいこともされたし、、'
        'ひどいことも、いったし、、',
    '大塚愛の、さくらんぼ'
  ],
  [
    '泥だらけの、走馬灯に酔う、こわばる心、'
        '震える手は、掴みたいものがある、それだけさ、、'
        '夜の匂いに、空睨んでも、'
        '変わっていけるのは、自分自身だけ、それだけさ',
    'リサの、ぐれんげ'
  ],
  [
    '君の髪や、瞳だけで、胸が痛いよ、、'
        '同じ時を、吸いこんで、離したくないよ、、'
        '遥か昔から知る、その声に、'
        '生まれて、はじめて、何を言えばいい？',
    'ラッドウィンプスの、ぜんぜんぜんせ'
  ],
  [
    '少しまが空いて、君がうなずいて、僕らの心、満たされてく、あいで、'
        'ぼくらまだ旅の途中で、またこれから先も、'
        '何十年続いていけるような未来へ',
    'グリーンの、キセキ'
  ],
  [
    '友達の嘘も、'
        '転がされる愛も、'
        '何から信じていいんでしょうね、、'
        '大人になってもきっと、'
        '宝物は褪せないよ、'
        '大丈夫だから、',
    'ミセス、グリーンアップルの、青と夏'
  ],
  [
    '永遠の淵、きっと僕は言う、思い変わらず、同じ言葉を、'
        'それでも足りず、涙にかわり、喜びになり、'
        '言葉にできず、ただ抱きしめる',
    'モンゴル八百の、小さな恋の歌'
  ],
  [
    'あの手紙は、すぐにでも、捨てて欲しい、と言ったのに、'
        '少しだけ眠い、冷たい水で、こじあけて、'
        '今、せかされるように、飛ばされるように、通り過ぎてく',
    'スピッツの、チェリー'
  ],
  [
    '今、負けそうで、泣きそうで、消えてしまいそうな、僕は、'
        '誰の言葉を、信じ歩けばいいの？'
        'ひとつしかないこの胸が、何度もばらばらに割れて'
        '苦しい中で、今を生きている'
        '今を生きている',
    'アンジェラアキの、手紙'
  ],
  [
    '始まりは、なんとなくで、君の声も、知らなくて、'
        '同じ帰り道で、少し前、歩いてたよね、'
        '夕焼け染まる背中が、振り返り、目があったとき、'
        '赤く染めた頬を、空の色の、せいにした',
    'グリーンの、オレンジ'
  ],
  [
    '渋滞のもと、'
        '熱にうかされ、舵をとるのさ、'
        'ホコリかぶってた、宝の地図も、'
        '確かめたのなら、伝説じゃない！、',
    'きただにひろしの、ウィーアー'
  ],
  [
    'プルクンギ、チュキョドゥルゴ、チンギョッケガダ、'
        'チォンデルル、アプセウゴ、トゥルリョッケガダ、'
        'イルシンイ、チョンマンデオ、イックルゴガヌン、、'
        'クモスムン、、ソングンギチダ、'
        'コンギョッ、コンギョ、コンギョガップロ',
    '北朝鮮軍歌の、攻撃戦だ'
  ],
  [
    '傷ついた、夢は、昨日の彼方へ、'
        '空に響け、愛の歌、'
        '思い出ずっと、ずっと、忘れない空、ふたりが、離れていっても、'
        'こんな、好きな人に、出逢う季節、二度とない',
    '嵐の、ラブソースイート'
  ],
  [
    '何も変わらない、穏やかなまち並み、'
        'みんな、夏が来たって、浮かれ気分なのに、君は一人、さえない顔、してるネ、'
        'そうだ、君に見せたい物が、あるんだ、'
        '大きな、五時半の、ゆうやけ、子供の頃と、同じように、',
    'ゆずの、夏色'
  ],
  [
    '青く晴れた日を、笑う太陽、'
        '溢れる希望、むすぶ靴ひもに、期待のせて、'
        '風を連れて、夢の種、植えるため、今走り出そう、',
    '湘南乃風の、睡蓮花'
  ],
  [
    '僕の手を、掴んでほら、'
        '忘れてしまいたくて、閉じ込めた日々も、'
        '抱きしめた、温もりで、溶かすから、'
        '怖くないよ、いつか日が、昇るまで、'
        '二人で、いよう',
    'ヨアソビの、夜に駆ける'
  ],
  [
    '夏は、あつ過ぎて、'
        '僕から、気持ちは、重すぎて、'
        '一緒に、わたるには、'
        'きっと、船が、沈んじゃう、'
        'どうぞ、ゆきなさい、'
        'お先に、ゆきなさい',
    'ヒトトヨウの、ハナミズキ'
  ],
  [
    'まぶしすぎて、'
        'お祭りの、夜は、胸が、騒いだよ、'
        'はぐれそうな、人ごみの中、'
        '「はなれないで」、出しかけた、手を、'
        'ポケットに、入れて、握りしめていた',
    'ホワイトベリーの、夏祭り'
  ],
  [
    '蒼い風が、いま、胸の、ドアを、叩いても、'
        '私だけを、ただ、見つめて、'
        'ほほえんでる、あなた、'
        'そっと、ふれるもの、もとめることに、夢中で、'
        '運命さえ、まだ、知らない、いたいけな瞳',
    '高橋洋子の、残酷な天使のテーゼ'
  ],
  [
    '分かっているのに、おもいは、揺らぐ、'
        '結末ばかりに、きをとられ、このときを、楽しめない、'
        '夢じゃない、あれも、これも、その手で、ドアを、開けましょう',
    'ビーズの、ウルトラソウル'
  ],
  [
    'あなたの、いない、右側に、'
        '少しは、慣れたつもりで、いたのに、'
        'どうして、こんなに涙が、出るの、'
        'もう、叶わない想いなら、'
        'あなたを、忘れる勇気だけ、欲しいよ',
    'プリンセスプリンセスの、M'
  ],
  [
    '手のひらで震えた、それが、小さな勇気に、なっていたんだ、'
        '絵文字は苦手だった、だけど、君からだったら、ワクワクしちゃう',
    'ゆいの、チェリー'
  ],
  [
    '忘れないで、すぐそばに僕がいる、いつの日も、'
        '星空を眺めている、一人きりの夜明けも、'
        'たった一つの心、悲しみに暮れないで、',
    'つじあやのの、風になる'
  ],
  [
    '険しい修羅の、道の中、ひとの地図を広げて、何処へ行く？'
        '極彩色のカラスが、それを奪い取って破り捨てた、'
        'さぁ心の目、見開いて、しかといまを見極めろ！Yeah！'
        '失うモノなんてないさ、いざ参ろう！',
    'フロウのゴウ'
  ],
  [
    '慣れてしまえば、悪くはないけど、'
        '君とのロマンスは、人生柄、'
        '続きはしないことを知った、'
        'もっと違う設定で、もっと違う関係で、'
        '出会える世界線、選べたらよかった',
    'オフィシャルヒゲダンディズムの、プレテンダー'
  ],
  [
    '君のトコへ走ったとして、実は僕の方が'
        '悪い意味で、夏の魔法的なもので、舞い上がってましたって、怖すぎる'
        'オチばかり浮かんできて、'
        '真夏の空の下で、震えながら、君の事を考えます、',
    'バックナンバーの、高嶺の花子さん'
  ],
  [
    '見上げる空の青さを、気まぐれに雲は流れ、'
        'キレイなものは、遠くにあるからキレイなの、'
        '約束したとおり、あなたと'
        'ここに来られて、本当に良かったわ',
    'スーパーフライの、愛を込めて花束を'
  ],
  [
    '最後にあなたが教えてくれた、'
        '言えずに隠してた、くらい過去も、'
        'あなたがいなきゃ永遠に、くらいまま、'
        'きっともうこれ以上、傷つくことなど、'
        'ありはしないとわかっている',
    '米津玄師の、レモン'
  ],
  [
    '自分との闘い勝てば、'
        '大切な人に会えるはずさ、'
        '頑張っていれば、'
        'お天道様が必ず微笑んでくれるさ、'
        'もう一度君に包まれたくて、'
        '走り抜けて来たよ、いくつもの季節を',
    '睡蓮花'
  ],
  [
    '星はいくつ見えるか、'
        '何も見えない夜か、'
        '元気が出ないそんな時は、'
        '誰かと話そう、'
        '人は思うよりも、'
        '一人ぼっちじゃないんだ、'
        'すぐそばのやさしさに、'
        '気づかずにいるだけ',
    '365日の紙飛行機'
  ],
  [
    '営みの街が暮れたら色めき、'
        '風たちは運ぶわ、'
        'カラスと人々の群れ、'
        '意味なんかないさ、暮らしがあるだけ',
    '星野源の恋'
  ],
  [
    'でんぐり返しの日々、'
        '可哀想なふりをして、'
        'だらけてみたけど、'
        '希望の光は、'
        '目の前でずっと輝いている、幸せだ、',
    'あいみょんのマリーゴールド'
  ],
  [
    'とても大事なキミの想いは、'
        '無駄にならない、世界は廻る、'
        'ほんの少しの、僕の気持ちも、'
        '巡り巡るよ',
    'パヒュームのポリリズム'
  ],
  [
    '遊びまわり、日差しの街、'
        '誰かが呼んでいる、'
        '夏が来る、影が立つ、あなたに会いたい、'
        '見つけたのはいちばん星',
    'フーリンのパプリカ'
  ],
  [
    '溢れ出す光の粒が、'
        '少しずつ朝を暖めます、'
        '大きなあくびをしたあとに、'
        '少し照れてるあなたの横で、'
        '新たな世界の入口に立ち、'
        '気づいたことは、1人じゃないってこと',
    'レミオロメンのさんがつここのか'
  ],
  [
    '勝ち誇るように笑われても、それほどイヤじゃないよ、'
        '生まれてくる前、聞いたようなその深い声、'
        'それだけで、人生のオカズになれるくらいです',
    'ビーズのイチブトゼンブ'
  ],
  [
    '僕は君の全てなど、知ってはいないだろう、'
        'それでも一億人から君を見つけたよ、'
        '根拠はないけど、本気で思ってるんだ、'
        '些細な言い合いもなくて、同じ時間を生きてなどいけない、'
        '素直になれないなら、喜びも悲しみも虚しいだけ',
    'レミオロメンの粉雪'
  ],
  [
    '午前二時、フミキリに、望遠鏡をかついで、いった、'
        'ベルトに結んだラジオ、雨は降らないらしい、'
        '二分後に君が来た、大袈裟な荷物しょって来た、'
        '始めようか',
    'バンプオブチキンの天体観測'
  ],
];

ttsSpeak(String text) async {
  WidgetsFlutterBinding.ensureInitialized();
  final FlutterTts tts = FlutterTts();
  await tts.setSpeechRate(0.4);
  await tts.setVolume(1.0);
  await tts.setIosAudioCategory(IosTextToSpeechAudioCategory.ambient, [
    IosTextToSpeechAudioCategoryOptions.allowBluetooth,
    IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
    IosTextToSpeechAudioCategoryOptions.mixWithOthers
  ]);
  await tts.awaitSpeakCompletion(true);
  await tts.speak(text);
}

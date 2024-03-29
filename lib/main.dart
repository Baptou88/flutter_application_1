import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter_application_1/graph.dart';
import 'package:flutter_application_1/second.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/websocket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'firebase_options.dart';

import 'fetch_list.dart';
import 'graph_3.dart';
import 'data_etang.dart';
import 'graph2.dart';

final Uri wsUri = Uri.parse('ws://hydro.hydro-babiat.ovh/ws');
Future<void> main() async {
  //create a ws channel
  final channel = WebSocketChannel.connect(wsUri);
  channel.stream.listen((data) {
    log(data);
  }, onError: (error) => log(error));
  runApp(const MyApp());
  log("par là");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // Add the 5 lines from here...
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 146, 62, 62),
          foregroundColor: Colors.black,
        ),
      ),
      //home: const RandomWords(),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Tabs'),
              bottom: const TabBar(tabs: [
                Tab(icon: Icon(Icons.directions_car)),
                Tab(icon: Icon(Icons.railway_alert)),
                Tab(icon: Icon(Icons.directions_bike))
              ]),
            ),
            body: const TabBarView(children: [
              RandomWords(),
              //Icon(Icons.directions),
              Icon(Icons.directions),
              Icon(Icons.directions)
            ])),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      //_counter++;
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
      body: const Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: RandomWords(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({super.key});

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _sugg = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18);
  final _saved = <WordPair>{};

  void _pushItem1() {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("tefdsfrf"),
          ),
          body: Column(
            children: <Widget>[
              const Text('Deliver features faster'),
              const Text('Craft beautiful UIs'),
              const Placeholder(
                fallbackHeight: 100,
                fallbackWidth: 50,
              ),
              ElevatedButton(onPressed: () {}, child: const Text("er")),
              const Expanded(
                child: FittedBox(
                  child: FlutterLogo(),
                ),
              ),
            ],
          ),
        );
      },
    ));
  }

  void _pushSaved() {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (context) {
        final tiles = _saved.map((e) {
          return ListTile(
            title: Text(
              e.asPascalCase,
              style: _biggerFont,
            ),
          );
        });
        final divided = tiles.isNotEmpty
            ? ListTile.divideTiles(
                context: context,
                tiles: tiles,
              ).toList()
            : <Widget>[];

        return Scaffold(
          appBar: AppBar(
            title: const Text('Saved'),
          ),
          body: ListView(children: divided),
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startu Name Generator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushSaved,
            tooltip: 'Saved Suggestions',
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) {
            return const Divider();
          }
          final index = i ~/ 2;

          if (index >= _sugg.length) {
            _sugg.addAll(generateWordPairs().take(10));
          }
          final alreadySaved = _saved.contains(_sugg[index]);
          var color = const Color.fromARGB(255, 161, 46, 46);
          if (index.isOdd) {
            color = const Color.fromARGB(255, 64, 39, 151);
          }

          return ListTile(
            title: Text(
              _sugg[index].asPascalCase,
              style: _biggerFont,
            ),
            trailing: Icon(
              alreadySaved ? Icons.favorite : Icons.favorite_border,
              color: alreadySaved ? Colors.red : null,
              semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
            ),
            onTap: () {
              setState(() {
                if (alreadySaved) {
                  _saved.remove(_sugg[index]);
                } else {
                  _saved.add(_sugg[index]);
                }
              });
            },
            textColor: color,
          );
        },
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Text("test"),
            ),
            ListTile(
              title: const Text('item 1'),
              onTap: () {
                log("passe par là");
                _pushItem1();
                //Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("el 2"),
              onTap: () {
                //Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Second()),
                );
              },
            ),
            ListTile(
              title: const Text("graph"),
              onTap: () {
                //Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Graph()),
                );
              },
            ),
            ListTile(
              title: const Text("graph2"),
              onTap: () {
                //Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Graph2()),
                );
              },
            ),
            ListTile(
              title: const Text("graph3"),
              onTap: () {
                //Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Graph3()),
                );
              },
            ),
            ListTile(
              title: const Text("dataEtang"),
              onTap: () {
                //Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DataEtang()),
                );
              },
            ),
            ListTile(
              title: const Text("websocket"),
              onTap: () {
                //Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Websocket()),
                );
              },
            ),
            ListTile(
              title: const Text("fetch list"),
              onTap: () {
                //Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FetchList()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

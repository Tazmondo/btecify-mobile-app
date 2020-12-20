import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Name Gen',
      home: RandomWords(),
      theme: ThemeData(
          // colorScheme: ColorScheme(
          //     primary: Colors.black87,
          //     primaryVariant: Colors.black87,
          //     secondary: Colors.black87,
          //     secondaryVariant: Colors.black87,
          //     surface: Colors.white,
          //     background: Colors.black87,
          //     error: Colors.white,
          //     onPrimary: Colors.white,
          //     onSecondary: Colors.white,
          //     onSurface: Colors.white,
          //     onBackground: Colors.white,
          //     onError: Colors.white,
          //     brightness: Brightness.dark),
          brightness: Brightness.dark),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({
    Key key,
  }) : super(key: key);

  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = Set<WordPair>();
  final _biggerFont = TextStyle(fontSize: 18.0);

  void _pushSaved() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      final tiles = _saved.map((e) => ListTile(
            title: Text(
              e.asPascalCase,
              style: _biggerFont,
            ),
          ));

      final divided =
          ListTile.divideTiles(tiles: tiles, context: context).toList();

      return Scaffold(
          appBar: AppBar(
            title: Text("Saved names"),
          ),
          body: ListView(children: divided));
    }));
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);

    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      selected: alreadySaved,
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: EdgeInsets.all(24.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider();

        final index = i ~/ 2;
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(18));
        }
        return _buildRow(_suggestions[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Startup name generator"),
        actions: [IconButton(icon: Icon(Icons.list), onPressed: _pushSaved)],
      ),
      body: _buildSuggestions(),
    );
  }
}

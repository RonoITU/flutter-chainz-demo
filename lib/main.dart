import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const HashTableDemo(title: 'Separate Chaining Demo'),
    );
  }
}

class HashTableDemo extends StatefulWidget {
  const HashTableDemo({super.key, required this.title});

  final String title;

  @override
  State<HashTableDemo> createState() => _HashTableDemoState();
}

class _HashTableDemoState extends State<HashTableDemo> {
  List<int> _numbers = [];
  List<SearchChainModel> _chains =
      List.generate(4, (int index) => SearchChainModel());

  void _addNextInteger() {
    setState(() {
      var x = Random().nextInt(1024);
      _numbers.add(x);
      _chains[x % _chains.length].addNumber(x);
    });
  }

  List<Widget> _getChainBody() {
    List<SearchChain> body = [];
    for (var i = 0; i < _chains.length; i++) {
      body.add(SearchChain(name: '$i', model: _chains[i]));
    }
    return body;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _getChainBody(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNextInteger,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class SearchChainModel with ChangeNotifier {
  List<int> _numbers = [];
  List<int> get numbers => _numbers.toList();

  void addNumber(int x) {
    _numbers.add(x);
    notifyListeners();
  }
}

class SearchChain extends StatelessWidget {
  final String name;
  final SearchChainModel model;

  const SearchChain({super.key, required this.name, required this.model});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ListenableBuilder(
            listenable: model,
            builder: (BuildContext context, Widget? child) {
              var contents = <Widget>[];

              contents.add(Container(
                  margin: EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 0.0),
                  child: Text('$name →')));

              final List<int> values = model.numbers;

              for (final n in values) {
                contents.add(Container(
                  alignment: Alignment.center,
                  height: 24,
                  width: 32,
                  margin: EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
                  color: Colors.lightBlue,
                  child: Text('$n'),
                ));
              }

              return Wrap(
                children: contents,
              );
            }));
  }
}

/*
class _SearchChainState extends State<SearchChain> {
  @override
  Widget build(BuildContext context) {
    var contents = <Widget>[];

    contents.add(Container(
        margin: EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 0.0),
        child: Text('${widget.name} →')));

    for (final n in _numbers) {
      contents.add(Container(
        alignment: Alignment.center,
        height: 24,
        width: 32,
        margin: EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
        color: Colors.lightBlue,
        child: Text('$n'),
      ));
    }

    return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center, children: contents);
  }
}
*/

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
  List<int> _numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
  List<SearchChain> _chains =
      List.generate(4, (int index) => SearchChain(name: '$index'));

  void _incrementCounter() {
    setState(() {
      for (var i = 0; i < _numbers.length; i++) {
        _numbers[i] = Random().nextInt(90);
      }
    });
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
          children: _chains,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class SearchChain extends StatefulWidget {
  final String name;

  const SearchChain({super.key, required this.name});

  @override
  State<StatefulWidget> createState() => _SearchChainState();
}

class _SearchChainState extends State<SearchChain> {
  List<int> _numbers = [10, 20, 30];

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

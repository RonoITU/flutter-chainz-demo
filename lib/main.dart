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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> _numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9];

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
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 32.0,
              children: <Widget>[
                SearchChain(name: '0'),
                SearchChain(name: '1'),
                SearchChain(name: '2'),
                SearchChain(name: '3'),
              ],
            ),
            const Text(
              'Symbol table with 2 chains.',
            ),
          ],
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
  const SearchChain({super.key, required this.name});

  final String name;

  @override
  State<StatefulWidget> createState() => _SearchChainState();
}

class _SearchChainState extends State<SearchChain> {
  List<int> _numbers = [];

  void addNumber(int n) {
    setState(() {
      _numbers.add(n);
    });
  }

  @override
  Widget build(BuildContext context) {
    var c = <Widget>[];

    for (final n in _numbers) {
      c.add(Container(
        alignment: Alignment.center,
        height: 24,
        width: 32,
        margin: EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
        color: Colors.lightBlue,
        child: Text('$n'),
      ));
    }

    c.add(Text(widget.name));

    return Column(children: c);
  }
}

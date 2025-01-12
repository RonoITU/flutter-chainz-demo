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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
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
  var _random = Random();
  List<int> _primes = [53, 47, 43, 41, 37, 31, 29, 23, 19, 17, 13, 11, 7, 5];
  List<int> _numbers = [];
  List<SearchChainModel> _chains =
      List.generate(4, (int index) => SearchChainModel());
  int _x = 0, _x4 = 0, _x1024 = 0;

  void _reset() {
    setState(() {
    _primes = [53, 47, 43, 41, 37, 31, 29, 23, 19, 17, 13, 11, 7, 5];
    _numbers = [];
    _chains =
      List.generate(4, (int index) => SearchChainModel());
      _x = 0; _x4 = 0; _x1024 = 0;
    });
  }

  void _addNextInteger() {
    _addToSymbolTable(_x);
    _x++;
  }

  void _addNext4Integer() {
    _addToSymbolTable(_x4);
    _x4 += 4;
  }

  void _addNext1024Integer() {
    _addToSymbolTable(_x1024);
    _x1024 += 1024;
  }

  void _addNextRandomInteger() {
    var number = _random.nextInt(99_999);
    _addToSymbolTable(number);
  }

  void _addToSymbolTable(int x) {
    setState(() {
      _numbers.add(x);
      _chains[x % _chains.length].addNumber(x);
    });
  }

  void plusOneRebuild() {
    setState(() {
      _chains =
          List.generate(_chains.length + 1, (int index) => SearchChainModel());
      for (final num in _numbers) {
        _chains[num % _chains.length].addNumber(num);
      }
    });
  }

  void _doubleChainsRebuild() {
    setState(() {
      _chains =
          List.generate(_chains.length * 2, (int index) => SearchChainModel());
      for (final num in _numbers) {
        _chains[num % _chains.length].addNumber(num);
      }
    });
  }

  void _primeRebuild() {
    if (_primes.isEmpty) return;
    var nextPrime = _primes.removeLast();
    setState(() {
      _chains =
          List.generate(nextPrime, (int index) => SearchChainModel());
      for (final num in _numbers) {
        _chains[num % _chains.length].addNumber(num);
      }
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
        child: ListView(
          children: _getChainBody(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _reset,
        tooltip: 'Reset',
        child: const Icon(Icons.restart_alt),
      ),
      persistentFooterButtons: [
        TextButton(
          onPressed: _addNextInteger,
          child: Text('Sequential'),
        ),
        TextButton(
          onPressed: _addNextRandomInteger,
          child: Text('Random'),
        ),
        TextButton(
          onPressed: _addNext4Integer,
          child: Text('4\'s'),
        ),
        TextButton(
          onPressed: _addNext1024Integer,
          child: Text('1024\'s'),
        ),
        TextButton(
          onPressed: plusOneRebuild,
          child: Text('+1 Rebuild'),
        ),
        TextButton(
          onPressed: _doubleChainsRebuild,
          child: Text('Double Rebuild'),
        ),
        TextButton(
          onPressed: _primeRebuild,
          child: Text('Prime Rebuild'),
        ),
      ],
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
    return Align(
        alignment: Alignment.centerLeft,
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
                  width: 48,
                  margin: EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
                  color: const Color.fromARGB(255, 173, 229, 255),
                  child: Text('$n'),
                ));
              }

              return Wrap(
                children: contents,
              );
            }));
  }
}

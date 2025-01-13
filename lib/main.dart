import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const Application());
}

class Application extends StatelessWidget {
  const Application({super.key});

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
  final Random _random = Random();
  final List<int> _primes = [11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 
                             47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 
                             97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 
                             149, 151, 157, 163, 167, 173];

  List<int> _numbers = [];

  List<SearchChainModel> _chains =
      List.generate(4, (int index) => SearchChainModel());

  int _x = 0, _x4 = 0, _x1024 = 0;

  bool _usingPrimes = false;
  int _primeInUse = 13;

  void _reset() {
    setState(() {
      _numbers = [];
      _chains =
        List.generate(4, (int index) => SearchChainModel());
      _x = 0; _x4 = 0; _x1024 = 0;
      _primeInUse = 13;
    });
  }

  void _addNextInteger() {
    setState(() {
      _numbers.add(_x);
      _addOnChains(_x);
      _x++;
    });
  }

  void _addNext4Integer() {
    setState(() {
      _numbers.add(_x4);
      _addOnChains(_x4);
      _x4 += 4;
    });
  }

  void _addNext1024Integer() {
    setState(() {
      _numbers.add(_x1024);
      _addOnChains(_x1024);
      _x1024 += 1024;
    });
  }

  void _addNextRandomInteger() {
    var number = _random.nextInt(99_999);
    setState(() {
      _numbers.add(number);
      _addOnChains(number);
    });
  }

  void _addOnChains(int x) {
    if (_usingPrimes) {
      _chains[(x % _primeInUse) % _chains.length].addNumber(x);
    } else {
      _chains[x % _chains.length].addNumber(x);
    }
  }

  void _rebuild() {
    setState(() {
      _chains =
          List.generate(_chains.length, (int index) => SearchChainModel());
      _primeInUse = _primes.firstWhere((int prime) {return prime > _chains.length * 3;}, orElse: () => _primes.last);
      for (final number in _numbers) {
        _addOnChains(number);
      }
    });
  }

  void _plusOneRebuild() {
    setState(() {
      _chains =
          List.generate(_chains.length + 1, (int index) => SearchChainModel());
      _primeInUse = _primes.firstWhere((int prime) {return prime > _chains.length * 3;}, orElse: () => _primes.last);
      for (final number in _numbers) {
        _addOnChains(number);
      }
    });
  }

  void _doubleRebuild() {
    setState(() {
      _chains =
          List.generate(_chains.length * 2, (int index) => SearchChainModel());
      _primeInUse = _primes.firstWhere((int prime) {return prime > _chains.length * 3;}, orElse: () => _primes.last);
      for (final number in _numbers) {
        _addOnChains(number);
      }
    });
  }

  List<Widget> _getChainsWidget() {
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
          children: _getChainsWidget(),
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
          onPressed: _plusOneRebuild,
          child: Text('+1 Rebuild'),
        ),
        TextButton(
          onPressed: _doubleRebuild,
          child: Text('Double Rebuild'),
        ),
        Switch(
          activeColor: Colors.red,
          value: _usingPrimes,
          onChanged: (bool value) {
            setState(() {
              _usingPrimes = value;
            });
            _rebuild();
          },
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

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
  int _x = 0, _multiplier = 1024;

  void _addNextInteger() {
    setState(() {
      _numbers.add(_x);
      _chains[_x % _chains.length].addNumber(_x);
      _x += _multiplier;
    });
  }

  void _addNextChain() {
    setState(() {
      _chains =
          List.generate(_chains.length + 1, (int index) => SearchChainModel());
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
      persistentFooterButtons: [
        FloatingActionButton(
          onPressed: _addNextInteger,
          tooltip: 'Add integer',
          child: const Icon(Icons.add),
        ),
        FloatingActionButton(
          onPressed: _addNextChain,
          tooltip: 'Add chain',
          child: const Icon(Icons.link),
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

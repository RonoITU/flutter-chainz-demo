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
  List<int> _numbers = [1,2,3,4,5,6,7,8,9];

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
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      height: 32,
                      width: 32,
                      margin: EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
                      color: Colors.lightBlue,
                      child: Text('1'),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 32,
                      width: 32,
                      margin: EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
                      color: Colors.lightBlue,
                      child: Text('2'),
                    ),
                    Text('0'),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      height: 32,
                      width: 32,
                      margin: EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
                      color: Colors.lightBlue,
                      child: Text('3'),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 32,
                      width: 32,
                      margin: EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0),
                      color: Colors.lightBlue,
                      child: Text('4'),
                    ),
                    Text('1'),
                  ],
                ),
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

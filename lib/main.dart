import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stackoverflowsamples/unserialize.dart';

void main() {
  runApp(MaterialApp(
      home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String _sample1 = 'a:2:{i:0;s:12:"Sample array";i:1;a:2:{i:0;s:5:"Apple";i:1;s:6:"Orange";}}';
  String _sample2 = 'O:8:"stdClass":5:{s:4:"name";s:7:"Rodrigo";s:4:"last";s:7:"Cardozo";s:3:"age";i:35;s:9:"developer";b:1;s:6:"height";d:73.5;}';
  String _response1, _response2;

  @override
  void initState() {
    var object = Php.unserialize(_sample1);
    _response1 = jsonEncode(object);
    print(object["0"]);

    object = Php.unserialize(_sample2);
    _response2 = jsonEncode(object);
    print(object["name"]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Text("Sample 1:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text("From: $_sample1"),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text("To: $_response1"),
            ),
            Divider(),
            Text("Sample 2:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text("From: $_sample2"),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text("To: $_response2"),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}

class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Text("Second screen"),
        ),
      ),
    );
  }
}
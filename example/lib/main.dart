import 'package:flutter/material.dart';
import 'package:example/pages/page_home.dart';
import 'package:example/pages/page_clasificar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => PageHomeCamera(),
        'ibm': (BuildContext context) => PageClasificar(),
      },
    );
  }
}

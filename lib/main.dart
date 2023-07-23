// @dart=2.9

import 'package:flutter/material.dart';
import 'Views/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather',
      theme: ThemeData(
          textTheme: Theme.of(context)
              .textTheme
              .apply(bodyColor: Colors.white, displayColor: Colors.blue)),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

import 'package:collection_report/screens/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      title: 'Collection Report',
      initialRoute: 'home',
      routes: {
        'home': (content) => const Home(),
      },
    );
  }
}

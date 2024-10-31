import 'package:flutter/material.dart';
import 'package:xo/screens/bfs.dart';
import 'package:xo/screens/dfs.dart';
import 'package:xo/screens/ids.dart';
import 'package:xo/screens/main_page.dart';
import 'package:xo/screens/ucs.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: const MainPage(),
      routes: {
        '/page1': (context) =>const Bfs(),
        '/page2': (context) =>const Dfs(),
        '/page3': (context) => const Ids(),
        '/page4': (context) => const Ucs(),
      },

    );
   }
  }
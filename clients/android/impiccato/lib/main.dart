import 'package:flutter/material.dart';
import 'package:impiccato/Home.dart';

void main(List<String> args) {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.accent),
          buttonColor: Colors.white,
          textButtonTheme:
              TextButtonThemeData(style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => Color.fromARGB(255, 244, 191, 1)))),
          inputDecorationTheme: InputDecorationTheme(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
              labelStyle: TextStyle(color: Colors.white70),
              hintStyle: TextStyle(color: Colors.white60)),
          textTheme: TextTheme(bodyText2: TextStyle(color: Colors.white), bodyText1: TextStyle(color: Colors.white), subtitle1: TextStyle(color: Colors.white)),
          scaffoldBackgroundColor: Color.fromARGB(255, 40, 42, 62),
          appBarTheme: AppBarTheme(backgroundColor: Color.fromARGB(255, 32, 34, 49))),
      home: Home(),
    );
  }
}

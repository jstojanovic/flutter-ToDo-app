import 'package:flutter/material.dart';
import 'package:pametan_pise_tudu/glavni_ekran.dart';

void main() {
  runApp(Aplikacija());
}

class Aplikacija extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GlavniEkran(),
    );
  }
}

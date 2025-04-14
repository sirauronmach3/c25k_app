import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const C25KApp());
}

class C25KApp extends StatelessWidget {
  const C25KApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'C25K Runner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.dark,
      ),
      home: const HomeScreen(),
    );
  }
}

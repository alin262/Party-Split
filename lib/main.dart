import 'package:flutter/material.dart';
import 'package:partysplit/screens/home_screen.dart';

void main() {
  runApp(const PartySplitApp());
}

class PartySplitApp extends StatelessWidget {
  const PartySplitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      theme: ThemeData.dark(),
    );
  }
}

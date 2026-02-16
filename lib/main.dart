import 'package:flutter/material.dart';

void main() {
  runApp(const PartySplitApp());
}

class PartySplitApp extends StatelessWidget {
  const PartySplitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen(),theme: ThemeData.dark(),);
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PARTY SPLIT'), centerTitle: true),
      body: const Center(child: Text("No parties yet")),
    );
  }
}

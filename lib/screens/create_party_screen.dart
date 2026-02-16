import 'package:flutter/material.dart';

class CreatePartyScreen extends StatelessWidget {
  const CreatePartyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Party")),
      body: const Center(child:  Text("Create Party Screen")),
    );
  }
}

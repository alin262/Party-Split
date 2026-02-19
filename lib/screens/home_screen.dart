import 'package:flutter/material.dart';
import 'create_party_screen.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PARTY SPLIT'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.group, size: 80, color: Colors.grey),
            SizedBox(height: 20),
            Text("No parties yet", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text(
              style: TextStyle(color: Colors.grey),
              'Press "+" to create group',
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: ()async {
          final result=await Navigator.push(context, MaterialPageRoute(builder:(context) => const CreatePartyScreen(),));
          print(result);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

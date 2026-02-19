import 'package:flutter/material.dart';

class CreatePartyScreen extends StatefulWidget {
  const CreatePartyScreen({super.key});

  @override
  State<CreatePartyScreen> createState() => _CreatePartyScreenState();
}

class _CreatePartyScreenState extends State<CreatePartyScreen> {
  final TextEditingController _titleController = TextEditingController();
  bool _isValid = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleController.addListener(() {
      setState(() {
        _isValid = _titleController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _titleController.dispose();
    super.dispose();
  }

  void _saveParty() {
    final title = _titleController.text.trim();
    print("Title saved as: $title");
    Navigator.pop(context,title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Party")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              const Text("Party Title", style: TextStyle(fontSize: 20)),
              const SizedBox(height: 8),
              TextField(
                textAlign: TextAlign.center,
                controller: _titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter party name",
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                onPressed: _isValid ? _saveParty : null,
                child: Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

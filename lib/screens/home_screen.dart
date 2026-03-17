import 'package:flutter/material.dart';
import 'package:partysplit/screens/party_details_screen.dart';
import 'package:partysplit/services/storage_services.dart';
import 'create_party_screen.dart';
import '../models/party.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    loadParties();
  }

  void _deleteParty(Party party) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Delete Party",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red),
          ),
          content: Text.rich(
            TextSpan(
              text: 'Are you sure to delete Party ',
              style: TextStyle(fontSize: 16.0),
              children: <TextSpan>[
                TextSpan(
                  text: party.title.toUpperCase(),
                  style: TextStyle(
                    color: Colors.red[200],
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.deepOrange[400],
              ),
              onPressed: () async {
                setState(() {
                  _parties.remove(party);
                });
                await StorageServices.saveParties(_parties);
                Navigator.pop(context);
              },
              child: Text("Delete"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.deepOrange[400],
              ),
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  Future<void> loadParties() async {
    final parties = await StorageServices.loadParties();
    setState(() {
      _parties = parties;
    });
  }

  List<Party> _parties = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SPLITTy'), centerTitle: true),
      body: _parties.isEmpty
          ? Center(
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
            )
          : ListView.builder(
              itemCount: _parties.length,
              itemBuilder: (context, index) {
                final party = _parties[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
                    leading: const CircleAvatar(child: Icon(Icons.group)),
                    title: Text(party.title.toUpperCase(),style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold,),textAlign: TextAlign.center,),
                    subtitle: Text(
                      DateFormat("dd.MM.yyyy, hh:mm a").format(party.createdAt),textAlign: TextAlign.center,
                    ),
                    trailing: IconButton(
                      onPressed: () => _deleteParty(party),
                      icon: const Icon(Icons.delete, color: Colors.red),
                    ),onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return PartyDetailsScreen(party: party, parties: _parties);
                      },));
                    },
                  ),
                );
              },
            ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreatePartyScreen()),
          );
          if (result != null && result is Party) {
            setState(() {
              _parties.add(result);
            });
            await StorageServices.saveParties(_parties);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

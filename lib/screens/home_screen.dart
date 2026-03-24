import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:partysplit/screens/party_details_screen.dart';
import 'package:partysplit/services/auth_service.dart';
import 'package:partysplit/services/firestore_service.dart';
import 'create_party_screen.dart';
import 'login_screen.dart';
import '../models/party.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget _buildAuthIcon() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.isAnonymous) {
      return const CircleAvatar(child: Icon(Icons.person));
    }
    return CircleAvatar(
      child: Text((user.displayName ?? 'U')[0].toUpperCase()),
    );
  }

  void _showAccountDialog() {
    final user = FirebaseAuth.instance.currentUser;
    final isGuest = user == null || user.isAnonymous;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Account', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isGuest ? Icons.person_outline : Icons.account_circle,
              size: 48,
            ),
            const SizedBox(height: 8),
            Text(
              isGuest ? 'Signed in as Guest' : (user?.displayName ?? 'User'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            if (!isGuest)
              Text(user?.email ?? '', style: const TextStyle(fontSize: 13)),
          ],
        ),
        actions: [
          if (isGuest)
            FilledButton.icon(
              icon: Image.asset('lib/assets/images/google.png', width: 18),
              label: const Text('Sign in with Google'),
              onPressed: () async {
                await AuthService().signInWithGoogle();
                await FirebaseAuth.instance.currentUser?.reload();
                if (!mounted) return;
                Navigator.pop(dialogContext);
                setState(() {});
              },
            ),
          if (!isGuest)
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.deepOrange[400],
              ),
              onPressed: () async {
                await AuthService().signOut();
                if (!mounted) return;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              child: const Text('Sign Out'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _deleteParty(Party party) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Delete Party',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red),
          ),
          content: Text.rich(
            TextSpan(
              text: 'Are you sure you want to delete ',
              style: const TextStyle(fontSize: 16),
              children: [
                TextSpan(
                  text: party.title.toUpperCase(),
                  style: TextStyle(
                    color: Colors.red[200],
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const TextSpan(text: '?'),
              ],
            ),
          ),
          actions: [
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.deepOrange[400],
              ),
              onPressed: () async {
                await FirestoreService().deleteParty(party.id);
                if (!mounted) return;
                Navigator.pop(dialogContext);
              },
              child: const Text('Delete'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.deepOrange[400],
              ),
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SPLITTy'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: _showAccountDialog, icon: _buildAuthIcon()),
        ],
      ),
      body: StreamBuilder<List<Party>>(
        stream: FirestoreService().getParties(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final parties = snapshot.data ?? [];

          if (parties.isEmpty) {
            return const Center(child: Text('No parties yet'));
          }

          return ListView.builder(
            itemCount: parties.length,
            itemBuilder: (context, index) {
              final party = parties[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.group)),
                  title: Text(
                    party.title.toUpperCase(),
                    textAlign: TextAlign.center,
                  ),
                  subtitle: Text(
                    DateFormat('dd.MM.yyyy, hh:mm a').format(party.createdAt),
                    textAlign: TextAlign.center,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteParty(party),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PartyDetailsScreen(party: party),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreatePartyScreen()),
          );
          if (result != null && result is Party) {
            if (!mounted) return;
            await FirestoreService().saveParty(result);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

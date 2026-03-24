import '../models/party.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String? get userId => FirebaseAuth.instance.currentUser?.uid;
  CollectionReference get _partyCollection =>
      _db.collection("users").doc(userId).collection("parties");

  Future<void> saveParty(Party party) async {
    await _partyCollection.add(party.toJson());
  }

  Stream<List<Party>> getParties() {
     if (userId == null) {
    return const Stream.empty();
  }
     return _partyCollection
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Party.fromFirestore(doc)).toList());
  }
  Future<void> deleteParty(String partyId)async{
    await _partyCollection.doc(partyId).delete();
  }
  Future<void> updateParty(Party party)async{
    await _partyCollection.doc(party.id).update(party.toJson());
  }
}

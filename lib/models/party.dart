import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:partysplit/models/member.dart';

class Party {
  final String title;
  final String id;
  final DateTime createdAt;
  final List<Member> members;

  Party({required this.title, required this.createdAt, required this.members,required this.id});

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "createdAt": createdAt,
      
      "members": members.map((m) => m.toJson()).toList()
    };
  }

  factory Party.fromFirestore(DocumentSnapshot doc) {
    final json=doc.data() as Map<String,dynamic>;
    return Party(
      id:doc.id,
      title: json["title"],
      createdAt:(json["createdAt"] as Timestamp).toDate(),
      members: (json["members"]??[]).map<Member>((m)=>Member.fromJson(Map<String,dynamic>.from(m))).toList(),
    );
  }
}

import 'package:partysplit/models/member.dart';

class Party {
  final String title;
  final DateTime createdAt;
  final List<Member> members;

  Party({required this.title, required this.createdAt, required this.members});

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "createdAt": createdAt.toIso8601String(),
      "members": members.map((m) => m.toJson()).toList()
    };
  }

  factory Party.fromJson(Map<String, dynamic> json) {
    return Party(
      title: json["title"],
      createdAt: DateTime.parse(json["createdAt"]),
      members: (json["members"]as List).map((m)=>Member.fromJson(Map<String,dynamic>.from(m))).toList(),
    );
  }
}

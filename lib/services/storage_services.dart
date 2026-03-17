import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/party.dart';

class StorageServices {
  static const String partyKey = "parties";
  static Future<void> saveParties(List<Party> parties) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> partyList = parties
        .map((p) => jsonEncode(p.toJson()))
        .toList();
    await prefs.setStringList(partyKey, partyList);
  }

  static Future<List<Party>> loadParties() async {
final prefs=await SharedPreferences.getInstance();
  List <String>? partyList=prefs.getStringList(partyKey);
  if(partyList==null)return [];
  return partyList.map((p)=>Party.fromJson(jsonDecode(p))).toList();
  }
}

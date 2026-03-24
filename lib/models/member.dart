

class Member {
  final String name; 
  double amountPaid;

  Member({required this.name,this.amountPaid=0});

Map<String,dynamic> toJson(){
  return {
    "name":name,
    "amountPaid":amountPaid
  };}
  factory Member.fromJson(Map<String,dynamic> json){
    return Member(name: json["name"],
    amountPaid: (json["amountPaid"]??0).toDouble());
  }

}
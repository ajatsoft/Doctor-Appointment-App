import 'package:cloud_firestore/cloud_firestore.dart';

class Admin {
  int id;
  String nickname;
  String password;
  var closedWatches = [];

  DocumentReference reference;

  Admin({this.id, this.nickname, this.password, this.closedWatches});

  Admin.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    nickname = json['nickname'];
    password = json['password'];
    closedWatches = List.from(json['closedWatches']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['nickname'] = this.nickname;
    data['password'] = this.password;
    data['closedWatches'] = this.closedWatches;
    return data;
  }

  Admin.fromMap(Map<String, dynamic> map, {this.reference})
      : id = map["Id"],
        nickname = map["nickname"],
        password = map["password"],
        closedWatches = List.from(map["closedWatches"]);

  Admin.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}

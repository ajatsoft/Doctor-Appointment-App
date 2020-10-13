import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String adi;
  String lastName;
  String password;
  String birthday;
  String gender;
  String placeOfBirth;

  DocumentReference reference;

  User(
      {this.id,
      this.adi,
      this.lastName,
      this.password,
      this.birthday,
      this.gender,
      this.placeOfBirth});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    adi = json['adi'];
    lastName = json['lastName'];
    birthday = json['birthday'];
    gender = json['gender'];
    password = json['password'];
    placeOfBirth = json["placeOfBirth"];
  }

  User.fromMap(Map<String, dynamic> map, {this.reference})
      : id = map["id"],
        password = map["password"],
        adi = map["ad"],
        lastName = map["soyad"],
        placeOfBirth = map["placeOfBirth"],
        birthday = map["birthday"],
        gender = map["gender"];

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['adi'] = this.adi;
    data['lastName'] = this.lastName;
    data['birthday'] = this.birthday;
    data['gender'] = this.gender;
    data['password'] = this.password;
    data['placeOfBirth'] = this.placeOfBirth;
    return data;
  }
}

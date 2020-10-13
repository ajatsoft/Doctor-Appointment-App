import 'package:cloud_firestore/cloud_firestore.dart';

class Doctor {
  String id;
  String firstName;
  String lastName;
  String password;
  int departmentId;
  int hospitalId;
  var appointments = [];
  int favoriSayaci;
  String birthday;
  String gender;
  String placeOfBirth;

  DocumentReference reference;

  Doctor(
      {this.id,
      this.firstName,
      this.lastName,
      this.password,
      this.departmentId,
      this.hospitalId,
      this.appointments,
      this.favoriSayaci,
      this.birthday,
      this.gender,
      this.placeOfBirth});

  Doctor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    password = json['password'];
    departmentId = json['departmentId'];
    hospitalId = json['hospitalId'];
    appointments = List.from(json['appointments']);
    favoriSayaci = json['favoriSayaci'];
    birthday = json['birthday'];
    gender = json['gender'];
    placeOfBirth = json["placeOfBirth"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['password'] = this.password;
    data['departmentId'] = this.departmentId;
    data['hospitalId'] = this.hospitalId;
    data['appointments'] = this.appointments;
    data['favoriSayaci'] = this.favoriSayaci;
    data['birthday'] = this.birthday;
    data['gender'] = this.gender;
    data['placeOfBirth'] = this.placeOfBirth;
    return data;
  }

  Doctor.fromMap(Map<String, dynamic> map, {this.reference})
      : id = map["id"],
        password = map["password"],
        firstName = map["ad"],
        lastName = map["soyad"],
        departmentId = map["departmentId"],
        hospitalId = map["hospitalId"],
        appointments = List.from(map["appointments"]),
        favoriSayaci = map["favoriSayaci"],
        placeOfBirth = map["placeOfBirth"],
        birthday = map["birthday"],
        gender = map["gender"];

  Doctor.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}

import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteList {
  String doctorToken;
  String doctorName;
  String doctorLastName;
  String patientToken;
  String patientName;
  String patientLastName;
  DocumentReference reference;

  FavoriteList(
      {this.doctorToken,
      this.patientToken,
      this.doctorName,
      this.doctorLastName,
      this.patientName,
      this.patientLastName});

  FavoriteList.fromJson(Map<String, dynamic> json) {
    doctorToken = json['doctorToken'];
    patientToken = json['patientToken'];
    doctorName = json['doctorName'];
    patientName = json['patientName'];
    doctorLastName = json['doctorLastName'];
    patientLastName = json['patientLastName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doctorToken'] = this.doctorToken;
    data['patientToken'] = this.patientToken;
    data['doctorName'] = this.doctorName;
    data['patientName'] = this.patientName;
    data['doctorLastName'] = this.doctorLastName;
    data['patientLastName'] = this.patientLastName;
    return data;
  }

  FavoriteList.fromMap(Map<String, dynamic> map, {this.reference})
      : doctorToken = map["doctorToken"],
        patientToken = map["patientToken"],
        doctorName = map["doctorName"],
        patientName = map["patientName"],
        doctorLastName = map["doctorLastName"],
        patientLastName = map["patientLastName"];

  FavoriteList.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}

import 'package:cloud_firestore/cloud_firestore.dart';

class Hospital {
  String hospitalName;
  int hospitalId;

  Hospital({this.hospitalName, this.hospitalId});

  DocumentReference reference;

  Hospital.fromJson(Map<String, dynamic> json) {
    hospitalName = json['hospitalName'];
    hospitalId = json['hospitalId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hospitalName'] = this.hospitalName;
    data['hospitalId'] = this.hospitalId;
    return data;
  }

  Hospital.fromMap(Map<String, dynamic> map, {this.reference})
      : hospitalName = map["hospitalName"],
        hospitalId = map["hospitalId"];

  Hospital.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}

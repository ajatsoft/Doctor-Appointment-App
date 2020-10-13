import 'package:cloud_firestore/cloud_firestore.dart';

class Section {
  String departmentName;
  int departmentId;
  int hospitalId;

  DocumentReference reference;

  Section({this.departmentName, this.departmentId, this.hospitalId});

  Section.fromJson(Map<String, dynamic> json) {
    departmentName = json['departmentName'];
    departmentId = json['departmentId'];
    hospitalId = json['hospitalId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['departmentName'] = this.departmentName;
    data['departmentId'] = this.departmentId;
    data['hospitalId'] = this.hospitalId;
    return data;
  }

  Section.fromMap(Map<String, dynamic> map, {this.reference})
      : departmentName = map["departmentName"],
        departmentId = map["departmentId"],
        hospitalId = map["hospitalId"];

  Section.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}

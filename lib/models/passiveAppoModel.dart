import 'package:cloud_firestore/cloud_firestore.dart';

class PassAppointment {
  int recordId;
  String doctorToken;
  String patientToken;
  String operationHistoryi;
  String doctorName;
  String patientName;
  String doctorLastName;
  String patientLastName;

  DocumentReference reference;

  PassAppointment(
      {this.recordId,
      this.doctorToken,
      this.patientToken,
      this.operationHistoryi,
      this.doctorName,
      this.doctorLastName,
      this.patientName,
      this.patientLastName});

  PassAppointment.fromJson(Map<String, dynamic> json) {
    recordId = json['recordId'];
    doctorToken = json['doctorToken'];
    patientToken = json['patientToken'];
    operationHistoryi = json['operationHistoryi'];
    doctorName = json['doctorName'];
    patientName = json['patientName'];
    doctorLastName = json['doctorLastName'];
    patientLastName = json['patientLastName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['recordId'] = this.recordId;
    data['doctorToken'] = this.doctorToken;
    data['patientToken'] = this.patientToken;
    data['operationHistoryi'] = this.operationHistoryi;
    data['doctorName'] = this.doctorName;
    data['patientName'] = this.patientName;
    data['doctorLastName'] = this.doctorLastName;
    data['patientLastName'] = this.patientLastName;
    return data;
  }

  PassAppointment.fromMap(Map<String, dynamic> map, {this.reference})
      : recordId = map['recordId'],
        doctorToken = map['doctorToken'],
        patientToken = map['patientToken'],
        operationHistoryi = map['operationHistoryi'],
        doctorName = map["doctorName"],
        patientName = map["patientName"],
        doctorLastName = map["doctorLastName"],
        patientLastName = map["patientLastName"];

  PassAppointment.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}

import 'package:cloud_firestore/cloud_firestore.dart';

class ActiveAppointment {
  String doctorToken;
  String doctorName;
  String patientToken;
  String patientName;
  int randId;
  String appointmentDate;
  DocumentReference reference;
  String doctorLastName;
  String patientLastName;

  ActiveAppointment(
      {this.doctorToken,
      this.patientToken,
      this.randId,
      this.appointmentDate,
      this.doctorName,
      this.doctorLastName,
      this.patientName,
      this.patientLastName});

  ActiveAppointment.fromJson(Map<String, dynamic> json) {
    doctorToken = json['doctorToken'];
    patientToken = json['patientToken'];
    randId = json['randId'];
    appointmentDate = json['appointmentDate'];
    doctorName = json['doctorName'];
    patientName = json['patientName'];
    doctorLastName = json['doctorLastName'];
    patientLastName = json['patientLastName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doctorToken'] = this.doctorToken;
    data['patientToken'] = this.patientToken;
    data['randId'] = this.randId;
    data['appointmentDate'] = this.appointmentDate;
    data['doctorName'] = this.doctorName;
    data['patientName'] = this.patientName;
    data['doctorLastName'] = this.doctorLastName;
    data['patientLastName'] = this.patientLastName;
    return data;
  }

  ActiveAppointment.fromMap(Map<String, dynamic> map, {this.reference})
      : doctorToken = map["doctorToken"],
        patientToken = map["patientToken"],
        randId = map["randId"],
        appointmentDate = map["appointmentDate"],
        doctorName = map["doctorName"],
        patientName = map["patientName"],
        doctorLastName = map["doctorLastName"],
        patientLastName = map["patientLastName"];

  ActiveAppointment.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}

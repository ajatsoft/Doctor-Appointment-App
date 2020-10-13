import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_turtle_v2/dbHelper/searchData.dart';
import 'package:fast_turtle_v2/models/activeAppointmentModel.dart';
import 'package:fast_turtle_v2/models/passiveAppoModel.dart';
import 'package:fast_turtle_v2/models/sectionModel.dart';
import 'package:fast_turtle_v2/models/userModel.dart';
import 'package:fast_turtle_v2/models/doctorModel.dart';
import 'package:fast_turtle_v2/models/adminModel.dart';
import 'package:fast_turtle_v2/models/hospitalModel.dart';

class AddService {
  String saveUser(User user) {
    Firestore.instance.collection('tblUser').document().setData({
      'ad': user.adi,
      'soyad': user.lastName,
      'id': user.id,
      'gender': user.gender,
      'birthday': user.birthday,
      'placeOfBirth': user.placeOfBirth,
      'password': user.password
    });
    return 'kullanıcı ekleme işlemi Completendı';
  }

  void saveDoctor(Doctor dr, Section departmentu, Hospital hospitalsi) {
    var appointments = [];
    Firestore.instance.collection('tblDoctor').document().setData({
      'id': dr.id,
      'ad': dr.firstName,
      'soyad': dr.lastName,
      'password': dr.password,
      'departmentId': departmentu.departmentId,
      'hospitalId': hospitalsi.hospitalId,
      'gender': dr.gender,
      'birthday': dr.birthday,
      'placeOfBirth': dr.placeOfBirth,
      'favoriSayaci' : 0,
      'appointments' : appointments
    });
  }

  void addActiveAppointment(Doctor dr, User user, String history) {
    Firestore.instance.collection('tbleActiveAppointments').document().setData({
      'doctorToken': dr.id,
      'patientToken': user.id,
      'appointmentDate': history,
      'doctorName': dr.firstName,
      'doctorLastName': dr.lastName,
      'patientName': user.adi,
      'patientLastName': user.lastName
    });
  }

  void addDoctorToUserFavList(PassAppointment rand) {
    Firestore.instance.collection('tblFavoriler').document().setData({
      'doctorToken': rand.doctorToken,
      'patientToken': rand.patientToken,
      'doctorName': rand.doctorName,
      'doctorLastName': rand.doctorLastName,
      'patientName': rand.patientName,
      'patientLastName': rand.patientLastName
    });
  }

  void addPastAppointment(ActiveAppointment randevu) {
    Firestore.instance.collection('tblAppointmentHistory').document().setData({
      'doctorToken': randevu.doctorToken,
      'patientToken': randevu.patientToken,
      'operationHistoryi': randevu.appointmentDate,
      'doctorName': randevu.doctorName,
      'doctorLastName': randevu.doctorLastName,
      'patientName': randevu.patientName,
      'patientLastName': randevu.patientLastName
    });
  }

  addDoctorAppointment(Doctor doctor) {
    Firestore.instance
        .collection("tblDoctor")
        .document(doctor.reference.documentID)
        .set({'appointments': doctor.appointments}, SetOptions(merge: true));
  }

  closeDoctorAppointment(Admin admin) {
    Firestore.instance
        .collection("tblAdmin")
        .document(admin.reference.documentID)
        .set({'closedWatches': admin.closedWatches}, SetOptions(merge: true));
  }

  String saveAdmin(Admin admin) {
    Firestore.instance.collection("tblAdmin").document().setData({
      'Id': admin.id,
      'nicname': admin.nickname,
      'password': admin.password
    });
    return 'Admin ekleme işlem completendı';
  }

  String saveHospital(Hospital hospital) {
    SearchService().getLastHospitalId().then((QuerySnapshot docs) {
      Firestore.instance.collection("tblhospital").document().setData({
        'hospitalName': hospital.hospitalName,
        'hospitalId': docs.documents[0]['hospitalId'] + 1,
      });
    });

    return 'hospital kaydı completendı';
  }

  String saveSection(Section department, Hospital hospital) {
    SearchService().getLastSectionId().then((QuerySnapshot docs) {
      Firestore.instance.collection("tblDepartment").document().setData({
        "departmentName": department.departmentName,
        "departmentId": docs.documents[0]["departmentId"] + 1,
        "hospitalId": hospital.hospitalId
      });
    });
    return "Bölüm ekleme completendı";
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_turtle_v2/models/doctorModel.dart';
import 'package:fast_turtle_v2/models/passiveAppoModel.dart';

class SearchService {
  searchById(String incomingId, String incomingPassword, int formKey) {
    if (formKey == 0) {
      return Firestore.instance
          .collection('tblUser')
          .where('id', isEqualTo: incomingId)
          .where('password', isEqualTo: incomingPassword)
          .getDocuments();
    } else if (formKey == 1) {
      return Firestore.instance
          .collection('tblDoctor')
          .where('id', isEqualTo: incomingId)
          .where('password', isEqualTo: incomingPassword)
          .getDocuments();
    } else if (formKey == 2) {
      return Firestore.instance
          .collection('tblAdmin')
          .where('nickname', isEqualTo: incomingId)
          .where('password', isEqualTo: incomingPassword)
          .getDocuments();
    }
  }

  searchByPassword(String incomingpassword, int formKey) {
    if (formKey == 0) {
      return Firestore.instance
          .collection('tblUser')
          .where('password', isEqualTo: incomingpassword)
          .getDocuments();
    } else if (formKey == 1) {
      return Firestore.instance
          .collection('tblDoctor')
          .where('password', isEqualTo: incomingpassword)
          .getDocuments();
    } else if (formKey == 2) {
      return Firestore.instance
          .collection('tblAdmin')
          .where('password', isEqualTo: incomingpassword)
          .getDocuments();
    }
  }

  searchHospitalByName(String value) {
    return Firestore.instance
        .collection("tblhospital")
        .where('hospitalName', isEqualTo: value)
        .getDocuments();
  }

  searchHospitalById(int value) {
    return Firestore.instance
        .collection("tblhospital")
        .where('hospitalId', isEqualTo: value)
        .getDocuments();
  }

  searchSectionById(int value) {
    return Firestore.instance
        .collection("tblDepartment")
        .where('departmentId', isEqualTo: value)
        .getDocuments();
  }

  searchSectionsByHospitalId(int hospitalId) {
    return Firestore.instance
        .collection("tblDepartment")
        .where('hospitalId', isEqualTo: hospitalId)
        .getDocuments();
  }

  searchSectionByHospitalIdAndSectionName(int hospitalId, String sectionName) {
    return Firestore.instance
        .collection("tblDepartment")
        .where('hospitalId', isEqualTo: hospitalId)
        .where('departmentName', isEqualTo: sectionName)
        .getDocuments();
  }

  searchDoctorAppointment(Doctor doctor, String history) {
    return Firestore.instance
        .collection("tbleActiveAppointments")
        .where('doctorToken', isEqualTo: doctor.id)
        .where('appointmentDate', isEqualTo: history)
        .getDocuments();
  }

  searchDoctorById(String id) {
    return Firestore.instance
        .collection("tblDoctor")
        .where('id', isEqualTo: id)
        .getDocuments();
  }

  searchUserById(String id) {
    return Firestore.instance
        .collection("tblUser")
        .where('id', isEqualTo: id)
        .getDocuments();
  }

  getHospitals() {
    return Firestore.instance.collection("tblhospital").getDocuments();
  }

  getSections() {
    return Firestore.instance.collection("tblDepartment").getDocuments();
  }

  getLastSectionId() {
    return Firestore.instance
        .collection("tblDepartment")
        .orderBy("departmentId", descending: true)
        .getDocuments();
  }

  getLastHospitalId() {
    return Firestore.instance
        .collection("tblhospital")
        .orderBy("hospitalId", descending: true)
        .getDocuments();
  }

  getDoctors() {
    return Firestore.instance.collection("tblDoctor").getDocuments();
  }

  getPastAppointments() {
    return Firestore.instance.collection("tblAppointmentHistory").getDocuments();
  }

  searchPastAppointmentsByPatientToken(String tckn) {
    return Firestore.instance
        .collection("tblAppointmentHistory")
        .where('patientToken', isEqualTo: tckn)
        .getDocuments();
  }

  searchActiveAppointmentsByPatientToken(String tckn) {
    return Firestore.instance
        .collection("tbleActiveAppointments")
        .where('patientToken', isEqualTo: tckn)
        .getDocuments();
  }

  searchActiveAppointmentsWithPatientTokenAndDoctorToken(
      String patientToken, String doctorToken) {
    return Firestore.instance
        .collection("tbleActiveAppointments")
        .where('patientToken', isEqualTo: patientToken)
        .where('doctorToken', isEqualTo: doctorToken)
        .getDocuments();
  }

  searchDocOnUserFavList(PassAppointment rand) {
    return Firestore.instance
        .collection("tblFavoriler")
        .where('patientToken', isEqualTo: rand.patientToken)
        .where('doctorToken', isEqualTo: rand.doctorToken)
        .getDocuments();
  }
}

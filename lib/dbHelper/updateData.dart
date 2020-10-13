import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_turtle_v2/dbHelper/searchData.dart';
import 'package:fast_turtle_v2/models/sectionModel.dart';
import 'package:fast_turtle_v2/models/userModel.dart';
import 'package:fast_turtle_v2/models/doctorModel.dart';
import 'package:fast_turtle_v2/models/hospitalModel.dart';

class UpdateService {
  updateUser(User user) {
    Firestore.instance
        .collection("tblUser")
        .document(user.reference.documentID)
        .updateData({
      'password': user.password.toString(),
      'ad': user.adi,
      'soyad': user.lastName
    });
  }

  // String updateUserFavList(String id, String doctorAdSoyad) {
  //   User temp;
  //   SearchService().searchUserById(id).then((QuerySnapshot docs) {
  //     temp = User.fromMap(docs.documents[0].data);
  //     temp.reference = docs.documents[0].reference;
  //     if (!temp.favoriDoctorlar.contains(doctorAdSoyad)) {
  //       temp.favoriDoctorlar.add(doctorAdSoyad);

  //       Firestore.instance
  //           .collection("tblUser")
  //           .document(temp.reference.documentID)
  //           .updateData({'favoriDoctorlar': temp.favoriDoctorlar});
  //     }
  //   });

  //   return "Update completed";
  // }

  String updateDoctor(Doctor doctor) {
    Firestore.instance
        .collection("tblDoctor")
        .document(doctor.reference.documentID)
        .updateData({
      'ad': doctor.firstName,
      'password': doctor.password.toString(),
      'soyad': doctor.lastName
    });
    return "Update completed";
  }

  String updateDoctorFavCountPlus(String doctorNo) {
    Doctor doctor;
    SearchService().searchDoctorById(doctorNo).then((QuerySnapshot docs) {
      doctor = Doctor.fromMap(docs.documents[0].data());
      doctor.reference = docs.documents[0].reference;
      Firestore.instance
          .collection("tblDoctor")
          .document(doctor.reference.documentID)
          .updateData({'favoriSayaci': doctor.favoriSayaci + 1});
    });

    return "Update completed";
  }

  String updateDoctorFavCountMinus(String doctorNo) {
    Doctor doctor;
    SearchService().searchDoctorById(doctorNo).then((QuerySnapshot docs) {
      doctor = Doctor.fromMap(docs.documents[0].data());
      doctor.reference = docs.documents[0].reference;
      Firestore.instance
          .collection("tblDoctor")
          .document(doctor.reference.documentID)
          .updateData({'favoriSayaci': doctor.favoriSayaci - 1});
    });

    return "Update completed";
  }

  String updateDoctorAppointments(String id, String operationHistory) {
    Doctor temp;
    SearchService().searchDoctorById(id).then((QuerySnapshot docs) {
      temp = Doctor.fromMap(docs.documents[0].data());
      temp.reference = docs.documents[0].reference;
      if (temp.appointments.contains(operationHistory)) {
        temp.appointments.remove(operationHistory);

        Firestore.instance
            .collection("tblDoctor")
            .document(temp.reference.documentID)
            .updateData({'appointments': temp.appointments});
      }
    });

    return "Update completed";
  }

  String updatehospital(Hospital hospital) {
    Firestore.instance
        .collection("tblhospital")
        .document(hospital.reference.documentID)
        .updateData({'hospitalName': hospital.hospitalName.toString()});
    return "Update completed";
  }

  String updateSection(Section department) {
    Firestore.instance
        .collection("tblDepartment")
        .document(department.reference.documentID)
        .updateData({'departmentName': department.departmentName.toString()});
    return "Update completed";
  }
}

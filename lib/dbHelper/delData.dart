import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_turtle_v2/models/activeAppointmentModel.dart';
import 'package:fast_turtle_v2/models/doctorModel.dart';
import 'package:fast_turtle_v2/models/favListModel.dart';
import 'package:fast_turtle_v2/models/hospitalModel.dart';
import 'package:fast_turtle_v2/models/sectionModel.dart';

class DelService {
  ActiveAppointment activeAppointment = ActiveAppointment();

  // This method delete a doctor also her/his active appoit
  deleteDoctorbyToken(Doctor doctor) {
    Firestore.instance
        .collection("tblDoctor")
        .document(doctor.reference.documentID)
        .delete();
    Firestore.instance
        .collection("tbleActiveAppointments")
        .where('doctorToken', isEqualTo: doctor.id)
        .getDocuments()
        .then((QuerySnapshot docs) {
      if (docs.documents.isNotEmpty) {
        for (var i = 0; i < docs.documents.length; i++) {
          Firestore.instance
              .collection("tbleActiveAppointments")
              .document(docs.documents[i].reference.documentID)
              .delete();
        }
      }
    });
  }

  deleteActiveAppointment(ActiveAppointment randevu) {
    Firestore.instance
        .collection('tbleActiveAppointments')
        .document(randevu.reference.documentID)
        .delete();
  }

  deleteDocFromUserFavList(FavoriteList fav) {
    Firestore.instance
        .collection('tblFavoriler')
        .document(fav.reference.documentID)
        .delete();
  }

  deleteSectionBySectionId(Section department, var referans) {
    Firestore.instance
        .collection("tblDepartment")
        .document(referans.documentID)
        .delete();
    Firestore.instance
        .collection("tblDoctor")
        .where('departmentId', isEqualTo: department.departmentId)
        .getDocuments()
        .then((QuerySnapshot docs) {
      if (docs.documents.isNotEmpty) {
        for (var i = 0; i < docs.documents.length; i++) {
          Firestore.instance
              .collection("tbleActiveAppointments")
              .where('doctorToken', isEqualTo: docs.documents[i]['id'])
              .getDocuments()
              .then((QuerySnapshot docs) {
            if (docs.documents.isNotEmpty) {
              for (var i = 0; i < docs.documents.length; i++) {
                Firestore.instance
                    .collection("tbleActiveAppointments")
                    .document(docs.documents[i].reference.documentID)
                    .delete();
              }
            }
          });

          Firestore.instance
              .collection("tblDoctor")
              .document(docs.documents[i].reference.documentID)
              .delete();
        }
      }
    });
  }

  deleteHospitalById(Hospital hospital) {
    Section section = Section();
    Firestore.instance
        .collection("tblDepartment")
        .where('hospitalId', isEqualTo: hospital.hospitalId)
        .getDocuments()
        .then((QuerySnapshot docs) {
      for (var i = 0; i < docs.documents.length; i++) {
        section = Section.fromMap(docs.documents[i].data());
        deleteSectionBySectionId(section, docs.documents[i].reference);
      }
    });

    Firestore.instance
        .collection("tblhospital")
        .document(hospital.reference.documentID)
        .delete();
  }
}

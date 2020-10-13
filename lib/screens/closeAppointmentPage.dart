import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_turtle_v2/dbHelper/addData.dart';
import 'package:fast_turtle_v2/dbHelper/searchData.dart';
import 'package:fast_turtle_v2/models/adminModel.dart';
import 'package:fast_turtle_v2/models/doctorModel.dart';
import 'package:fast_turtle_v2/models/hospitalModel.dart';
import 'package:fast_turtle_v2/models/sectionModel.dart';
import 'package:fast_turtle_v2/models/userModel.dart';
import 'package:fast_turtle_v2/screens/showAppointmentTimes.dart';
import 'package:fast_turtle_v2/screens/showHospitals.dart';
import 'package:fast_turtle_v2/screens/showSections.dart';
import 'package:flutter/material.dart';

import 'showDoctors.dart';

class CloseAppointment extends StatefulWidget {
  final Admin admin;
  CloseAppointment(this.admin);
  @override
  CloseAppointmentState createState() => CloseAppointmentState(admin);
}

class CloseAppointmentState extends State<CloseAppointment> {
  Admin _admin;
  CloseAppointmentState(this._admin);
  bool hospitalChosenMi = false;
  bool departmentChosenMi = false;
  bool doctorChosenMi = false;
  bool historyChosenMi = false;
  bool appointmentControl1;
  bool appointmentControl2;

  double drGoruntu = 0.0;
  double goruntu = 0.0;

  Hospital hospital = Hospital();
  Section section = Section();
  Doctor doctor = Doctor();
  User user = User();

  String textMessage = " ";

  var appointmentDate;
  var raisedButtonText = "Tıkla per Seç";

  var hourHistoryCombination;

  double imageHour = 0.0;

  @override
  Widget build(BuildContext context) {
    setState(() {
      Firestore.instance
          .collection('tblAdmin')
          .getDocuments()
          .then((QuerySnapshot docs) {
        _admin.reference = docs.documents[0].reference;
      });
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Doctor Appointmentsu Kapat",
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 20.0, left: 9.0, right: 9.0),
            child: Form(
              child: Column(
                children: <Widget>[
                  RaisedButton(
                    child: Text("hospital Seçmek İçin Tıkla"),
                    onPressed: () {
                      departmentChosenMi = false;
                      doctorChosenMi = false;
                      historyChosenMi = false;
                      hospitalNavigator(BuildHospitalList());
                    },
                  ),
                  SizedBox(height: 13.0),
                  showSelectedHospital(hospitalChosenMi),
                  SizedBox(
                    height: 30.0,
                  ),
                  RaisedButton(
                    child: Text("Bölüm Seçmek İçin Tıkla"),
                    onPressed: () {
                      if (hospitalChosenMi) {
                        doctorChosenMi = false;
                        drGoruntu = 0.0;
                        historyChosenMi = false;
                        sectionNavigator(BuildSectionList(hospital));
                      } else {
                        alrtHospital(
                            context, "hospital seçmeden bölüm seçemezsiniz");
                      }
                    },
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  _showSelectedSection(departmentChosenMi),
                  SizedBox(
                    height: 30.0,
                  ),
                  RaisedButton(
                    child: Text("Doctor Seçmek İçin Tıkla"),
                    onPressed: () {
                      if (hospitalChosenMi && departmentChosenMi) {
                        doctorNavigator(BuildDoctorList(section, hospital));
                      } else {
                        alrtHospital(context,
                            "hospital per bölüm seçmeden doctor seçemezsiniz");
                      }
                    },
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  showSelectedDoctor(doctorChosenMi),
                  SizedBox(
                    height: 25.0,
                  ),
                  dateOfAppointment(),
                  SizedBox(
                    height: 16.0,
                  ),
                  RaisedButton(
                    child: Text("İşlem Hour Seçmek İçin Tıkla"),
                    onPressed: () {
                      if (appointmentDate != null &&
                          hospitalChosenMi &&
                          departmentChosenMi &&
                          doctorChosenMi) {
                        basicNavigator(
                            AppointmentTimes(appointmentDate.toString(), doctor));
                        historyChosenMi = true;
                      } else {
                        alrtHospital(context,
                            "Yukarıdaki seçimler completenmadan saat seçimine geçilemez");
                      }
                    },
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  showSelectedDate(historyChosenMi),
                  SizedBox(
                    height: 16.0,
                  ),
                  _buildDoneButton()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void hospitalNavigator(dynamic page) async {
    hospital = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));

    if (hospital == null) {
      hospitalChosenMi = false;
    } else {
      hospitalChosenMi = true;
    }
  }

  showSelectedHospital(bool chosenMi) {
    String textMessage = " ";
    if (chosenMi) {
      setState(() {
        textMessage = this.hospital.hospitalName.toString();
      });
      goruntu = 1.0;
    } else {
      goruntu = 0.0;
    }

    return Container(
        decoration: BoxDecoration(),
        child: Row(
          children: <Widget>[
            Text(
              "Seçilen hospital : ",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            Opacity(
                opacity: goruntu,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    textMessage,
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ))
          ],
        ));
  }

  void alrtHospital(BuildContext context, String message) {
    var alertDoctor = AlertDialog(
      title: Text(
        "Uyarı!",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(message),
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDoctor;
        });
  }

  void sectionNavigator(dynamic page) async {
    section = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));

    if (section == null) {
      departmentChosenMi = false;
    } else {
      departmentChosenMi = true;
    }
  }

  _showSelectedSection(bool chosenMi) {
    double goruntu = 0.0;

    if (chosenMi) {
      setState(() {
        textMessage = this.section.departmentName.toString();
      });
      goruntu = 1.0;
    } else {
      goruntu = 0.0;
    }

    return Container(
        decoration: BoxDecoration(),
        child: Row(
          children: <Widget>[
            Text(
              "Seçilen Bölüm : ",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            Opacity(
                opacity: goruntu,
                child: Container(
                    alignment: Alignment.center,
                    child: _buildTextMessage(textMessage)))
          ],
        ));
  }

  _buildTextMessage(String incomingText) {
    return Text(
      textMessage,
      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
    );
  }

  void doctorNavigator(dynamic page) async {
    doctor = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));

    if (doctor == null) {
      doctorChosenMi = false;
    } else {
      doctorChosenMi = true;
    }
  }

  showSelectedDoctor(bool chosenMih) {
    String textMessage = " ";
    if (chosenMih) {
      setState(() {
        textMessage = this.doctor.firstName.toString() + " " + this.doctor.lastName;
      });
      drGoruntu = 1.0;
    } else {
      drGoruntu = 0.0;
    }

    return Container(
        decoration: BoxDecoration(),
        child: Row(
          children: <Widget>[
            Text(
              "Seçilen Doctor : ",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            Opacity(
                opacity: goruntu,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    textMessage,
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ))
          ],
        ));
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2021),
    );
    appointmentDate = picked;
    hourHistoryCombination = null;
    historyChosenMi = false;
  }

  Widget dateOfAppointment() {
    return Container(
      padding: EdgeInsets.only(top: 5.0),
      child: Row(
        children: <Widget>[
          Text(
            "İşlem Historyi: ",
            style: TextStyle(fontSize: 19.0),
          ),
          RaisedButton(
            child: Text(raisedButtonText),
            onPressed: () {
              _selectDate(context).then((result) => setState(() {
                    if (appointmentDate == null) {
                      raisedButtonText = "Tıkla per Seç";
                      historyChosenMi = false;
                    } else {
                      raisedButtonText =
                          appointmentDate.toString().substring(0, 10);
                    }
                  }));
            },
          )
        ],
      ),
    );
  }

  showSelectedDate(bool historyChosenMi) {
    String textMessage = " ";
    if (historyChosenMi) {
      setState(() {
        textMessage = hourHistoryCombination.toString();
      });
      imageHour = 1.0;
    } else {
      imageHour = 0.0;
    }

    return Container(
        decoration: BoxDecoration(),
        child: Row(
          children: <Widget>[
            Text(
              "Operation History per Hour : ",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            Opacity(
                opacity: imageHour,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    textMessage,
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ))
          ],
        ));
  }

  void basicNavigator(dynamic page) async {
    hourHistoryCombination = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));
  }

  void alrtAppointment(BuildContext context) {
    var alertAppointment = AlertDialog(
        contentPadding: const EdgeInsets.fromLTRB(5.0, 50.0, 5.0, 50.0),
        title: Text(
          "İşlem Özeti",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Container(
          padding: EdgeInsets.only(bottom: 50.0),
          child: Column(
            children: <Widget>[
              showSelectedHospital(hospitalChosenMi),
              _showSelectedSection(departmentChosenMi),
              showSelectedDoctor(doctorChosenMi),
              showSelectedDate(historyChosenMi),
              SizedBox(
                height: 13.0,
              ),
              Container(
                child: FlatButton(
                  child: Text(
                    "Tamam",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context, true);
                    AddService().addDoctorAppointment(doctor);
                    AddService().closeDoctorAppointment(_admin);
                  },
                ),
              ),
            ],
          ),
        ));

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertAppointment;
        });
  }

  _buildDoneButton() {
    return Container(
      child: RaisedButton(
        child: Text("Complete"),
        onPressed: () {
          if (hospitalChosenMi &&
              departmentChosenMi &&
              doctorChosenMi &&
              historyChosenMi &&
              hourHistoryCombination != null) {
            SearchService()
                .searchDoctorAppointment(doctor, hourHistoryCombination)
                .then((QuerySnapshot docs) {
              if (docs.documents.isEmpty) {
                alrtAppointment(context);
                doctor.appointments.add(hourHistoryCombination);
                _admin.closedWatches.add(hourHistoryCombination);
              } else {
                alrtHospital(context, "Bu seans dolu");
              }
            });
          } else {
            alrtHospital(context, "Eksik bilgi var");
          }
        },
      ),
    );
  }
}

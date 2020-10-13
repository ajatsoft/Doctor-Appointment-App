import 'package:fast_turtle_v2/dbHelper/delData.dart';
import 'package:fast_turtle_v2/models/doctorModel.dart';
import 'package:fast_turtle_v2/models/hospitalModel.dart';
import 'package:fast_turtle_v2/models/sectionModel.dart';
import 'package:fast_turtle_v2/screens/showDoctors.dart';
import 'package:fast_turtle_v2/screens/showHospitals.dart';
import 'package:fast_turtle_v2/screens/showSections.dart';
import 'package:flutter/material.dart';

class DeleteDoctor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DeleteDoctorState();
  }
}

class DeleteDoctorState extends State {
  Hospital hospital = Hospital();
  Section section = Section();
  Doctor doctor = Doctor();
  double goruntu = 0.0;
  double drGoruntu = 0.0;
  bool hospitalChosenMi = false;
  bool departmentChosenMi = false;
  bool doctorChosenMi = false;
  String textMessage = " ";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        title: Text(
          "Doctor Silme Ekranı",
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
              child: Form(
                child: Column(
                  children: <Widget>[
                    RaisedButton(
                      child: Text("hospital Seçmek İçin Tıkla"),
                      onPressed: () {
                        departmentChosenMi = false;
                        doctorChosenMi = false;
                        hospitalNavigator(BuildHospitalList());
                      },
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    showSelectedHospital(hospitalChosenMi),
                    SizedBox(
                      height: 16.0,
                    ),
                    RaisedButton(
                      child: Text("Bölüm Seçmek İçin Tıkla"),
                      onPressed: () {
                        if (hospitalChosenMi) {
                          doctorChosenMi = false;
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
                      height: 16.0,
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
                    _silButton()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void alrtHospital(BuildContext context, String message) {
    var alertDoctor = AlertDialog(
      title: Text("Uyarı!"),
      content: Text(message),
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDoctor;
        });
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

  void sectionNavigator(dynamic page) async {
    section = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));

    if (section == null) {
      departmentChosenMi = false;
    } else {
      departmentChosenMi = true;
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

  _silButton() {
    return Container(
      child: RaisedButton(
        child: Text(
          "Seçili Doctoru Sil",
          style: TextStyle(fontSize: 20.0),
        ),
        onPressed: () {
          if (hospitalChosenMi && departmentChosenMi && doctorChosenMi) {
            DelService().deleteDoctorbyToken(doctor);
            Navigator.pop(context, true);
          } else {
            alrtHospital(context, "Eksik bilgi var");
          }
        },
      ),
    );
  }
}

import 'package:fast_turtle_v2/dbHelper/updateData.dart';
import 'package:fast_turtle_v2/models/doctorModel.dart';
import 'package:fast_turtle_v2/models/hospitalModel.dart';
import 'package:fast_turtle_v2/models/sectionModel.dart';
import 'package:fast_turtle_v2/screens/showDoctors.dart';
import 'package:fast_turtle_v2/screens/showHospitals.dart';
import 'package:fast_turtle_v2/screens/showSections.dart';
import 'package:flutter/material.dart';
import 'package:fast_turtle_v2/mixins/validation_mixin.dart';

class UpdateDoctor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UpdateDoctorState();
  }
}

class UpdateDoctorState extends State with ValidationMixin {
  Hospital hospital = Hospital();
  Doctor doctor = Doctor();
  double goruntu = 0.0;
  double drGoruntu = 0.0;
  bool hospitalChosenMi = false;
  bool departmentChosenMi = false;
  bool doctorChosenMi = false;
  Section section = Section();
  String textMessage = " ";
  String yeniAd, yeniSoyad, yenipassword;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        title: Text(
          "Doctor Güncelle Ekranı",
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 50.0, left: 20.0, right: 13.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                        "Adım 1 : Update yapılacak doctoru seçin",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                    ),
                    RaisedButton(
                      child: Text("hospital Seçmek İçin Tıkla"),
                      onPressed: () {
                        departmentChosenMi = false;
                        doctorChosenMi = false;
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
                    Container(
                      height: 1.3,
                      width: 350.0,
                      color: Colors.green,
                    ),
                    Container(
                      child: Text(
                        "Adım 2 : Seçtiğiniz doctorun güncel bilgilerini girin",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                    ),
                    _yeniDoctorName(),
                    SizedBox(
                      height: 10.0,
                    ),
                    _yeniDoctorLastName(),
                    SizedBox(
                      height: 10.0,
                    ),
                    _yeniDoctorpasswordsi(),
                    SizedBox(
                      height: 10.0,
                    ),
                    _guncelleButton()
                  ],
                ),
              ),
            )
          ],
        ),
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

  _yeniDoctorName() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: "Adı :",
          labelStyle: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
      validator: validateFirstName,
      onSaved: (String value) {
        yeniAd = value;
      },
    );
  }

  _yeniDoctorLastName() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: "Soyadı :",
          labelStyle: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
      validator: validateLastName,
      onSaved: (String value) {
        yeniSoyad = value;
      },
    );
  }

  _yeniDoctorpasswordsi() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: "Şifresi :",
          labelStyle: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
      validator: validateLastName,
      onSaved: (String value) {
        yenipassword = value;
      },
    );
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

  _guncelleButton() {
    return RaisedButton(
      child: Text(
        "Doctoru Güncelle",
        textDirection: TextDirection.ltr,
        style: TextStyle(fontSize: 20.0),
      ),
      onPressed: () {
        if (hospitalChosenMi && departmentChosenMi && doctorChosenMi) {
          if (formKey.currentState.validate()) {
            formKey.currentState.save();
            doctor.firstName = yeniAd;
            doctor.lastName = yeniSoyad;
            doctor.password = yenipassword;

            UpdateService().updateDoctor(doctor);
            Navigator.pop(context, true);
          }
        } else {
          alrtHospital(context, "Completenmamış bilgiler var");
        }
      },
    );
  }
}

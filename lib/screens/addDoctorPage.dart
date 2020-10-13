import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_turtle_v2/dbHelper/addData.dart';
import 'package:fast_turtle_v2/dbHelper/searchData.dart';
import 'package:fast_turtle_v2/models/doctorModel.dart';
import 'package:fast_turtle_v2/models/hospitalModel.dart';
import 'package:fast_turtle_v2/models/sectionModel.dart';
import 'package:fast_turtle_v2/screens/showHospitals.dart';
import 'package:fast_turtle_v2/screens/showSections.dart';
import 'package:flutter/material.dart';
import 'package:fast_turtle_v2/mixins/validation_mixin.dart';

class AddDoctor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddDoctorState();
  }
}

class AddDoctorState extends State with ValidationMixin {
  final doctor = Doctor();
  Hospital hospital = Hospital();
  Section section = Section();
  bool hospitalChosenMi = false;
  bool departmentChosenMi = false;
  String textMessage = " ";
  double goruntu = 0.0;
  final formKey = GlobalKey<FormState>();

  var genders = ["Kadın", "Erkek"];
  String selectedGenders = "Kadın";
  var birthday;
  var raisedButtonText = "Tıkla per Seç";

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    birthday = picked;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Doctor Ekle",
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 20.0, left: 9.0, right: 9.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      _idField(),
                      _passwordField(),
                      _nameField(),
                      _surnameField(),
                      placeofBirthField(),
                      genderChoose(),
                      dateOfBirth(),
                      SizedBox(
                        height: 13.0,
                      ),
                      RaisedButton(
                        child: Text("hospital Seçmek İçin Tıkla"),
                        onPressed: () {
                          departmentChosenMi = false;
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
                      _buildDoneButton(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Widget _idField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: "T.C. Id Numarası:",
          labelStyle: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
      validator: validateTCNo,
      keyboardType: TextInputType.number,
      onSaved: (String value) {
        doctor.id = value;
      },
    );
  }

  Widget _passwordField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: "Şifre:",
          labelStyle: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
      obscureText: true,
      onSaved: (String value) {
        doctor.password = value;
      },
    );
  }

  Widget _nameField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: "Ad:",
          labelStyle: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
      validator: validateFirstName,
      onSaved: (String value) {
        doctor.firstName = value;
      },
    );
  }

  Widget _surnameField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: "Soyad:",
          labelStyle: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
      validator: validateLastName,
      onSaved: (String value) {
        doctor.lastName = value;
      },
    );
  }

  Widget placeofBirthField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Doğum Yeri",labelStyle: TextStyle(fontWeight: FontWeight.bold)),
      onSaved: (String value) {
        doctor.placeOfBirth = value;
      },
    );
  }

  Widget genderChoose() {
    return Container(
        padding: EdgeInsets.only(top: 13.0),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 25.0),
              child: Text(
                "Gender: ",
                style: TextStyle(fontSize: 19.0),
              ),
            ),
            DropdownButton<String>(
              items: genders.map((String genderler) {
                return DropdownMenuItem<String>(
                  value: genderler,
                  child: Text(genderler),
                );
              }).toList(),
              value: selectedGenders,
              onChanged: (String tiklanan) {
                setState(() {
                  if (tiklanan == null) {
                    this.selectedGenders = "Kadın";
                  } else {
                    this.selectedGenders = tiklanan;
                  }
                  doctor.gender = selectedGenders;
                });
              },
            ),
          ],
        ));
  }

  Widget dateOfBirth() {
    return Container(
      padding: EdgeInsets.only(top: 5.0),
      child: Row(
        children: <Widget>[
          Text(
            "Doğum Historyi: ",
            style: TextStyle(fontSize: 19.0),
          ),
          RaisedButton(
            child: Text(raisedButtonText),
            onPressed: () {
              _selectDate(context).then((result) => setState(() {
                    raisedButtonText = birthday.toString().substring(0, 10);
                    doctor.birthday =
                        birthday.toString().substring(0, 10);
                  }));
            },
          )
        ],
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

  _buildDoneButton() {
    return Container(
      padding: EdgeInsets.only(top: 17.0),
      child: RaisedButton(
        child: Text(
          "Complete",
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          if (hospitalChosenMi &&
              departmentChosenMi &&
              formKey.currentState.validate()) {
            formKey.currentState.save();
            SearchService()
                .searchDoctorById(doctor.id)
                .then((QuerySnapshot docs) {
              if (docs.documents.isEmpty) {
                AddService()
                    .saveDoctor(this.doctor, this.section, this.hospital);
                Navigator.pop(context, true);
              } else {
                alrtHospital(context,
                    "Bu id numarasına sahip bir doctor zaten mevcut");
              }
            });
          } else {
            alrtHospital(context,
                "İşlemi completemak için gerekli alanları doldurmanız gerekmektedir");
          }
        },
      ),
    );
  }
}

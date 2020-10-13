import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_turtle_v2/dbHelper/searchData.dart';
import 'package:fast_turtle_v2/dbHelper/updateData.dart';
import 'package:fast_turtle_v2/models/hospitalModel.dart';
import 'package:fast_turtle_v2/models/sectionModel.dart';
import 'package:fast_turtle_v2/screens/showHospitals.dart';
import 'package:fast_turtle_v2/screens/showSections.dart';
import 'package:flutter/material.dart';

class UpdateSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UpdateSectionState();
  }
}

class UpdateSectionState extends State {
  Hospital hospital = Hospital();
  double goruntu = 0.0;
  bool hospitalChosenMi = false;
  bool departmentChosenMi = false;
  Section section = Section();
  String textMessage = " ";
  String yeniDepartmentName;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        title: Text(
          "Bölüm Güncelle Ekranı",
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.greenAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 50.0, left: 15.0, right: 20.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: RaisedButton(
                        child: Text(
                          "hospital Seçmek İçin Tıkla",
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          departmentChosenMi = false;
                          hospitalNavigator(BuildHospitalList());
                        },
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    showSelectedHospital(hospitalChosenMi),
                    SizedBox(
                      height: 30.0,
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
                      height: 30.0,
                    ),
                    _yeniDepartmentName(),
                    SizedBox(
                      height: 20.0,
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

  _yeniDepartmentName() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: "Yeni Bölüm Nameni Girin:",
          labelStyle: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
              color: Colors.black)),
      onSaved: (String value) {
        yeniDepartmentName = value;
      },
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

  void sectionNavigator(dynamic page) async {
    section = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));

    if (section == null) {
      departmentChosenMi = false;
    } else {
      departmentChosenMi = true;
    }
  }

  void alrtHospital(BuildContext context, String message) {
    var alertHospital = AlertDialog(
      title: Text("Uyarı!"),
      content: Text(message),
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertHospital;
        });
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

  _guncelleButton() {
    return RaisedButton(
      child: Text(
        "Bölümü Güncelle",
        textDirection: TextDirection.ltr,
        style: TextStyle(fontSize: 20.0),
      ),
      onPressed: () {
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          SearchService()
              .searchSectionByHospitalIdAndSectionName(
                  hospital.hospitalId, yeniDepartmentName)
              .then((QuerySnapshot docs) {
            if (docs.documents.isEmpty && section.departmentName != yeniDepartmentName) {
              section.departmentName = yeniDepartmentName;
              UpdateService().updateSection(section);
              Navigator.pop(context, true);
            } else {
              alrtHospital(context,
                  "Seçtiğiniz hospitalde aynı isimde bir bölüm zaten mevcut");
            }
          });
        } else {
          alrtHospital(context, "Eksik Bilgi");
        }
      },
    );
  }
}

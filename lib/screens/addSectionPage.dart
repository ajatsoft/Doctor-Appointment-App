import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_turtle_v2/dbHelper/addData.dart';
import 'package:fast_turtle_v2/dbHelper/searchData.dart';
import 'package:fast_turtle_v2/models/hospitalModel.dart';
import 'package:fast_turtle_v2/models/sectionModel.dart';
import 'package:fast_turtle_v2/screens/showHospitals.dart';
import 'package:flutter/material.dart';
import 'package:fast_turtle_v2/mixins/validation_mixin.dart';

class AddSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddSectionState();
  }
}

class AddSectionState extends State with ValidationMixin {
  final department = Section();
  Hospital hospital = Hospital();
  bool hospitalChosenMi = false;
  double goruntu = 0.0;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        title: Text(
          "Bölüm Ekle",
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.greenAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 75.0, left: 25.0, right: 25.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    RaisedButton(
                      child: Text("hospital Seçmek İçin Tıkla"),
                      onPressed: () {
                        hospitalNavigator(BuildHospitalList());
                      },
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    showSelectedHospital(hospitalChosenMi),
                    SizedBox(
                      height: 20.0,
                    ),
                    _yeniDepartmentName(),
                    SizedBox(
                      height: 25.0,
                    ),
                    _kaydetButton()
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
              color: Colors.greenAccent),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.black))),
      validator: validateFirstName,
      onSaved: (String value) {
        department.departmentName = value;
      },
    );
  }

  _kaydetButton() {
    return RaisedButton(
      child: Text(
        "Yeni Bölüm Ekle",
        textDirection: TextDirection.ltr,
        style: TextStyle(fontSize: 20.0),
      ),
      onPressed: () {
        if (hospitalChosenMi && formKey.currentState.validate()) {
          formKey.currentState.save();
          SearchService()
              .searchSectionByHospitalIdAndSectionName(
                  hospital.hospitalId, department.departmentName)
              .then((QuerySnapshot docs) {
            if (docs.documents.isEmpty) {
              AddService().saveSection(department, hospital);
              Navigator.pop(context, true);
            } else {
              alrtHospital(context, "Aynı isimde bölüm ekleyemezsiniz");
            }
          });
        } else {
          alrtHospital(context, "Eksik bilgi var");
        }
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
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_turtle_v2/dbHelper/searchData.dart';
import 'package:fast_turtle_v2/dbHelper/updateData.dart';
import 'package:fast_turtle_v2/models/doctorModel.dart';
import 'package:flutter/material.dart';

class OnlyUpdatePassword extends StatefulWidget {
  final Doctor doctor;
  OnlyUpdatePassword(this.doctor);
  @override
  _OnlyUpdatePasswordState createState() => _OnlyUpdatePasswordState(doctor);
}

class _OnlyUpdatePasswordState extends State<OnlyUpdatePassword> {
  Doctor doctor;
  _OnlyUpdatePasswordState(this.doctor);
  final formKey = GlobalKey<FormState>();
  String yenipassword;
  String eskipassword;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Şifre Güncelle"),
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.only(top: 100.0, left: 20.0, right: 20.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    eskipasswordField(),
                    SizedBox(
                      height: 13.0,
                    ),
                    passwordField(),
                    SizedBox(
                      height: 45.0,
                    ),
                    submitButton()
                  ],
                ),
              )),
        ));
  }

  Widget passwordField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: "Yeni Şifre",
          labelStyle:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
      onSaved: (String value) {
        yenipassword = value;
      },
      obscureText: true,
    );
  }

  Widget eskipasswordField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: "Eski Şifre",
          labelStyle:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
      onSaved: (String value) {
        eskipassword = value;
      },
      obscureText: true,
    );
  }

  submitButton() {
    return Container(
      child: RaisedButton(
        child: Text("Complete"),
        onPressed: () {
          if (formKey.currentState.validate()) {
            formKey.currentState.save();
            if (doctor.password != yenipassword && doctor.password == eskipassword) {
              doctor.password = yenipassword;
              SearchService()
                  .searchDoctorById(doctor.id)
                  .then((QuerySnapshot docs) {
                doctor.reference = docs.documents[0].reference;
                UpdateService().updateDoctor(doctor);
              });

              Navigator.pop(context, true);
            } else {
              alrtHospital(context, "Hatalı yada eksik bilgi girdiniz...");
            }
          } else {
            alrtHospital(context, "Hatalı yada eksik bilgi girdiniz...");
          }
        },
      ),
    );
  }

  void alrtHospital(BuildContext context, String message) {
    var alertDoctor = AlertDialog(
      title: Text(
        "Bilgilendirme!",
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

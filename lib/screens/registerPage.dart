import 'package:fast_turtle_v2/dbHelper/addData.dart';
import 'package:fast_turtle_v2/models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:fast_turtle_v2/mixins/validation_mixin.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegisterPageState();
  }
}

class RegisterPageState extends State with ValidationMixin {
  final registerFormKey = GlobalKey<FormState>();
  final user = User();

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
          title: Text("Yeni Üye Kaydı"),
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.only(top: 30.0, left: 10.0, right: 10.0),
              child: Form(
                key: registerFormKey,
                child: Column(
                  children: <Widget>[
                    idField(),
                    passwordField(),
                    firstNameField(),
                    lastNameField(),
                    placeofBirthField(),
                    genderChoose(),
                    dateOfBirth(),
                    submitButton()
                  ],
                ),
              )),
        ));
  }

  static void alrtDone(BuildContext context) {
    var alertDialog = AlertDialog(
      title: Text("Kayıt Başarılı"),
      content: Text("Giriş Yapabilirsiniz"),
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  static void alrtFail(BuildContext context) {
    var alertDialog = AlertDialog(
      title: Text("Giriş Başarısız"),
      content: Text("Hatalı yada eksik bilgi girdiniz"),
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  void basicPop(BuildContext context, bool result) {
    Navigator.pop(context, result);
  }

  Widget idField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "T.C. Id Numarası:"),
      validator: validateTCNo,
      onSaved: (String value) {
        user.id = value;
      },
    );
  }

  Widget passwordField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Şifre:"),
      onSaved: (String value) {
        user.password = value;
      },
    );
  }

  Widget firstNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Ad"),
      validator: validateFirstName,
      onSaved: (String value) {
        user.adi = value;
      },
    );
  }

  Widget lastNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Soyad"),
      validator: validateLastName,
      onSaved: (String value) {
        user.lastName = value;
      },
    );
  }

  Widget placeofBirthField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Doğum Yeri"),
      onSaved: (String value) {
        user.placeOfBirth = value;
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
                  user.gender = selectedGenders;
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
                    user.birthday = birthday.toString().substring(0, 10);
                  }));
            },
          )
        ],
      ),
    );
  }

  Widget submitButton() {
    return Container(
      padding: EdgeInsets.only(top: 45.0),
      child: RaisedButton(
        child: Text(
          "Complete",
          textDirection: TextDirection.ltr,
          style: TextStyle(fontSize: 20.0),
        ),
        onPressed: () {
          if (registerFormKey.currentState.validate()) {
            registerFormKey.currentState.save();
            basicPop(context, true);
            AddService().saveUser(user);
          }
          //  else {
          //   alrtFail(context);
          // }
        },
      ),
    );
  }
}

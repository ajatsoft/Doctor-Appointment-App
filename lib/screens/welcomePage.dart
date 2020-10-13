import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_turtle_v2/dbHelper/searchData.dart';
import 'package:fast_turtle_v2/models/adminModel.dart';
import 'package:fast_turtle_v2/models/doctorModel.dart';
import 'package:fast_turtle_v2/models/userModel.dart';
import 'package:fast_turtle_v2/screens/adminHomePage.dart';
import 'package:fast_turtle_v2/screens/doctorHomePage.dart';
import 'package:fast_turtle_v2/screens/registerPage.dart';
import 'package:fast_turtle_v2/screens/userHomePage.dart';
import 'package:flutter/material.dart';
import 'package:fast_turtle_v2/mixins/validation_mixin.dart';

class WelcomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WelcomePageState();
  }
}

class WelcomePageState extends State
    with SingleTickerProviderStateMixin, ValidationMixin {
  TabController _tabController;
  final userFormKey = GlobalKey<FormState>();
  final doctorFormKey = GlobalKey<FormState>();
  final adminFormKey = GlobalKey<FormState>();
  User user = User();
  Doctor doctor = Doctor();
  Admin admin = Admin();
  Future<QuerySnapshot> incomingData;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    this.incomingData =
        Firestore.instance.collection('tblUser').getDocuments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Fast Anadolu Appointment System",
          textDirection: TextDirection.ltr,
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white70,
          tabs: <Widget>[
            Text(
              "User",
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
            ),
            Text(
              "Doctor",
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
            ),
            Text(
              "Admin",
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                pagePlanWithForm(idField(0, context), passwordField(0),
                    "Welcome", userFormKey),
                registerButton()
              ])),
          pagePlanWithForm(idField(1, context), passwordField(1),
              "Doctor Login", doctorFormKey),
          pagePlanWithForm(
              adminNicknameField(), passwordField(2), "Admin Login", adminFormKey)
        ],
      ),
    );
  }

  void basicNavigator(dynamic page) async {
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));

    if (result != null && result == true) {
      RegisterPageState.alrtDone(context);
    }
  }

  Container registerButton() {
    return Container(
      child: FlatButton(
        child: Text(
          "Kayıt Ol",
          style: TextStyle(fontSize: 15.0),
        ),
        textColor: Colors.black,
        splashColor: Colors.cyanAccent,
        onPressed: () {
          basicNavigator(RegisterPage());
        },
      ),
    );
  }

  /*Container pagePlan(String pageHeader, String labelText) {
    return Container(
        padding: EdgeInsets.only(top: 30.0, left: 10.0, right: 10.0),
        // singlechildscrollview olmazsa, textfield a data login yapılmak istendiğinde ekrana klavye de yerleşiyor per görüntü bozuluyor, ...
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(top: 13.0, bottom: 10.0),
                  child: pageHeaderPlan(pageHeader)),
              TextField(
                  controller: txtTCNO,
                  maxLength: 11,
                  decoration: labelTextPlan(labelText)),
              TextField(
                controller: txtpassword,
                decoration: InputDecoration(labelText: "Şifre"),
              ),
              Container(
                padding: EdgeInsets.only(top: 30.0),
                child: FlatButton(
                  child: Text(
                    "Giriş Yap",
                    style: TextStyle(fontSize: 22.0),
                  ),
                  textColor: Colors.blueAccent,
                  splashColor: Colors.cyanAccent,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ));
  } */

  InputDecoration labelTextPlan(String value) {
    return InputDecoration(labelText: value);
  }

  Text pageHeaderPlan(String value) {
    return Text(
      value,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
    );
  }

  Container pagePlanWithForm(Widget firstTextField, Widget secondTextField,
      String pageHeader, GlobalKey<FormState> formKey) {
    return Container(
        margin: EdgeInsets.only(top: 25.0, right: 25.0, left: 25.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(top: 13.0, bottom: 10.0),
                  child: pageHeaderPlan(pageHeader),
                ),
                firstTextField,
                secondTextField,
                loginButton(formKey)
              ],
            ),
          ),
        ));
  }

  Widget idField(int tabIndex, BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "T.C. Id Numarası:",
        labelStyle: TextStyle(
            fontSize: 17.0, fontWeight: FontWeight.bold, color: Colors.grey),
      ),
      onSaved: (String value) {
        if (tabIndex == 0) {
          user.id = value;
        } else {
          doctor.id = value;
        }
      },
    );
  }

  Widget passwordField(int tabIndex) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Şifre:",
        labelStyle: TextStyle(
            fontSize: 17.0, fontWeight: FontWeight.bold, color: Colors.grey),
      ),
      validator: validatePassword,
      obscureText: true,
      onSaved: (String value) {
        if (tabIndex == 0) {
          user.password = value;
        } else if (tabIndex == 1) {
          doctor.password = value;
        } else {
          admin.password = value;
        }
      },
    );
  }

  Widget adminNicknameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "User Adı:"),
      validator: validateAdmin,
      onSaved: (String value) {
        admin.nickname = value;
      },
    );
  }

  bool idConfirm = false;
  bool passwordConfirm = false;
  var tempSearchStore = [];

  //entered id numarasına kayıtlı bir kullanıcı olup olmadıpını arayan metot...
  initiateSearch(enteredId, incomingPassword, int tabIndex, String searchWhere,
      String searchPass) {
    SearchService()
        .searchById(enteredId, incomingPassword, tabIndex)
        .then((QuerySnapshot docs) {
      for (int i = 0; i < docs.documents.length; i++) {
        tempSearchStore.add(docs.documents[i].data);

        if (tabIndex == 0) {
          user = User.fromMap(docs.documents[i].data());
        } else if (tabIndex == 1) {
          doctor = Doctor.fromMap(docs.documents[i].data());
        } else if (tabIndex == 2) {
          admin = Admin.fromMap(docs.documents[i].data());
        }
      }
    });
    for (var item in tempSearchStore) {
      if (item[searchWhere] == enteredId && item[searchPass] == incomingPassword) {
        idConfirm = true;
        passwordConfirm = true;
      }
    }
  }

  Widget loginButton(GlobalKey<FormState> formKey) {
    return Container(
      padding: EdgeInsets.only(top: 30.0),
      child: FlatButton(
        child: Text(
          "Giriş Yap",
          style: TextStyle(fontSize: 22.0),
        ),
        textColor: Colors.blueAccent,
        splashColor: Colors.cyanAccent,
        onPressed: () {
          idConfirm = true;
          passwordConfirm = true;
          formKey.currentState.validate();
          formKey.currentState.save();
          if (formKey == userFormKey) {
            initiateSearch(user.id, user.password, 0, 'id', 'password');

            if (idConfirm && passwordConfirm) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UserHomePage(user)));
            }
          } else if (formKey == doctorFormKey) {
            doctor.id = "testgmail1@gmail.com";
            doctor.password = "testgmail1";
            doctor.gender = "M";
            doctor.appointments = [DateTime.now()
              .add(Duration(days: 30))
              .toString()
              .substring(0, 10)];
            doctor.birthday = "28May";
            doctor.departmentId = 2222;
            doctor.favoriSayaci = 4;
            doctor.firstName = "Gautham";
            doctor.lastName = "Muppalla";
            doctor.placeOfBirth =  "VTZ";
            doctor.hospitalId = 1111;
            // initiateSearch(
            //     doctor.id, doctor.password, 1, 'id', 'password');

            if (idConfirm && passwordConfirm) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DoctorHomePage(doctor)));
            }
          } else if (formKey == adminFormKey) {
            initiateSearch(
                admin.nickname, admin.password, 2, 'nickname', 'password');

            if (idConfirm && passwordConfirm) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AdminHomePage(admin)));
            }
          }
        },
      ),
    );
  }
}

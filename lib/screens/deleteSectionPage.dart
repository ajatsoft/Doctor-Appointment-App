import 'package:fast_turtle_v2/dbHelper/delData.dart';
import 'package:fast_turtle_v2/models/hospitalModel.dart';
import 'package:fast_turtle_v2/models/sectionModel.dart';
import 'package:fast_turtle_v2/screens/showHospitals.dart';
import 'package:fast_turtle_v2/screens/showSections.dart';
import 'package:flutter/material.dart';

class DeleteSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DeleteSectionState();
  }
}

class DeleteSectionState extends State {
  Hospital hospital = Hospital();
  Section section = Section();
  bool hospitalChosenMi = false;
  bool departmentChosenMi = false;
  String textMessage = " ";
  double goruntu = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        title: Text(
          "Bölüm Silme Ekranı",
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
              child: Form(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      child: Text(
                        "UYARI!",
                        style: TextStyle(
                            fontSize: 50.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent),
                      ),
                    ),
                    Container(
                      child: Text(
                        "Bir bölüm sildiğinizde, o bölümde çalışan doctorları per o doctorların appointmentsını da silmiş olacaksınız.",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                    ),
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

  _silButton() {
    return RaisedButton(
      child: Text(
        "Seçili Bölümü Sil",
        textDirection: TextDirection.ltr,
        style: TextStyle(fontSize: 20.0),
      ),
      onPressed: () {
        if (hospitalChosenMi && departmentChosenMi) {
          alrtDepartmentSil(context);
        } else {
          alrtHospital(context, "Eksik bilgi var");
        }
      },
    );
  }

  void alrtDepartmentSil(BuildContext context) {
    var alrtAppointment = AlertDialog(
      title: Text(
        " Bölüm ile birlikte bölüme kayıtlı bütün doctorlar per appointmentsıda silinecektir. Devam etmek istiyor musunuz?",
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Hayır"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        SizedBox(
          width: 5.0,
        ),
        FlatButton(
          child: Text(
            "Yes",
            textAlign: TextAlign.center,
          ),
          onPressed: () {
            DelService().deleteSectionBySectionId(section, section.reference);
            Navigator.pop(context);
            Navigator.pop(context, true);
          },
        )
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alrtAppointment;
        });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_turtle_v2/dbHelper/searchData.dart';
import 'package:fast_turtle_v2/models/doctorModel.dart';
import 'package:fast_turtle_v2/models/hospitalModel.dart';
import 'package:fast_turtle_v2/models/sectionModel.dart';
import 'package:fast_turtle_v2/screens/showAppoForDoc.dart';
import 'package:fast_turtle_v2/screens/updateDoctorPass.dart';
import 'package:flutter/material.dart';

class DoctorHomePage extends StatefulWidget {
  final Doctor doctor;
  DoctorHomePage(this.doctor);
  @override
  _DoctorHomePageState createState() => _DoctorHomePageState(doctor);
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  Doctor _doctor;
  _DoctorHomePageState(this._doctor);

  Hospital hospital = Hospital(hospitalName: "clinique", hospitalId: 1111);
  Section department = Section(departmentName: "derma", departmentId: 2222, hospitalId: 1111);
  @override
  void initState() {
    super.initState();
    // SearchService()
    //     .searchHospitalById(_doctor.hospitalId)
    //     .then((QuerySnapshot docs) {
    //   this.hospital = Hospital(hospitalName: "clinique", hospitalId: 1111);
          // Hospital.fromMap(docs.documents[0].data());
    // });
    // SearchService()
    //     .searchSectionById(_doctor.departmentId)
    //     .then((QuerySnapshot docs) {
    //   this.department = Section(departmentName: "derma", departmentId: 2222, hospitalId: 1111);
          // Section.fromMap(docs.documents[0].data());
    // });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    String hospitalName, departmentName;
    // setState(() {
    //   hospitalName = hospital.hospitalName.toString();
    //   departmentName = department.departmentName;
    // });
    return Scaffold(
        appBar: AppBar(
          title: Text("Doctor Home Page"),
        ),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          Container(
            padding:
                EdgeInsets.only(top: 30.0, left: 5.0, right: 5.0, bottom: 25.0),
            color: Colors.blueAccent[200],
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(18.0),
                ),
                color: Colors.white,
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 13.0,
                  ),
                  Container(
                    constraints: BoxConstraints.tightFor(height: 60, width: 500),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        // Container(
                        //   padding: EdgeInsets.only(left: 18.0),
                        //   child: Icon(
                        //     Icons.healing,
                        //     size: 20.0,
                        //   ),
                        // ),
                        SizedBox(
                          width: 3.0,
                        ),
                        Container(
                          child: Text(
                            "_doctor.firstName",
                            style: TextStyle(
                                fontSize: 30.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        // Container(
                        //   child: Text(
                        //     "_doctor.lastName",
                        //     style: TextStyle(
                        //         fontSize: 30.0, fontWeight: FontWeight.bold),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.grey,
                    width: 370.0,
                    height: 0.4,
                  ),
                  _buildAttributeRow("T.C. ID Number", _doctor.id),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 20.0, left: 13.0),
                        child: Container(
                          alignment: Alignment.center,
                          color: Colors.greenAccent,
                          width: 120.0,
                          height: 25.0,
                          child: Text(
                            "hospital",
                            style: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0, left: 13.0),
                        child: Container(
                          child: Text(
                            "hospitalName",
                            style: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                  _buildAttributeRow("Department ", departmentName.toString()),
                  SizedBox(
                    height: 30.0,
                  )
                ],
              ),
            ),
          ),
          Container(
            width: screenSize.width,
            height: screenSize.height / 2,
            color: Colors.blueAccent[200],
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 5.0,
                ),
                _passwordUpdateButton(),
                SizedBox(
                  height: 7.0,
                ),
                _appointmentsiGotuntuleButton(),
                SizedBox(
                  height: 7.0,
                ),
                _exitButton(),
              ],
            ),
          )
        ])));
  }

  Widget _buildAttributeRow(var textMessage, var textValue) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 20.0, left: 13.0),
            child: Container(
              alignment: Alignment.center,
              color: Colors.greenAccent,
              width: 200.0,
              height: 25.0,
              child: Text(
                "textMessage",
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            width: 17.0,
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0, left: 13.0),
            child: Container(
              child: Text(
                textValue,
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }

  _passwordUpdateButton() {
    return Container(
      padding: EdgeInsets.all(1.0),
      width: 390.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Colors.white),
      child: FlatButton(
        splashColor: Colors.grey,
        highlightColor: Colors.white70,
        child: Text(
          "Enter Update",
          style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          basicNavigator(OnlyUpdatePassword(_doctor), "Operation Completed");
        },
      ),
    );
  }

  _appointmentsiGotuntuleButton() {
    return Container(
      padding: EdgeInsets.all(1.0),
      width: 390.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Colors.white),
      child: FlatButton(
        splashColor: Colors.grey,
        highlightColor: Colors.white70,
        child: Text(
          "Appointment View",
          style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      BuildAppointmentListForDoctor(_doctor)));
        },
      ),
    );
  }

  void basicNavigator(dynamic page, String message) async {
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));

    if (result != null && result == true) {
      alrtHospital(context, message);
    }
  }

  void alrtHospital(BuildContext context, String message) {
    var alertDoctor = AlertDialog(
      title: Text(
        "Information!",
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

  _exitButton() {
    return Container(
      padding: EdgeInsets.all(1.0),
      width: 390.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Colors.redAccent),
      child: FlatButton(
        splashColor: Colors.grey,
        highlightColor: Colors.white70,
        child: Text(
          "Safe Exit",
          style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

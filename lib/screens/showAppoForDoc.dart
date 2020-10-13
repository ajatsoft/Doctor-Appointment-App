import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_turtle_v2/dbHelper/addData.dart';
import 'package:fast_turtle_v2/dbHelper/delData.dart';
import 'package:fast_turtle_v2/dbHelper/updateData.dart';
import 'package:fast_turtle_v2/models/activeAppointmentModel.dart';
import 'package:fast_turtle_v2/models/doctorModel.dart';
import 'package:flutter/material.dart';

class BuildAppointmentListForDoctor extends StatefulWidget {
  final Doctor doctor;
  BuildAppointmentListForDoctor(this.doctor);
  @override
  _BuildAppointmentListState createState() =>
      _BuildAppointmentListState(doctor);
}

class _BuildAppointmentListState extends State<BuildAppointmentListForDoctor> {
  Doctor doctor;
  _BuildAppointmentListState(this.doctor);

  String gonder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pending Appointments"),
      ),
      body: _buildStremBuilder(context),
    );
  }

  _buildStremBuilder(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("tbleActiveAppointments")
          .where('doctorToken', isEqualTo: doctor.id)
          .where('appointmentDate',
              isLessThanOrEqualTo: (DateTime.now()
                  .add(Duration(days: 30))
                  .toString()
                  .substring(0, 10)))
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          return _buildBody(context, snapshot.data.documents);
        }
      },
    );
  }

  Widget _buildBody(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: EdgeInsets.only(top: 15.0),
      children: snapshot
          .map<Widget>((data) => _buildListItem(context, data))
          .toList(),
    );
  }

  _buildListItem(BuildContext context, DocumentSnapshot data) {
    final randevu = ActiveAppointment.fromSnapshot(data);
    return Padding(
      key: ValueKey(randevu.reference),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.greenAccent,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10.0)),
        child: ListTile(
          leading: CircleAvatar(
            child: Icon(Icons.person),
          ),
          title: Row(
            children: <Widget>[
              Text(
                randevu.patientName.toString(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              SizedBox(
                width: 3.0,
              ),
              Text(
                randevu.patientLastName.toString(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
            ],
          ),
          subtitle: Text(randevu.appointmentDate),
          trailing: Text(
            "Complete",
            style:
                TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
          ),
          onTap: () {
            alrtAppointmentComplete(context, randevu);
          },
        ),
      ),
    );
  }

  void alrtAppointmentComplete(BuildContext context, ActiveAppointment rand) {
    var alrtAppointment = AlertDialog(
      title: Text(
        "Appointment Finish",
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            "Yes",
            textAlign: TextAlign.center,
          ),
          onPressed: () {
            UpdateService()
                .updateDoctorAppointments(doctor.id, rand.appointmentDate);
            DelService().deleteActiveAppointment(rand);
            AddService().addPastAppointment(rand);
            Navigator.pop(context);
            Navigator.pop(context);
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

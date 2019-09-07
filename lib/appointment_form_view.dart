import 'package:flutter/material.dart';
// import 'package:meta/meta.dart';

class AppointmentView extends StatefulWidget {
  @override
  State createState() => new _AppointmentViewState();
}

class _AppointmentViewState extends State<AppointmentView> { 
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Appointment View"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            // Navigate back to first route when tapped.
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}
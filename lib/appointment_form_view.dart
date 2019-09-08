import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:meta/meta.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'dart:developer';


class AppointmentView extends StatefulWidget {
  @override
  State createState() => new _AppointmentViewState();
}

class _AppointmentViewState extends State<AppointmentView> {
  
  final _formKey = GlobalKey<FormState>();

  //id will be negative for new appointments
  int id = -1;
  String _title = '';
  DateTime _dateTime;
  int _duration = 30;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: new AppBar(
          title: new Text("Book an appointment"),
        ),
        body: new SingleChildScrollView(
          child: Container(
            padding: new EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.title),
                    hintText: 'Enter appointment title',
                    labelText: 'Title *',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter the event name';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    setState(() {
                      _title = val;
                    });
                  },
                  initialValue: _title,
                ),
                BasicDateTimeField(
                  onSaved: (val) {
                    _dateTime = val;
                  }
                ),
                TextFormField(
                  initialValue: _duration.toString(),
                  decoration: const InputDecoration(
                    icon: Icon(Icons.access_time),
                    hintText: 'Enter duration',
                    labelText: 'Meeting Duration *',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter the event name';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    setState(() {
                      _duration = int.parse(val);
                    });
                  },
                  // initialValue: _duration,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter(RegExp("^[1-5]?[0-9]"))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: RaisedButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      onPressed: () {
                        // Validate returns true if the form is valid, or false
                        // otherwise.
                        if (_formKey.currentState.validate()) {

                          //_formKey.currentState() will contain the data
                          // log('${_formKey.currentState()}');

                          _formKey.currentState.save();

                          log('title $_title');
                          log('date time $_dateTime');
                          log('duration $_duration');
                          //send all of them to day_view
                          // Navigator.pop(context);
                        }
                      },
                      child: Text('Submit'),
                    ),
                  )
                ),
              ],
            )
          )
        )
      )
    );
  }
}

typedef DateTimeSaveCallback = void Function(DateTime dt);

class BasicDateTimeField extends StatelessWidget {
  final format = DateFormat("yyyy-MM-dd HH:mm");
  
  final DateTimeSaveCallback onSaved;

  BasicDateTimeField({Key key, this.onSaved});

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      // Text('Enter date and time for the appointment (${format.pattern})'),
      DateTimeField(
        decoration: const InputDecoration(
          icon: Icon(Icons.calendar_today),
          hintText: 'Enter date and time',
          labelText: 'Date and time *',
        ),
        format: format,
        onShowPicker: (context, currentValue) async {
          final date = await showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
          if (date != null) {
            final time = await showTimePicker(
              context: context,
              initialTime:
                  TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
            );
            onSaved(DateTimeField.combine(date, time));
            return DateTimeField.combine(date, time);
          } 
          else {
            onSaved(currentValue);
            return currentValue;
          }
        },
      ),
    ]);
  }
}

// class _AppointmentViewState extends State<AppointmentView> { 
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Appointment View"),
//       ),
//       body: Center(
//         child: RaisedButton(
//           onPressed: () {
//             // Navigate back to first route when tapped.
//             Navigator.pop(context);
//           },
//           child: Text('Go back!'),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../day_view/models/event.dart';
import '../day_view/models/event_msg.dart';
import 'basic_date_time_view.dart';

class AppointmentView extends StatefulWidget {
  
  final Event event;
  final int id;

  AppointmentView({Key key, @required this.event, @required this.id});

  @override
  State createState() => new _AppointmentViewState(event: event, id: id);
}

class _AppointmentViewState extends State<AppointmentView> {
  
  final Event event;
  final int id;
  
  _AppointmentViewState({Key key, @required this.event, @required this.id});

  final _formKey = GlobalKey<FormState>();

  //id will be negative for new appointments
  String _title;
  DateTime _startTime;
  int _duration;

  @override
  void initState() {
    super.initState();
    
    _title = event.title;
    _startTime = event.startTime;
    _duration = event.duration;
  }

  saveEvent() {
    //save event
    Event ev = new Event(title: _title, startTime: _startTime, duration: _duration);
    Navigator.pop(context, new EventMsg(event: ev, id: id, delete: false));
  }
  
  deleteEvent() {
    //save event
    Event ev = new Event(title: _title, startTime: _startTime, duration: _duration);
    Navigator.pop(context, new EventMsg(event: ev, id: id, delete: true));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: new AppBar(
          title: new Text("Book an appointment"),
          actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              deleteEvent();
            },
          )
        ],
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
                  startTime: _startTime,
                  onSaved: (val) {
                    _startTime = val;
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
                    WhitelistingTextInputFormatter(RegExp("^[1-9]?[0-9]?[0-9]"))
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
                          _formKey.currentState.save();
                          saveEvent();
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
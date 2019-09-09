import 'package:flutter/material.dart';
// import 'package:meta/meta.dart';

import 'package:calendar_views/day_view.dart';

import '../utils/all.dart';
import '../appointment_form_view/index_view.dart';
import 'models/event.dart';

class DayView extends StatefulWidget {
  @override
  State createState() => new _DayViewState();
}

class _DayViewState extends State<DayView> {
  DateTime _selectedDate;
  List<Event> _events;

  @override
  void initState() {
    super.initState();
    _selectedDate = new DateTime.now();
  
    _events = <Event>[];
  }

  setDate(DateTime selectedDate) {
    setState(() {
      _selectedDate = selectedDate;
    });
  }

  void _openAppointmentForm([int id = -1]) async { 
    Event newEvent = new Event(duration: 60, title: '', startTime: DateTime.now());
    if( id > -1 ) {
      newEvent = _events[id];  
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AppointmentView(event: newEvent, id: id)),
    ).then((msg) {
      Event newEv = msg.event;
      int evId = msg.id;
      bool isValid = true;

      //delete an existing event
      if( msg.delete && evId > -1 ) {
        _events.removeAt(evId);
        return;
      }

      //check if there are any clashes or not
      _events.forEach((event) {
        int eventIndex = _events.indexOf(event);
        //skip check if event ids are same
        if( eventIndex == evId ) {
          return;
        }

        //event times
        DateTime eventStart = event.startTime;
        DateTime eventEnd = event.startTime.add(new Duration(minutes: event.duration));

        //newEv times
        DateTime newEvStart = newEv.startTime;
        DateTime newEvEnd = newEv.startTime.add(new Duration(minutes: newEv.duration));

        if( eventStart.millisecondsSinceEpoch <= newEvEnd.millisecondsSinceEpoch && 
            eventEnd.millisecondsSinceEpoch >= newEvStart.millisecondsSinceEpoch
        ) {
          isValid = false;
        }
      });

      //show a pop up if event overlapped
      if( !isValid ) {
        print('not valid');
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: new Text('OOPS'),
              content: new Text('Sorry your appointment overlapped with an existing one! Please change the time'),
            );
          }
        );
      } else {
        //update event list
        if( evId > -1 ) {
          _events[evId] = newEv;
        }
        else {
          _events.add(msg.event);
        }
      }
    });
  }

  void _openDatePicker() async {
    DateTime selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2200),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      },
    );
    setDate(selectedDate);
  }

  List<StartDurationItem> _getEventsOfDay(DateTime day) {
    List<Event> eventsOfTheDay = <Event>[];

    _events.forEach((event) {
      DateTime eventDay = event.startTime;
      if (day.year == eventDay.year &&
        day.month == eventDay.month &&
        day.day == eventDay.day) {
        eventsOfTheDay.add(event);
      }
    });

    return eventsOfTheDay
        .map(
          (event) { 
            int id = _events.indexOf(event);
            return new StartDurationItem(
                startMinuteOfDay: event.startTime.hour * 60 + event.startTime.minute,
                duration: event.duration,
                builder: (context, itemPosition, itemSize) => _eventBuilder(
                      context,
                      itemPosition,
                      itemSize,
                      event,
                      id
                    ),
              );
          }
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> days = getDaysRange(_selectedDate);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("${_selectedDate.day} ${monthToAbbreviatedString(_selectedDate.month)}"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              _openDatePicker();
            },
          )
        ],
      ),
      body: new DayViewEssentials(
        properties: new DayViewProperties(
          days: days,
        ),
        child: new Column(
          children: <Widget>[
            new Container(
              color: Colors.grey[200],
              child: new DayViewDaysHeader(
                headerItemBuilder: _headerItemBuilder,
              ),
            ),
            new Expanded(
              child: new SingleChildScrollView(
                child: new DayViewSchedule(
                  heightPerMinute: 1.0,
                  components: <ScheduleComponent>[
                    new TimeIndicationComponent.intervalGenerated(
                      generatedTimeIndicatorBuilder:
                          _generatedTimeIndicatorBuilder,
                    ),
                    new SupportLineComponent.intervalGenerated(
                      generatedSupportLineBuilder: _generatedSupportLineBuilder,
                    ),
                    new DaySeparationComponent(
                      generatedDaySeparatorBuilder:
                          _generatedDaySeparatorBuilder,
                    ),
                    new EventViewComponent(
                      getEventsOfDay: _getEventsOfDay,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAppointmentForm,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _headerItemBuilder(BuildContext context, DateTime day) {
    return new Container(
      color: Colors.grey[300],
      padding: new EdgeInsets.symmetric(vertical: 4.0),
      child: new Column(
        children: <Widget>[
          new Text(
            "${weekdayToAbbreviatedString(day.weekday)}",
            style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 9.5),
          ),
          new Text(
            "${day.day}",
            style: new TextStyle(fontSize: 8),
          ),
        ],
      ),
    );
  }

  Positioned _generatedTimeIndicatorBuilder(
    BuildContext context,
    ItemPosition itemPosition,
    ItemSize itemSize,
    int minuteOfDay,
  ) {
    return new Positioned(
      top: itemPosition.top,
      left: itemPosition.left,
      width: itemSize.width,
      height: itemSize.height,
      child: new Container(
        child: new Center(
          child: new Text(minuteOfDayToHourMinuteString(minuteOfDay)),
        ),
      ),
    );
  }

  Positioned _generatedSupportLineBuilder(
    BuildContext context,
    ItemPosition itemPosition,
    double itemWidth,
    int minuteOfDay,
  ) {
    return new Positioned(
      top: itemPosition.top,
      left: itemPosition.left,
      width: itemWidth,
      child: new Container(
        height: 0.7,
        color: Colors.grey[700],
      ),
    );
  }

  Positioned _generatedDaySeparatorBuilder(
    BuildContext context,
    ItemPosition itemPosition,
    ItemSize itemSize,
    int daySeparatorNumber,
  ) {
    return new Positioned(
      top: itemPosition.top,
      left: itemPosition.left,
      width: itemSize.width,
      height: itemSize.height,
      child: new Center(
        child: new Container(
          width: 0.7,
          color: Colors.grey,
        ),
      ),
    );
  }

  Positioned _eventBuilder(
    BuildContext context,
    ItemPosition itemPosition,
    ItemSize itemSize,
    Event event,
    int id
  ) {
    return new Positioned(
      top: itemPosition.top,
      left: itemPosition.left,
      width: itemSize.width,
      height: itemSize.height,
      child: new InkWell(
        onTap: () {
          _openAppointmentForm(id);
        },
        child: new Container(
          margin: new EdgeInsets.only(left: 1, right: 1, bottom: 1.0),
          padding: new EdgeInsets.all(2.0),
          color: Colors.green[200],
          child: new Text("${event.title}"),
        ),
      )
    );
  }
}
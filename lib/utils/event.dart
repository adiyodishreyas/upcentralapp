import 'package:flutter/material.dart';

@immutable
class Event {
  Event({
    @required this.duration,
    @required this.title,
    @required this.startTime,
  });

  final int duration;
  final String title;
  final DateTime startTime;
}

@immutable
class EventMsg {

  EventMsg({
    @required this.event,
    @required this.id
  });

  final Event event;
  final int id;
}
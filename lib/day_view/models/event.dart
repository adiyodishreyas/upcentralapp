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

import 'package:flutter/material.dart';
import 'event.dart';

@immutable
class EventMsg {

  EventMsg({
    @required this.event,
    @required this.id,
    @required this.delete
  });

  final Event event;
  final int id;
  final bool delete;
}
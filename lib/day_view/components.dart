import 'package:flutter/material.dart';
import '../utils/all.dart';
import 'package:calendar_views/day_view.dart';
import 'models/event.dart';

Widget headerItemBuilder(BuildContext context, DateTime day) {
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

Positioned generatedTimeIndicatorBuilder(
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

  Positioned generatedSupportLineBuilder(
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

  Positioned generatedDaySeparatorBuilder(
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

Positioned eventBuilder(
  BuildContext context,
  ItemPosition itemPosition,
  ItemSize itemSize,
  Event event,
  int id,
  Function onTap,
) {
  return new Positioned(
    top: itemPosition.top,
    left: itemPosition.left,
    width: itemSize.width,
    height: itemSize.height,
    child: new InkWell(
      onTap: () {
        onTap(id);
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

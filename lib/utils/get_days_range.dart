List<DateTime> getDaysRange(DateTime selectedDate) {
    List<DateTime> daysList = <DateTime>[];
    int weekDay = selectedDate.weekday;
    //get the monday of the week
    DateTime mondayDateTime = selectedDate.toUtc().subtract(new Duration(days: weekDay - 1)).toLocal();
    for(int i = 0; i <= 6; i++) {
      daysList.add(mondayDateTime.toUtc().add(new Duration(days: i)).toLocal());
    }
    return daysList;
}
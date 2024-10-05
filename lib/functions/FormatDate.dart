String formatTimeOfDay(DateTime? dateTime) {
  if (dateTime == null) {
    return 'Anytime';
  }

  // Get the hour and minute from the DateTime object
  int hour = dateTime.hour;
  int minute = dateTime.minute;

  // Determine if the time is AM or PM
  String period = hour >= 12 ? 'PM' : 'AM';

  // Convert hour to 12-hour format
  hour = hour % 12;
  hour = hour == 0 ? 12 : hour;

  // Format the minute to always be two digits
  String minuteStr = minute.toString().padLeft(2, '0');

  // Return the formatted string
  return '$hour:$minuteStr$period';
}

class CalendarEventModel {
  final int? id;
  final String title;
  final String description;
  final String location;
  final DateTime startTime;
  final DateTime endTime;
  final String timeZone;
  final int calendarId;

  CalendarEventModel({
    this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.timeZone,
    required this.calendarId,
  });
}

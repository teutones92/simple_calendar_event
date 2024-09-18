/// A model class representing a calendar event.
///
/// The [CalendarEventModel] class contains details about a calendar event,
/// including its title, description, location, start and end times, time zone,
/// and the ID of the calendar it belongs to.
///
/// The class also provides a factory method [fromJson] to create an instance
/// of [CalendarEventModel] from a JSON map.
///
/// Properties:
/// - `id` (int?): The unique identifier of the event. This is optional.
/// - `title` (String): The title of the event.
/// - `description` (String): A detailed description of the event.
/// - `location` (String): The location where the event will take place.
/// - `startTime` (DateTime): The start time of the event.
/// - `endTime` (DateTime): The end time of the event.
/// - `timeZone` (String): The time zone in which the event occurs.
/// - `calendarId` (int): The ID of the calendar to which the event belongs.
///
/// Example usage:
/// ```dart
/// Map<String, dynamic> json = {
///   'id': 1,
///   'title': 'Meeting',
///   'description': 'Discuss project updates',
///   'location': 'Conference Room',
///   'startTime': DateTime.parse('2023-10-01T10:00:00Z'),
///   'endTime': DateTime.parse('2023-10-01T11:00:00Z'),
///   'timeZone': 'UTC',
///   'calendarId': 123,
/// };
///
/// CalendarEventModel event = CalendarEventModel.fromJson(json);
/// ```
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

  static CalendarEventModel fromJson(Map item) {
    return CalendarEventModel(
      id: item.cast<String, dynamic>()['id'],
      title: item.cast<String, dynamic>()['title'],
      description: item.cast<String, dynamic>()['description'],
      location: item.cast<String, dynamic>()['location'],
      startTime: DateTime.fromMillisecondsSinceEpoch(
          item.cast<String, dynamic>()['startTime']),
      endTime: DateTime.fromMillisecondsSinceEpoch(
          item.cast<String, dynamic>()['endTime']),
      timeZone: item.cast<String, dynamic>()['timeZone'],
      calendarId: item.cast<String, dynamic>()['calendarId'],
    );
  }
}

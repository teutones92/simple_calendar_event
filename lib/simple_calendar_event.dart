import 'package:simple_calendar_event/model/calendar_event_model.dart';
import 'package:simple_calendar_event/model/calendar_model.dart';
import 'package:simple_calendar_event/simple_calendar_event_method_channel.dart';

import 'simple_calendar_event_platform_interface.dart';
import 'package:flutter/services.dart';

export 'model/calendar_event_model.dart';
export 'model/calendar_model.dart';

/// This file contains the necessary permissions for accessing the calendar on Android.
/// Make sure to include the following permissions in your AndroidManifest.xml file:
/// - android.permission.READ_CALENDAR
/// - android.permission.WRITE_CALENDAR
// <uses-permission android:name="android.permission.READ_CALENDAR"/>
// <uses-permission android:name="android.permission.WRITE_CALENDAR"/>

class SimpleCalendarEvent extends MethodChannelSimpleCalendarEvent {
  static const MethodChannel _channel = MethodChannel('simple_calendar_event');

  @override
  Future<String?> getPlatformVersion() {
    return SimpleCalendarEventPlatform.instance.getPlatformVersion();
  }

  static Future<List<CalendarModel>> getCalendars() async {
    final List<CalendarModel> list = [];
    final resp = await _channel.invokeMethod('getCalendars');
    for (var item in resp) {
      list.add(CalendarModel.fromJson(item));
    }
    return list;
  }

  /// Adds an event to the calendar.
  ///
  /// This method adds an event to the device's calendar with the specified [title],
  /// [description], [location], [startTime], and [endTime].
  ///
  /// The [title] parameter is the title of the event.
  ///
  /// The [description] parameter is the description of the event.
  ///
  /// The [location] parameter is the location of the event example 'America/NewYork'.
  ///
  /// The [startTime] parameter is the start time of the event.
  ///
  /// The [endTime] parameter is the end time of the event.
  ///
  /// Returns the ID of the added event as an [int].
  ///
  /// Throws an exception if there is an error adding the event to the calendar.
  static Future<int?> addEventToCalendar(
      {required CalendarEventModel model}) async {
    final int? eventId = await _channel.invokeMethod('addEventToCalendar', {
      'title': model.title,
      'description': model.description,
      'location': model.location, // EXAMPLE 'America/New_York'
      'startTime': model.startTime.millisecondsSinceEpoch,
      'endTime': model.endTime.millisecondsSinceEpoch,
      'timeZone': model.timeZone,
      'calendarId': model.calendarId,
    });
    return eventId;
  }

  /// Removes an event with the specified [eventId].
  ///
  /// This method is used to remove a calendar event by invoking the 'removeEvent' method on the channel.
  /// The [eventId] parameter specifies the ID of the event to be removed.
  ///
  /// Example usage:
  /// ```dart
  /// await SimpleCalendarEvent.removeEvent(123);
  /// ```
  ///
  /// Throws a [PlatformException] if an error occurs while invoking the method.
  static Future<bool> removeEvent(int eventId) async {
    return await _channel.invokeMethod('removeEvent', {'eventId': eventId});
  }
}

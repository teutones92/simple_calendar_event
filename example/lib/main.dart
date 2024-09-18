import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simple_calendar_event/simple_calendar_event.dart';
import 'package:simple_calendar_event_example/widgets/calendar_grid_example_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ValueNotifier _permission = ValueNotifier<bool>(false);

  final StreamController<List<CalendarEventModel>> _eventController =
      StreamController<List<CalendarEventModel>>.broadcast();

  Stream<List<CalendarEventModel>> get eventsStream => _eventController.stream;

  final ValueNotifier<CalendarEventModel?> eventSelected = ValueNotifier(null);

  @override
  void initState() {
    getPermission();
    super.initState();
  }

  void getPermission() async {
    final resp = await SimpleCalendarEvent.getPermission();
    _permission.value = resp;
  }

  void addEvent(BuildContext context) async {
    final mountedContext = context;
    final calendars = await SimpleCalendarEvent.getCalendars();
    if (context.mounted && calendars.isEmpty) {
      ScaffoldMessenger.of(mountedContext).showSnackBar(
        const SnackBar(
          content:
              Text('No calendars found on the device must set up a calendar'),
        ),
      );
      return;
    }
    final eventId = await SimpleCalendarEvent.addEventToCalendar(
        model: CalendarEventModel(
      title: 'Test Event',
      description: 'This is a test event',
      startTime: DateTime.now(),
      endTime: DateTime.now().add(const Duration(hours: 1)),
      timeZone: DateTime.now().timeZoneName,
      location: 'America/New_York',
      calendarId: calendars
          .where((element) => element.name == element.ownerName)
          .first
          .id,
    ));
    if (context.mounted) {
      ScaffoldMessenger.of(mountedContext).showSnackBar(
        SnackBar(
          content: Text(eventId != null && eventId > 0
              ? 'Event added successfully'
              : 'Failed to add event'),
        ),
      );
    }
    getEvents();
  }

  void removeEvent(BuildContext context) async {
    final mountedContext = context;
    if (eventSelected.value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an event to remove'),
        ),
      );
      return;
    }
    final resp =
        await SimpleCalendarEvent.removeEvent(eventSelected.value!.id!);
    if (context.mounted) {
      ScaffoldMessenger.of(mountedContext).showSnackBar(
        SnackBar(
          content: Text(
              resp ? 'Event removed successfully' : 'Failed to remove event'),
        ),
      );
    }
    getEvents();
  }

  Future<List<CalendarEventModel>> getEvents() async {
    final List<CalendarEventModel> list = [];
    final calendars = await SimpleCalendarEvent.getCalendars();
    if (calendars.isNotEmpty) {
      final events = await SimpleCalendarEvent.getEvents(
          calendarId: calendars
              .where((element) => element.name == element.ownerName)
              .first
              .id);
      list.addAll(events);
    }
    await Future.delayed(const Duration(milliseconds: 500));
    _eventController.add(list);
    eventSelected.value = null;
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Simple Calendar Event Example'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ValueListenableBuilder(
            valueListenable: _permission,
            builder: (context, perm, __) {
              return Center(
                child: ListView(
                  children: [
                    StreamBuilder(
                      stream: eventsStream,
                      builder: (context, snapshot) {
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: snapshot.hasData && snapshot.data!.isNotEmpty
                              ? CalendarGridExampleView(
                                  events: snapshot.data!,
                                  valueEvent: eventSelected,
                                )
                              : const Center(
                                  child: Text('No events found'),
                                ),
                        );
                      },
                    ),
                    const SizedBox(height: 50),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: getPermission,
                          child: const Text('Get Permission')),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.green,
                          ),
                          onPressed: perm ? () => getEvents() : null,
                          child: const Text('get Events')),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: perm ? () => addEvent(context) : null,
                          child: const Text('Add Event')),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                          ),
                          onPressed: perm ? () => removeEvent(context) : null,
                          child: const Text('Remove Event')),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

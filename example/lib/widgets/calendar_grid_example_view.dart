import 'package:flutter/material.dart';
import 'package:simple_calendar_event/model/calendar_event_model.dart';

class CalendarGridExampleView extends StatelessWidget {
  const CalendarGridExampleView(
      {super.key, required this.events, required this.valueEvent});
  final List<CalendarEventModel> events;
  final ValueNotifier<CalendarEventModel?> valueEvent;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return ValueListenableBuilder(
            valueListenable: valueEvent,
            builder: (context, snapshot, _) {
              return Card(
                color: event.id == snapshot?.id ? Colors.blue : Colors.white,
                child: ListTile(
                  leading: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Event_ID: ${event.id.toString()}'),
                      Text('Calendar_ID: ${event.calendarId.toString()}'),
                    ],
                  ),
                  title: Text(event.title),
                  subtitle: Text(event.description),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(event.startTime.toString()),
                      Text(event.endTime.toString()),
                    ],
                  ),
                  onTap: () {
                    valueEvent.value = event;
                  },
                ),
              );
            });
      },
    );
  }
}

# Simple Calendar Event Plugin

The Simple Calendar Event plugin for Flutter allows you to interact with the native calendar on Android devices. With this plugin, you can retrieve available calendars, add events, and remove events directly from your Flutter application.

## Features

- Retrieve a list of available calendars on the device.
- Add events to a selected calendar.
- Remove events from the calendar using their ID.

## Requirements

- Flutter 2.0 or higher.
- Android SDK 21 or higher.

## Installation

Add the dependency to your `pubspec.yaml` file:

```yaml
dependencies:
    simple_calendar_event: ^1.0.0
```

Run the following command in the terminal to install the dependency:

```bash
flutter pub get
```

## Usage

### Import the Plugin

```dart
import 'package:simple_calendar_event/simple_calendar_event.dart';
```

### Retrieve Calendars

```dart
List<CalendarModel> calendars = await SimpleCalendarEvent.getCalendars();
```

### Add an Event

```dart
int? eventId = await SimpleCalendarEvent.addEventToCalendar(
    model: CalendarEventModel(
        title: "Meeting",
        description: "Meeting with the development team",
        location: "Office",
        startTime: DateTime(2024, 9, 10, 9, 0),
        endTime: DateTime(2024, 9, 10, 10, 0),
        timeZone: "America/New_York",
        calendarId: 1,
    ),
);
```

### Remove an Event

```dart
bool success = await SimpleCalendarEvent.removeEvent(123);
```

## Contributing

If you'd like to contribute to this project, please follow these steps:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/new-feature`).
3. Make your changes and commit them (`git commit -m 'Add new feature'`).
4. Push to the branch (`git push origin feature/new-feature`).
5. Open a Pull Request.

## Contact

For any questions or support, please contact:

Carlos Díaz
[Email: teutones92@gmail.com](mailto:teutones92@gmail.com)
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
## Additional Information

### Classes

#### CalendarModel

Represents a calendar with the following properties:

- `id`: The ID of the calendar.
- `name`: The name of the calendar.
- `accountName`: The account name associated with the calendar.
- `ownerName`: The owner of the calendar.
- `displayName`: The display name of the calendar.

#### CalendarEventModel

Represents an event with the following properties:

- `id`: The ID of the event (optional).
- `title`: The title of the event.
- `description`: The description of the event.
- `location`: The location of the event.
- `startTime`: The start time of the event.
- `endTime`: The end time of the event.
- `timeZone`: The time zone for the event.
- `calendarId`: The ID of the calendar where the event will be added.

### Permissions

Ensure that you include the following permissions in your AndroidManifest.xml file:

```xml
<uses-permission android:name="android.permission.READ_CALENDAR"/>
<uses-permission android:name="android.permission.WRITE_CALENDAR"/>
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
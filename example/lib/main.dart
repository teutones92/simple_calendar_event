import 'package:flutter/material.dart';
import 'package:simple_calendar_event/simple_calendar_event.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  void test() async {
    final calendars = await SimpleCalendarEvent.getCalendars();
    debugPrint(calendars.toString());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: TextButton(
              onPressed: () {
                test();
              },
              child: const Text('Test')),
        ),
      ),
    );
  }
}

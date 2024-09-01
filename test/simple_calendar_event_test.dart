import 'package:flutter_test/flutter_test.dart';
import 'package:simple_calendar_event/simple_calendar_event.dart';
import 'package:simple_calendar_event/simple_calendar_event_platform_interface.dart';
import 'package:simple_calendar_event/simple_calendar_event_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSimpleCalendarEventPlatform
    with MockPlatformInterfaceMixin
    implements SimpleCalendarEventPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SimpleCalendarEventPlatform initialPlatform = SimpleCalendarEventPlatform.instance;

  test('$MethodChannelSimpleCalendarEvent is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSimpleCalendarEvent>());
  });

  test('getPlatformVersion', () async {
    SimpleCalendarEvent simpleCalendarEventPlugin = SimpleCalendarEvent();
    MockSimpleCalendarEventPlatform fakePlatform = MockSimpleCalendarEventPlatform();
    SimpleCalendarEventPlatform.instance = fakePlatform;

    expect(await simpleCalendarEventPlugin.getPlatformVersion(), '42');
  });
}

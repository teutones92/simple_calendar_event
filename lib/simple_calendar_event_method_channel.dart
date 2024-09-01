import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'simple_calendar_event_platform_interface.dart';

/// An implementation of [SimpleCalendarEventPlatform] that uses method channels.
class MethodChannelSimpleCalendarEvent extends SimpleCalendarEventPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('simple_calendar_event');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}

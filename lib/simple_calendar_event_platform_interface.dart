import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'simple_calendar_event_method_channel.dart';

abstract class SimpleCalendarEventPlatform extends PlatformInterface {
  /// Constructs a SimpleCalendarEventPlatform.
  SimpleCalendarEventPlatform() : super(token: _token);

  static final Object _token = Object();

  static SimpleCalendarEventPlatform _instance = MethodChannelSimpleCalendarEvent();

  /// The default instance of [SimpleCalendarEventPlatform] to use.
  ///
  /// Defaults to [MethodChannelSimpleCalendarEvent].
  static SimpleCalendarEventPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SimpleCalendarEventPlatform] when
  /// they register themselves.
  static set instance(SimpleCalendarEventPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}

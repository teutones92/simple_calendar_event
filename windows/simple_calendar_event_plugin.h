#ifndef FLUTTER_PLUGIN_SIMPLE_CALENDAR_EVENT_PLUGIN_H_
#define FLUTTER_PLUGIN_SIMPLE_CALENDAR_EVENT_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace simple_calendar_event {

class SimpleCalendarEventPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  SimpleCalendarEventPlugin();

  virtual ~SimpleCalendarEventPlugin();

  // Disallow copy and assign.
  SimpleCalendarEventPlugin(const SimpleCalendarEventPlugin&) = delete;
  SimpleCalendarEventPlugin& operator=(const SimpleCalendarEventPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace simple_calendar_event

#endif  // FLUTTER_PLUGIN_SIMPLE_CALENDAR_EVENT_PLUGIN_H_

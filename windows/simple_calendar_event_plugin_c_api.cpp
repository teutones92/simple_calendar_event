#include "include/simple_calendar_event/simple_calendar_event_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "simple_calendar_event_plugin.h"

void SimpleCalendarEventPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  simple_calendar_event::SimpleCalendarEventPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}

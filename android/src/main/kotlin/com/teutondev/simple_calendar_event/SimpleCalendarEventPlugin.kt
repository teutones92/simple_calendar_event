package com.teutondev.simple_calendar_event

import android.content.ContentUris
import android.content.ContentValues
import android.net.Uri
import android.provider.CalendarContract
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

data class CalendarData(val id: Int, val name: String, val accountName: String, val ownerName: String, val displayName: String)

fun CalendarData.toMap(): Map<String, Any?> {
    return mapOf(
        "id" to id,
        "name" to name,
        "accountName" to accountName,
        "ownerName" to ownerName,
        "displayName" to displayName
    )
}

class SimpleCalendarEventPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: android.content.Context

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "simple_calendar_event")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        when (call.method) {
            "getCalendars" -> {
                val calendars = getCalendars()
                result.success(calendars)
            }
            "addEventToCalendar" -> {
                val calendarId = call.argument<Int>("calendarId")
                val title = call.argument<String>("title")
                val description = call.argument<String>("description")
                val location = call.argument<String>("location")
                val startTime = call.argument<Long>("startTime")
                val endTime = call.argument<Long>("endTime")
                val timeZone = call.argument<String>("timeZone")
                val eventId = addEventToCalendarAndGetId(calendarId, title, description, location, startTime, endTime, timeZone)
                result.success(eventId)
            }
            "removeEvent" -> {
                val eventId = call.argument<Int>("eventId")
                if (eventId != null) {
                   val isSuccess = removeEvent(eventId)
                    result.success(isSuccess)
                } else {
                    result.error("INVALID_ARGUMENT", "Event ID is null", null)
                }
            }
            else -> result.notImplemented()
        }
    }

    private fun getCalendars(): List<Map<String, Any?>> {
        return try {
            getCalendarsInternal().map { it.toMap() }
        } catch (e: Exception) {
            e.printStackTrace()
            emptyList()
        }
    }

    private fun getCalendarsInternal(): List<CalendarData> {
        val projection = arrayOf(
            CalendarContract.Calendars._ID,
            CalendarContract.Calendars.NAME,
            CalendarContract.Calendars.ACCOUNT_NAME,
            CalendarContract.Calendars.OWNER_ACCOUNT,
            CalendarContract.Calendars.CALENDAR_DISPLAY_NAME,
        )
        val uri = CalendarContract.Calendars.CONTENT_URI
        val cursor = context.contentResolver.query(uri, projection, null, null, null)

        return cursor?.use {
            val idColumn = it.getColumnIndexOrThrow(CalendarContract.Calendars._ID)
            val nameColumn = it.getColumnIndexOrThrow(CalendarContract.Calendars.NAME)
            val accountNameColumn = it.getColumnIndexOrThrow(CalendarContract.Calendars.ACCOUNT_NAME)
            val ownerNameColumn = it.getColumnIndexOrThrow(CalendarContract.Calendars.OWNER_ACCOUNT)
            val displayNameColumn = it.getColumnIndexOrThrow(CalendarContract.Calendars.CALENDAR_DISPLAY_NAME)
            
            generateSequence { if (it.moveToNext()) it else null }
                .map {
                    CalendarData(
                        id = it.getInt(idColumn),
                        name = it.getString(nameColumn),
                        accountName = it.getString(accountNameColumn),
                        ownerName = it.getString(ownerNameColumn),
                        displayName = it.getString(displayNameColumn)
                    )
                }.toList()
        } ?: emptyList()
    }

    private fun addEventToCalendarAndGetId(calendarId: Int?, title: String?, description: String?, location: String?, startTime: Long?, endTime: Long?, timeZone: String?): Long? {
        val cr = context.contentResolver
        val values = ContentValues().apply {
            put(CalendarContract.Events.CALENDAR_ID, calendarId)
            put(CalendarContract.Events.TITLE, title)
            put(CalendarContract.Events.DESCRIPTION, description)
            put(CalendarContract.Events.EVENT_LOCATION, location)
            put(CalendarContract.Events.DTSTART, startTime)
            put(CalendarContract.Events.DTEND, endTime)
            put(CalendarContract.Events.EVENT_TIMEZONE, timeZone)
        }
        val uri: Uri? = cr.insert(CalendarContract.Events.CONTENT_URI, values)
        return uri?.lastPathSegment?.toLong()
    }

    private fun removeEvent(eventId: Int): Boolean {
        val idToLong = eventId.toLong()
        return try {
            val uri: Uri = ContentUris.withAppendedId(CalendarContract.Events.CONTENT_URI, idToLong)
            val rowsDeleted: Int = context.contentResolver.delete(uri, null, null)
            rowsDeleted > 0
        } catch (e: Exception) {
            print(eventId)
            e.printStackTrace()
            false
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}

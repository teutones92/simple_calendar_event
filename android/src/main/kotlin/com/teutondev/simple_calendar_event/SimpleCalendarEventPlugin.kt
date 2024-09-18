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

data class EventData(val id: Int, val title: String, val description: String, val location: String, val startTime: Long, val endTime: Long, val timeZone: String, val calendarId: Int)

fun CalendarData.toMap(): Map<String, Any?> {
    return mapOf(
        "id" to id,
        "name" to name,
        "accountName" to accountName,
        "ownerName" to ownerName,
        "displayName" to displayName
    )
}

fun EventData.toMap(): Map<String, Any?> {
    return mapOf(
        "id" to id,
        "title" to title,
        "description" to description,
        "location" to location,
        "startTime" to startTime,
        "endTime" to endTime,
        "timeZone" to timeZone,
        "calendarId" to calendarId
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
            "getEvents" -> {
                val calendarId = call.argument<Int>("calendarId")
                if (calendarId != null) {
                    val events = getEvents(calendarId)
                    result.success(events)
                } else {
                    result.error("INVALID_ARGUMENT", "Calendar ID is null", null)
                }
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

    private fun getEvents(calendarId: Int): List<Map<String, Any?>> {
        return try {
            getEventsInternal(calendarId).map { it.toMap() }
        } catch (e: Exception) {
            e.printStackTrace()
            emptyList()
        }
    }

    private fun getEventsInternal(calendarId: Int): List<EventData>{
        val projection = arrayOf(
            CalendarContract.Events._ID,
            CalendarContract.Events.TITLE,
            CalendarContract.Events.DESCRIPTION,
            CalendarContract.Events.EVENT_LOCATION,
            CalendarContract.Events.DTSTART,
            CalendarContract.Events.DTEND,
            CalendarContract.Events.EVENT_TIMEZONE,
            CalendarContract.Events.CALENDAR_ID
        )
        val uri = CalendarContract.Events.CONTENT_URI
        val selection = "${CalendarContract.Events.CALENDAR_ID} = ?"
        val selectionArgs = arrayOf(calendarId.toString())
        val cursor = context.contentResolver.query(uri, projection, selection, selectionArgs, null)

        return cursor?.use {
            val idColumn = it.getColumnIndexOrThrow(CalendarContract.Events._ID)
            val titleColumn = it.getColumnIndexOrThrow(CalendarContract.Events.TITLE)
            val descriptionColumn = it.getColumnIndexOrThrow(CalendarContract.Events.DESCRIPTION)
            val locationColumn = it.getColumnIndexOrThrow(CalendarContract.Events.EVENT_LOCATION)
            val startTimeColumn = it.getColumnIndexOrThrow(CalendarContract.Events.DTSTART)
            val endTimeColumn = it.getColumnIndexOrThrow(CalendarContract.Events.DTEND)
            val timeZoneColumn = it.getColumnIndexOrThrow(CalendarContract.Events.EVENT_TIMEZONE)
            val calendarIdColumn = it.getColumnIndexOrThrow(CalendarContract.Events.CALENDAR_ID)

            generateSequence { if (it.moveToNext()) it else null }
                .map {
                    EventData(
                        id = it.getInt(idColumn),
                        title = it.getString(titleColumn),
                        description = it.getString(descriptionColumn),
                        location = it.getString(locationColumn),
                        startTime = it.getLong(startTimeColumn),
                        endTime = it.getLong(endTimeColumn),
                        timeZone = it.getString(timeZoneColumn),
                        calendarId = it.getInt(calendarIdColumn)
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

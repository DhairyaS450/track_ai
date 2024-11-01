import 'dart:developer';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:googleapis_auth/auth_io.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class CalendarService {
  Future<calendar.CalendarApi> _getCalendarApi(
      GoogleSignInAccount googleUser) async {
    final authHeaders = await googleUser.authHeaders;

    final authenticateClient = authenticatedClient(
      http.Client(),
      AccessCredentials(
        AccessToken(
          'Bearer',
          authHeaders['Authorization']!.split(' ')[1],
          DateTime.now().add(const Duration(hours: 1)).toUtc(),
        ),
        null,
        ['https://www.googleapis.com/auth/calendar'],
      ),
    );

    return calendar.CalendarApi(authenticateClient);
  }

  // Fetch all events from Google Calendar
  Future<List<calendar.Event>> getAllEvents(
      GoogleSignInAccount googleUser) async {
    try {
      final calendarApi = await _getCalendarApi(googleUser);

      // Fetch events from the primary calendar
      calendar.Events events = await calendarApi.events.list(
        'primary', // Primary calendar of the user
        maxResults: 1000, // Set a limit if needed
        orderBy: 'startTime',
        singleEvents: true, // Expand recurring events into individual instances
        timeMin: DateTime.now().toUtc(), // Only fetch events from now onward
      );

      // Return the list of events
      return events.items ?? [];
    } catch (e) {
      log("Error fetching events: $e");
      return [];
    }
  }

  // Add Event to Google Calendar
  Future<void> addEventToGoogleCalendar(GoogleSignInAccount googleUser,
      String eventName, DateTime startTime, DateTime endTime) async {
    try {
      final calendarApi = await _getCalendarApi(googleUser);

      calendar.Event event = calendar.Event(
        summary: eventName,
        start: calendar.EventDateTime(
          dateTime: startTime,
          timeZone: "GMT",
        ),
        end: calendar.EventDateTime(
          dateTime: endTime,
          timeZone: "GMT",
        ),
      );

      await calendarApi.events.insert(event, "primary");
      log("Event added to Google Calendar!");
    } catch (e) {
      log("Error adding event: $e");
    }
  }

  // Edit Event in Google Calendar
  Future<void> editEventInGoogleCalendar(
      GoogleSignInAccount googleUser,
      String eventId,
      String newEventName,
      DateTime startTime,
      DateTime endTime) async {
    try {
      final calendarApi = await _getCalendarApi(googleUser);

      calendar.Event updatedEvent = calendar.Event(
        summary: newEventName,
        start: calendar.EventDateTime(
          dateTime: startTime,
          timeZone: "GMT",
        ),
        end: calendar.EventDateTime(
          dateTime: endTime,
          timeZone: "GMT",
        ),
      );

      await calendarApi.events.patch(updatedEvent, "primary", eventId);
      log("Event updated in Google Calendar!");
    } catch (e) {
      log("Error updating event: $e");
    }
  }

  // Delete Event from Google Calendar
  Future<void> deleteEventFromGoogleCalendar(
      GoogleSignInAccount googleUser, String eventId) async {
    try {
      final calendarApi = await _getCalendarApi(googleUser);

      await calendarApi.events.delete("primary", eventId);
      log("Event deleted from Google Calendar!");
    } catch (e) {
      log("Error deleting event: $e");
    }
  }
}

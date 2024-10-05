import 'package:flutter/material.dart';
import 'package:track_ai/views/HomeDashboard.dart';
import 'package:track_ai/views/HomeDashboardNew.dart';
import 'package:track_ai/views/calendar/CalendarView.dart';
import 'package:track_ai/views/chatbot/ChatBotScreen.dart';
import 'package:track_ai/views/login-register/LoginPage.dart';
import 'package:track_ai/views/login-register/RegisterPage.dart';
import 'package:track_ai/views/rating/RatingScreen.dart';
import 'package:track_ai/views/recommendations/RecommendationScreen.dart';
import 'package:track_ai/views/settings_menu/SettingsScreen.dart';
import 'package:track_ai/views/study_sessions/StudySessionPage.dart';
import 'package:track_ai/views/tasks/AddNewTaskScreen.dart';

// Define your route constants
const String loginPageRoute = '/login';
const String registerPageRoute = '/register';
const String homeDashboardNewRoute = '/homeDashboardNew';
const String calendarViewRoute = '/calendarView';
const String chatbotScreenRoute = '/chatbot';
const String ratingScreenRoute = '/rating';
const String recommendationScreenRoute = '/recommendation';
const String settingsScreenRoute = '/settings';
const String studySessionPageRoute = '/studySession';
const String homeDashboardRoute = '/homeDashboard';
const String addNewTaskScreenRoute = '/addNewTask';

class Routes {
  static Map<String, WidgetBuilder> getRoutes(BuildContext context) {
    return {
      loginPageRoute: (context) => const LoginPage(),
      registerPageRoute: (context) => const RegisterPage(),
      homeDashboardNewRoute: (context) => HomeDashboardNew(),
      calendarViewRoute: (context) => const CalendarView(),
      chatbotScreenRoute: (context) => ChatbotScreen(),
      ratingScreenRoute: (context) => const RatingScreen(),
      recommendationScreenRoute: (context) => const RecommendationScreen(),
      settingsScreenRoute: (context) => const SettingsScreen(),
      studySessionPageRoute: (context) => StudySessionPage(),
      addNewTaskScreenRoute: (context) => const AddNewTaskScreen(),
    };
  }
}

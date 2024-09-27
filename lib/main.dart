import 'package:flutter/material.dart';
import 'package:track_ai/theme.dart';
import 'package:track_ai/views/HomeDashboardNew.dart';
import 'package:track_ai/views/calendar/CalendarView.dart';
import 'package:track_ai/views/chatbot/ChatBotScreen.dart';
import 'package:track_ai/views/HomeDashboard.dart';
import 'package:track_ai/views/login-register/AuthPage.dart';
import 'package:track_ai/views/rating/RatingScreen.dart';
import 'package:track_ai/views/recommendations/RecommendationScreen.dart';
import 'package:track_ai/views/settings_menu/SettingsScreen.dart';
import 'package:track_ai/views/study_sessions/StudySessionPage.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Track AI',
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: HomeDashboard(),
    );
  }
}
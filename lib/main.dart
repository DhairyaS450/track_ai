import 'package:flutter/material.dart';
import 'package:track_ai/theme.dart';
import 'package:track_ai/views/CalendarView.dart';
import 'package:track_ai/views/ChatBotScreen.dart';
import 'package:track_ai/views/HomeDashboard.dart';
import 'package:track_ai/views/RatingScreen.dart';
import 'package:track_ai/views/StudySessionPage.dart';

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
      home: RatingScreen(),
    );
  }
}
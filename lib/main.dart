import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:track_ai/constants/routes.dart';
import 'package:track_ai/theme.dart';
import 'package:track_ai/views/HomeDashboard.dart';
import 'package:track_ai/views/HomeDashboardNew.dart';
import 'package:track_ai/views/login-register/LoginPage.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        home: const LoginPage(),
        routes:  Routes.getRoutes(context)
    );
  }
}
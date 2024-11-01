import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:track_ai/constants/routes.dart';
import 'package:track_ai/services/auth/auth_service.dart';
import 'package:track_ai/services/cloud/firestore_database.dart';
import 'package:track_ai/services/google/google_calendar.dart';
import 'package:track_ai/services/google/google_sign_in.dart';
import 'package:track_ai/utilities/dialogs/error_dialog.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FirestoreDatabase _firestoreDatabase = FirestoreDatabase();
  final CalendarService _calendarService = CalendarService();
  final GoogleSignInService _googleSignInService = GoogleSignInService();
  final String uid = AuthService().currentUser!.uid;
  Map<String, dynamic> userData = {};

  // Switch state variables
  bool _studyEventRemindersEnabled = false;
  bool _dailyProgressReportsEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _firestoreDatabase.getUserInfo(uid).then(
          (data) {
            if (data != null) {
              userData = data;

              _studyEventRemindersEnabled =
                  userData['studyEventRemindersEnabled'] ?? false;
              _dailyProgressReportsEnabled =
                  userData['dailyProgressReportsEnabled'] ?? false;
            } else {
              userData = {};
            }
            return userData;
          },
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator()); // Show a loading spinner
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
                child: Text(
                    'No data available')); // Handle the case where no data is found
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section: Personal Information
                _buildSectionHeader('Personal Information'),
                const SizedBox(height: 10),
                _buildTextInputField(
                    'Name', 'name', Icons.person_outline, false),
                const SizedBox(height: 15),
                _buildDropdownInput('Level of Study', 'levelOfStudy',
                    ['High School', 'Undergraduate', 'Graduate']),
                const SizedBox(height: 15),
                _buildTextInputField(
                    'Email', 'email', Icons.email_outlined, false),
                const SizedBox(height: 15),

                // Section: Learning Preferences
                _buildSectionHeader('Learning Preferences'),
                const SizedBox(height: 10),
                _buildDropdownInput('Preferred Learning Style', 'learningStyle',
                    ['Visual', 'Auditory', 'Kinesthetic']),
                const SizedBox(height: 15),
                _buildDropdownInput('Preferred Study Routine', 'studyRoutine',
                    ['Morning', 'Afternoon', 'Evening']),
                const SizedBox(height: 15),

                // Section: Study Goals
                _buildSectionHeader('Study Goals'),
                const SizedBox(height: 10),
                _buildTextInputField('Short-term Goals', 'shortTermGoals',
                    Icons.short_text, false),
                const SizedBox(height: 15),
                _buildTextInputField('Long-term Goals', 'longTermGoals',
                    Icons.assessment_outlined, false),
                const SizedBox(height: 15),

                // Section: Interests
                _buildSectionHeader('Interests'),
                const SizedBox(height: 10),
                _buildTextInputField('Favorite Subjects', 'favoriteSubjects',
                    Icons.interests, false),
                const SizedBox(height: 15),
                _buildTextInputField('Extracurriculars', 'extracurriculars',
                    Icons.sports_basketball_outlined, false),
                const SizedBox(height: 15),

                // Section: Learning Gaps
                _buildSectionHeader('Learning Gaps'),
                const SizedBox(height: 10),
                _buildTextInputField(
                    'Easy For Me', 'strengths', Icons.abc, false),
                const SizedBox(height: 15),
                _buildTextInputField('Difficult For Me', 'weaknesses',
                    Icons.question_mark, false),
                const SizedBox(height: 15),

                // Section: Notifications
                _buildSectionHeader('Notifications'),
                const SizedBox(height: 10),
                // Build switches using state variables
                _buildSwitchInput(
                  'Enable Study + Event Reminders',
                  _studyEventRemindersEnabled,
                  (bool value) {
                      _studyEventRemindersEnabled = value;
                      userData['studyEventRemindersEnabled'] = value;
                  },
                ),
                const SizedBox(height: 15),
                _buildSwitchInput(
                  'Daily Progress Reports',
                  _dailyProgressReportsEnabled,
                  (bool value) {
                      _dailyProgressReportsEnabled = value;
                      userData['dailyProgressReportsEnabled'] = value;
                  },
                ),
                const SizedBox(height: 15),

                //Section: Integrate with other apps
                _buildSectionHeader('Connect With Other Apps'),
                const SizedBox(height: 10),
                // Row with app icons for Google Calendar, Google Classroom, and Todoist
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildAppIconButton(
                        'assets/google_calendar_icon.png', Colors.blueAccent, () async {
                          log('Login button was clicked');
                          try {
                            final user = await _googleSignInService.signInWithGoogle();
                            if (user != null) {
                              log('User with display name ${user.displayName} and email ${user.email} has successfully logged in');
                              final gAccount = await _googleSignInService.getCurrentUser();
                              final calendarEvents = await _calendarService.getAllEvents(gAccount!);
                              log(calendarEvents[0].summary!);
                            } else {
                              log('Failed to login');
                            }
                          } catch (e) {
                            log(e.toString());
                          }
                        }),
                    _buildAppIconButton(
                        'assets/google_classroom_icon.png', Colors.green, () {

                        }),
                    _buildAppIconButton(
                        'assets/todoist_icon.png', Colors.redAccent, () {

                        }),
                  ],
                ),
                const SizedBox(height: 10),

                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      log(userData.toString());
                      _firestoreDatabase.updateUserInfo(uid, userData);
                      Navigator.of(context).pushNamedAndRemoveUntil(homeDashboardNewRoute, (route) => false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Save Settings'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Section Header Widget
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.blueAccent,
      ),
    );
  }

  // Text Input Field with Icon
  Widget _buildTextInputField(
      String hint, String databaseValue, IconData icon, bool isPassword) {
    String defaultValue = '';
    if (userData.containsKey(databaseValue)) {
      defaultValue = userData[databaseValue];
    } else {
      userData[databaseValue] = "";
    }
    TextEditingController controller =
        TextEditingController(text: defaultValue);

    return TextField(
        controller: controller,
        obscureText: isPassword, // Hide text for password fields
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (String value) {
          userData[databaseValue] = value;
          log(userData[databaseValue]);
        });
  }

  // Dropdown Input Widget
  Widget _buildDropdownInput(
      String label, String databaseValue, List<String> options) {
    String? selectedOption;
    if (userData.containsKey(databaseValue)) {
      selectedOption = userData[databaseValue];
    }
    return DropdownButtonFormField<String>(
      value: selectedOption,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
      items: options.map((String option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
      onChanged: (value) {
        selectedOption = value;
        if (value != null) {
          userData[databaseValue] = selectedOption;
        }
        log(userData[databaseValue]);
      },
    );
  }

  // Switch Input Widget
  Widget _buildSwitchInput(
      String label, bool switchValue, ValueChanged<bool> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        Switch(
          value: switchValue, // Controlled by state variable
          onChanged:
              onChanged, // Pass the toggle logic through the onChanged callback
          activeColor: Colors.blueAccent,
        ),
      ],
    );
  }

// Helper function to create app icon buttons
  Widget _buildAppIconButton(String assetPath, Color color, onPressed) {
    return Column(
      children: [
        // App icon inside a circular container
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1), // Subtle background for icon
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Image.asset(
              assetPath,
              height: 50,
              width: 50,
            ),
            onPressed: onPressed
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

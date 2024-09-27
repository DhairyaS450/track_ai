import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section: Personal Information
            _buildSectionHeader('Personal Information'),
            const SizedBox(height: 10),
            _buildTextInputField('Name', Icons.person_outline, false),
            const SizedBox(height: 15),
            _buildDropdownInput(
                'Level of Study', ['High School', 'Undergraduate', 'Graduate']),
            const SizedBox(height: 15),
            _buildTextInputField('Email', Icons.email_outlined, false),
            const SizedBox(height: 15),

            // Section: Learning Preferences
            _buildSectionHeader('Learning Preferences'),
            const SizedBox(height: 10),
            _buildDropdownInput('Preferred Learning Style',
                ['Visual', 'Auditory', 'Kinesthetic']),
            const SizedBox(height: 15),
            _buildDropdownInput(
                'Preferred Study Routine', ['Morning', 'Afternoon', 'Evening']),
            const SizedBox(height: 15),

            // Section: Study Goals
            _buildSectionHeader('Study Goals'),
            const SizedBox(height: 10),
            _buildTextInputField('Short-term Goals', Icons.short_text, false),
            const SizedBox(height: 15),
            _buildTextInputField(
                'Long-term Goals', Icons.assessment_outlined, false),
            const SizedBox(height: 15),

            // Section: Interests
            _buildSectionHeader('Interests'),
            const SizedBox(height: 10),
            _buildTextInputField('Favorite Subjects', Icons.interests, false),
            const SizedBox(height: 15),
            _buildTextInputField(
                'Extracurriculars', Icons.sports_basketball_outlined, false),
            const SizedBox(height: 15),

            // Section: Learning Gaps
            _buildSectionHeader('Learning Gaps'),
            const SizedBox(height: 10),
            _buildTextInputField('Easy For Me', Icons.abc, false),
            const SizedBox(height: 15),
            _buildTextInputField(
                'Difficult For Me', Icons.question_mark, false),
            const SizedBox(height: 15),

            // Section: Notifications
            _buildSectionHeader('Notifications'),
            const SizedBox(height: 10),
            _buildSwitchInput('Enable Study + Event Reminders'),
            _buildSwitchInput('Daily Progress Reports'),
            const SizedBox(height: 15),

            //Section: Integrate with other apps
            _buildSectionHeader('Connect With Other Apps'),
            const SizedBox(height: 10),
            // Row with app icons for Google Calendar, Google Classroom, and Todoist
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAppIconButton(
                    'assets/google_calendar_icon.png', Colors.blueAccent),
                _buildAppIconButton(
                    'assets/google_classroom_icon.png', Colors.green),
                _buildAppIconButton(
                    'assets/todoist_icon.png', Colors.redAccent),
              ],
            ),
            const SizedBox(height: 10),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Save settings logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Save Settings'),
              ),
            ),
          ],
        ),
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
  Widget _buildTextInputField(String hint, IconData icon, bool isPassword) {
    return TextField(
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
    );
  }

  // Dropdown Input Widget
  Widget _buildDropdownInput(String label, List<String> options) {
    String? selectedOption;
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
      },
    );
  }

  // Switch Input Widget
  Widget _buildSwitchInput(String label) {
    bool switchValue = false; // Initial value for switch
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        Switch(
          value: switchValue,
          onChanged: (bool value) {
            // Handle switch toggle
            switchValue = value;
          },
          activeColor: Colors.blueAccent,
        ),
      ],
    );
  }
}

// Helper function to create app icon buttons
Widget _buildAppIconButton(String assetPath, Color color) {
  return Column(
    children: [
      // App icon inside a circular container
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1), // Subtle background for icon
          shape: BoxShape.circle,
        ),
        child: Image.asset(
          assetPath,
          height: 50,
          width: 50,
        ),
      ),
      const SizedBox(height: 10),
    ],
  );
}
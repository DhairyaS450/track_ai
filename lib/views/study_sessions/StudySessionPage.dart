import 'package:flutter/material.dart';

class StudySessionPage extends StatelessWidget {
  const StudySessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI-Recommended Study Session'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Session Overview with Edit Button
            _buildSectionCard(
              title: 'Session Overview',
              content: const Text(
                  'Your math exam is tomorrow, and Track AI has generated a customized study session using the Pomodoro Technique. This method helps maximize focus and retention.'),
              buttonText: 'Edit Technique',
              icon: Icons.edit,
              onPressed: () {
                // Edit Technique logic here
              },
            ),
            const SizedBox(height: 10),
            // Add time of study session at the top with a reschedule button
            _buildSectionCard(
                title: 'Time',
                content: const Text(
                    'The study session is scheduled for 6PM to 8PM tommorow'),
                buttonText: 'Edit Time',
                icon: Icons.access_time,
                onPressed: () {}),
            const SizedBox(height: 10),

            // Pomodoro Technique Overview with Edit Button
            _buildSectionCard(
              title: 'Recommended Technique: Pomodoro',
              content: const Text(
                  '• Study in 25-minute intervals, followed by 5-minute breaks.\n• After 4 intervals (Pomodoros), take a longer 15-minute break.'),
              buttonText: 'Edit Breaks',
              icon: Icons.edit,
              onPressed: () {
                // Edit Break logic here
              },
            ),
            const SizedBox(height: 20),

            // Study Session Breakdown with Edit Button
            _buildSectionCard(
              title: 'Study Session Plan',
              content: _buildPomodoroSchedule(),
              buttonText: 'Edit Topics',
              icon: Icons.edit,
              onPressed: () {
                // Edit Topics logic here
              },
            ),
            const SizedBox(height: 20),

            // Notification Selector Dropdown
            _buildNotificationDropdown(),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Logic to start the study session
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15), // Padding for a larger button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Rounded corners
                ),
                elevation: 5, // Shadow effect
              ),
              child: const Text(
                'Start Study Session',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Section Card with Title, Content, and Edit Button
  Widget _buildSectionCard({
    required String title,
    required Widget content, // Change from String to Widget
    required String buttonText,
    required IconData icon,
    required Function() onPressed,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            content, // This can now accept Widgets like _buildPomodoroSchedule()
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onPressed,
                icon: Icon(icon),
                label: Text(
                  buttonText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Pomodoro Schedule Breakdown
  Widget _buildPomodoroSchedule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPomodoroItem('Pomodoro 1',
            '25 minutes of studying algebra equations', '5-minute break'),
        _buildPomodoroItem(
            'Pomodoro 2', '25 minutes of geometry problems', '5-minute break'),
        _buildPomodoroItem('Pomodoro 3', '25 minutes of trigonometry practice',
            '5-minute break'),
        _buildPomodoroItem('Pomodoro 4',
            '25 minutes of probability & statistics', '15-minute break'),
      ],
    );
  }

  // Individual Pomodoro Item
  Widget _buildPomodoroItem(
      String title, String studyDescription, String breakDescription) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text('• $studyDescription'),
        Text('• $breakDescription',
            style: const TextStyle(color: Colors.green)),
        const SizedBox(height: 15),
      ],
    );
  }

  // Notification Dropdown Menu
  Widget _buildNotificationDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Notify me about this session:',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            filled: true,
            fillColor: Colors.grey[100],
          ),
          items: const [
            DropdownMenuItem(
                value: '5 minutes before', child: Text('5 minutes before')),
            DropdownMenuItem(
                value: '10 minutes before', child: Text('10 minutes before')),
            DropdownMenuItem(
                value: '30 minutes before', child: Text('30 minutes before')),
          ],
          onChanged: (value) {
            // Handle notification selection logic
          },
          hint: const Text('Select notification time'),
        ),
      ],
    );
  }

  // Button to Change Study Session Time
  Widget _buildTimeChangeButton(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Time',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () {
            // Handle time change logic here
          },
          icon: const Icon(Icons.access_time),
          label: const Text('Change Time'),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ],
    );
  }
}

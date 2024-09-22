import 'package:flutter/material.dart';

class RecommendationScreen extends StatelessWidget {
  const RecommendationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI-Recommended Resource For You'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Recommended Resource Card
            _buildResourceCard(
              resourceTitle: 'Trigonometry Practice Set',
              description:
                  'This set includes 20 questions on trigonometric identities and functions, tailored to your recent struggles in trigonometry.',
              subject: 'Mathematics - Trigonometry',
            ),
            const SizedBox(height: 20),

            // Options Section
            const Text(
              'What would you like to do?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Add to Study Session Option
            _buildOptionButton(
              context,
              'Add to Study Session',
              Icons.playlist_add,
              Colors.green,
              () {
                // Add to Study Session logic
              },
            ),
            const SizedBox(height: 10),

            // Create Task to Complete Option
            _buildOptionButton(
              context,
              'Create a Task to Complete',
              Icons.check_circle_outline,
              Colors.orange,
              () {
                // Create Task logic
              },
            ),
            const SizedBox(height: 10),

            // Ask for Different Resource Option
            _buildOptionButton(
              context,
              'Ask AI for a Different Resource',
              Icons.autorenew,
              Colors.deepPurpleAccent,
              () {
                // Ask AI for a different resource logic
              },
            ),
            const SizedBox(height: 10),

            // Input Your Own Resource Option
            _buildOptionButton(
              context,
              'Add Your Own Resource',
              Icons.upload_file,
              Colors.blue,
              () {
                // Upload custom resource logic
              },
            ),
            const SizedBox(height: 20),

            // Footer Explanation
            Center(
              child: Text(
                'These resources are personalized to help you with areas where you need the most improvement!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Resource Card Widget
  Widget _buildResourceCard({
    required String resourceTitle,
    required String description,
    required String subject,
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
              resourceTitle,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              subject,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.blueAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Option Button Widget
  Widget _buildOptionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    Function() onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(
        label,
        style: const TextStyle(fontSize: 16),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}

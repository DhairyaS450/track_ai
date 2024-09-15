import 'package:flutter/material.dart';

class RatingScreen extends StatelessWidget {
  const RatingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rate Your Study Session'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'How was your study session?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Session Breakdown Section
            const Text(
              'Rate each concept:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            _buildRatingRow('Trigonometry'),
            _buildRatingRow('Geometry'),
            _buildRatingRow('Algebra'),
            _buildRatingRow('Probability & Statistics'),
            const SizedBox(height: 20),

            // Overall Session Rating
            const Text(
              'How do you feel about the overall study session?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildOverallSessionRating(),
            const SizedBox(height: 20),

            // Improvement Feedback
            const Text(
              'What could have been improved?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildTextInputField('Enter your feedback...'),
            const SizedBox(height: 20),

            // Resource Helpfulness Feedback
            const Text(
              'Did you find the provided resources helpful?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildYesNoSelector(),

            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Submit feedback logic
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Submit Feedback'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to build rating row for each concept
  Widget _buildRatingRow(String concept) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          concept,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const Row(
          children: [
            Icon(Icons.star_border, color: Colors.green,),
            Icon(Icons.star_border, color: Colors.green,),
            Icon(Icons.star_border, color: Colors.green,),
            Icon(Icons.star_border, color: Colors.green,),
            Icon(Icons.star_border, color: Colors.green,),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  // Widget to build overall session rating (1-5)
  Widget _buildOverallSessionRating() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.star_border, size: 40, color: Colors.green),
        Icon(Icons.star_border, size: 40, color: Colors.green),
        Icon(Icons.star_border, size: 40, color: Colors.green),
        Icon(Icons.star_border, size: 40, color: Colors.green),
        Icon(Icons.star_border, size: 40, color: Colors.green),
      ],
    );
  }

  // Widget to build text input field for feedback
  Widget _buildTextInputField(String hint) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      maxLines: 3,
    );
  }

  // Widget to build Yes/No selector for resource helpfulness
  Widget _buildYesNoSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            // Yes logic
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: const Text('Yes'),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: () {
            // No logic
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: const Text('No'),
        ),
      ],
    );
  }
}

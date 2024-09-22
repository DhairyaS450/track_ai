import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true; // Toggle between login and register

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? 'Login' : 'Register'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Toggle between Login and Register
            Center(
              child: Text(
                isLogin ? 'Login to your account' : 'Create a new account',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurpleAccent,
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Show either the Login form or the Register form
            isLogin ? _buildLoginForm() : _buildRegisterForm(),
            
            const SizedBox(height: 20),
            
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Perform login or register action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(isLogin ? 'Login' : 'Register'),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Toggle between Login and Register
            Center(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    isLogin = !isLogin; // Toggle form
                  });
                },
                child: Text(
                  isLogin ? "Don't have an account? Register" : 'Already have an account? Login',
                  style: const TextStyle(color: Colors.deepPurpleAccent),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Login Form
  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextInputField('Email', Icons.email_outlined, false),
        const SizedBox(height: 15),
        _buildTextInputField('Password', Icons.lock_outline, true),
      ],
    );
  }

  // Register Form
  Widget _buildRegisterForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextInputField('Name', Icons.person_outline, false),
        const SizedBox(height: 15),
        _buildTextInputField('Email', Icons.email_outlined, false),
        const SizedBox(height: 15),
        _buildTextInputField('Password', Icons.lock_outline, true),
        const SizedBox(height: 15),
        _buildTextInputField('Confirm Password', Icons.lock_outline, true),
        const SizedBox(height: 15),
        _buildDropdownInput('Level of Study'),
      ],
    );
  }

  // Text Input Field with Icon
  Widget _buildTextInputField(String hint, IconData icon, bool isPassword) {
    return TextField(
      obscureText: isPassword, // Hide text for password fields
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.deepPurpleAccent),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // Dropdown for Level of Study
  Widget _buildDropdownInput(String label) {
    String? selectedLevel;
    List<String> levels = ['High School', 'Undergraduate', 'Graduate'];
    return DropdownButtonFormField<String>(
      value: selectedLevel,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
      items: levels.map((String level) {
        return DropdownMenuItem<String>(
          value: level,
          child: Text(level),
        );
      }).toList(),
      onChanged: (value) {
        selectedLevel = value;
      },
    );
  }
}

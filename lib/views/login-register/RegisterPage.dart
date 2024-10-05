import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:track_ai/constants/routes.dart';
import 'package:track_ai/services/auth/auth_service.dart';
import 'package:track_ai/utilities/dialogs/error_dialog.dart';
import 'package:track_ai/views/login-register/LoginPage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final AuthService _authService = AuthService();

  String _selectedLevel = 'High School'; // Default selected value

  // Dispose controllers when not needed
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Name or Logo
                const Center(
                  child: Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Input field for Name
                _buildTextInputField('Name', Icons.person_outline, false, _nameController),
                const SizedBox(height: 20),
                // Input field for Email
                _buildTextInputField('Email', Icons.email_outlined, false, _emailController),
                const SizedBox(height: 20),
                // Input field for Password
                _buildTextInputField('Password', Icons.lock_outline, true, _passwordController),
                const SizedBox(height: 20),
                // Input field for Confirm Password
                _buildTextInputField('Confirm Password', Icons.lock_outline, true, _confirmPasswordController),
                const SizedBox(height: 20),
                // Dropdown for Level of Study
                _buildDropdownInput('Level of Study', [
                  'High School',
                  'Undergraduate',
                  'Graduate',
                ]),
                const SizedBox(height: 30),
                // Register Button
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      final name = _nameController.text;
                      final email = _emailController.text;
                      final password = _passwordController.text;
                      final confirmPassword = _confirmPasswordController.text;
                      final levelOfStudy = _selectedLevel;

                      // //temporary test firestore database
                      // FirestoreDatabase().testFirestore();

                      if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty && confirmPassword.isNotEmpty && levelOfStudy.isNotEmpty) {
                        if (password == confirmPassword) {
                          try {
                            await _authService.signUp(email: email, password: password, name: name, levelOfStudy: levelOfStudy);
                            final user = _authService.currentUser;
                            if (user != null) {
                              Navigator.of(context).pushNamedAndRemoveUntil(homeDashboardNewRoute, (context) => false);
                            }
                          } catch (e){
                            await showErrorDialog(context, e.toString());
                          }
                        } else {
                          await showErrorDialog(context, 'Passwords do not match.');
                        }
                      } else {
                        await showErrorDialog(context, 'All fields must not be empty.');
                      }
                      //TODO: Save info on cloud firestore
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Register Page with navigation to Login Page
                Center(
                  child: TextButton(
                    onPressed: () {
                      // Navigate to Login Page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    },
                    child: const Text(
                      "Already have an account? Click here to login!",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Text Input Field with Icon
  Widget _buildTextInputField(String hint, IconData icon, bool isPassword, TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: isPassword, // Hides text if password field
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
    return DropdownButtonFormField<String>(
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
        _selectedLevel = value!;
        log(value);
      },
    );
  }
}

import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:track_ai/constants/routes.dart';
import 'package:track_ai/services/auth/auth_service.dart';
import 'package:track_ai/utilities/dialogs/error_dialog.dart';
import 'package:track_ai/views/login-register/RegisterPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
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
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Input field for Name
                _buildTextInputField('Email', Icons.person_outline, false, _emailController),
                const SizedBox(height: 20),
                // Input field for Email
                _buildTextInputField('Password', Icons.email_outlined, true, _passwordController),
                const SizedBox(height: 30),
                // Login Button
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      final email = _emailController.text;
                      final password = _passwordController.text;
                      log('$email, $password');
                      if (email.isNotEmpty && password.isNotEmpty) {
                        try {
                          await _authService.signIn(email, password);
                          final user = _authService.currentUser;
                          if (user != null){
                            //Navigate to home dashboard
                            Navigator.of(context).pushNamedAndRemoveUntil(homeDashboardNewRoute, (route) => false);
                          }
                        } on FirebaseAuthException {
                          await showErrorDialog(context, 'Invalid credentials entered.');
                        } catch (e) {
                          await showErrorDialog(context, 'Something went wrong, please try again.');
                        }
                      } else {
                        await showErrorDialog(context, 'All fields must not be empty.');
                      }
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
                      'Login',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Login Page with navigation to Register Page
                Center(
                  child: TextButton(
                    onPressed: () {
                      // Navigate to Register Page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterPage()),
                      );
                    },
                    child: const Text(
                      "Don't have an account? Click here to register!",
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
}

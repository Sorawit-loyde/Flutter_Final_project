import 'package:flutter/material.dart';
import 'package:mobile_app_decubitus/constant.dart';

class CreateAccountPage extends StatelessWidget {
  CreateAccountPage({super.key});

  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor1,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start, // Align to the top
              children: [
                _buildTitle(),
                const SizedBox(height: 8), // Space between title and subtitle
                _buildSubtitle(), // Add subtitle here
                const SizedBox(height: 60),
                _buildTextField(label: 'Name', controller: _nameController),
                const SizedBox(height: 16),
                _buildTextField(label: 'Email', controller: _emailController),
                const SizedBox(height: 16),
                _buildTextField(
                    label: 'Password',
                    controller: _passwordController,
                    obscureText: true),
                const SizedBox(height: 16),
                _buildTextField(
                    label: 'Confirm Password',
                    controller: _confirmPasswordController,
                    obscureText: true),
                const SizedBox(height: 20),
                _buildCreateAccountButton(context),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Method to build the title
  Widget _buildTitle() {
    return const Text(
      'Create Account',
      style: TextStyle(
        fontSize: 36, // Increased font size
        fontWeight: FontWeight.w900, // Bolder text
        color: primaryColor, // Changed color to primaryColor
      ),
      textAlign: TextAlign.center,
    );
  }

  // Method to build the subtitle
  Widget _buildSubtitle() {
    return const Text(
      'Please fill in the details below to create your account.',
      style: TextStyle(
        fontSize: 16, // Smaller font size for subtitle
        color: Colors.black, // Black color for subtitle
      ),
      textAlign: TextAlign.center,
    );
  }

  // Method to build styled text fields
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool obscureText = false,
  }) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: secondaryColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: secondaryColor),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: primaryColor),
        ),
        contentPadding: const EdgeInsets.all(15),
      ),
      controller: controller,
      obscureText: obscureText,
    );
  }

  // Method to validate input fields
  bool _validateInputs(BuildContext context) {
    final String name = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String confirmPassword = _confirmPasswordController.text.trim();

    if (name.isEmpty) {
      _showSnackBar(context, 'Name cannot be empty');
      return false;
    }
    if (email.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      _showSnackBar(context, 'Please enter a valid email');
      return false;
    }
    if (password.isEmpty || password.length < 6) {
      _showSnackBar(context, 'Password must be at least 6 characters');
      return false;
    }
    if (password != confirmPassword) {
      _showSnackBar(context, 'Passwords do not match');
      return false;
    }
    return true;
  }

  // Method to show SnackBar for feedback
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Method to build the Create Account button
  Widget _buildCreateAccountButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (_validateInputs(context)) {
          _showSnackBar(context, 'Account Created!');
          // Optionally navigate to another page
          // Navigator.pushNamed(context, '/next-page');
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 140, vertical: 15),
        textStyle: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: const Text(
        'Sign up',
        style: TextStyle(color: backGroundColor1),
      ),
    );
  }
}

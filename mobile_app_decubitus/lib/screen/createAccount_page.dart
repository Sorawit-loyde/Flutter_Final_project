import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:mobile_app_decubitus/constant.dart';

class CreateAccountPage extends StatelessWidget {
  CreateAccountPage({super.key});

  // Controllers for text fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Additional controllers for new fields
  final TextEditingController _ssidController = TextEditingController();
  final TextEditingController _sexController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // New controller for Date of Birth
  final TextEditingController _dobController = TextEditingController();

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
                const SizedBox(height: 40),
                _buildTitle(),
                const SizedBox(height: 8),
                _buildSubtitle(),
                const SizedBox(height: 25),
                _buildTextField(
                    label: 'SSN ID',
                    controller: _ssidController), // SSN ID field
                const SizedBox(height: 16),
                _buildTextField(
                    label: 'First Name', controller: _firstNameController),
                const SizedBox(height: 16),
                _buildTextField(
                    label: 'Last Name', controller: _lastNameController),
                const SizedBox(height: 16),
                _buildTextField(
                    label: 'Sex', controller: _sexController), // Sex field
                const SizedBox(height: 16),
                _buildTextField(
                    label: 'Phone',
                    controller: _phoneController), // Phone field
                const SizedBox(height: 16),
                // New field for Date of Birth with GestureDetector
                _buildDateOfBirthField(context),
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
        fontSize: 40,
        fontWeight: FontWeight.w900,
        color: primaryColor,
      ),
      textAlign: TextAlign.center,
    );
  }

  // Method to build the subtitle
  Widget _buildSubtitle() {
    return const Text(
      'Please fill in the details below to create your account.',
      style: TextStyle(
        fontSize: 20,
        color: Colors.black,
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
          borderSide: const BorderSide(color: secondaryColor),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: primaryColor),
        ),
        contentPadding: const EdgeInsets.all(15),
      ),
      controller: controller,
      obscureText: obscureText,
    );
  }

  // Method to build Date of Birth field with a date picker
  Widget _buildDateOfBirthField(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context), // Show date picker on tap
      child: AbsorbPointer(
        // Prevent keyboard from appearing
        child: TextField(
          controller: _dobController,
          decoration: InputDecoration(
            labelText: 'Date of Birth (YYYY-MM-DD)',
            filled: true,
            fillColor: secondaryColor,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: secondaryColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: primaryColor),
            ),
            contentPadding: const EdgeInsets.all(15),
          ),
        ),
      ),
    );
  }

  // Method to show date picker and update the DOB field
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      // Format and set the selected date in YYYY-MM-DD format
      String formattedDate = "${picked.toLocal()}".split(' ')[0];
      _dobController.text = formattedDate;
    }
  }

  // Method to validate input fields
  bool _validateInputs(BuildContext context) {
    final String firstName = _firstNameController.text.trim();
    final String lastName = _lastNameController.text.trim();
    final String password = _passwordController.text.trim();
    final String confirmPassword = _confirmPasswordController.text.trim();

    if (firstName.isEmpty) {
      _showSnackBar(context, 'First Name cannot be empty');
      return false;
    }
    if (lastName.isEmpty) {
      _showSnackBar(context, 'Last Name cannot be empty');
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

  // Modified method to build the Create Account button
  Widget _buildCreateAccountButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (_validateInputs(context)) {
          try {
            AuthService authService = AuthService();
            await authService.register(
              firstName: _firstNameController.text.trim(),
              lastName: _lastNameController.text.trim(),
              password: _passwordController.text.trim(),
              ssnId: int.parse(
                  _ssidController.text.trim()), // Convert SSN ID to int
              sex: _sexController.text.trim(),
              phone: int.parse(
                  _phoneController.text.trim()), // Convert phone number to int
              dateOfBirth: _dobController.text
                  .trim(), // Get Date of Birth from new field
              profileImage:
                  '', // Optional image URL or leave it empty if not needed
              roleId: 1, // Assign a default role ID or adjust as necessary
            );
            _showSnackBar(context, 'Account Created!');
            Navigator.pushNamed(
                context, '/login'); // Navigate after successful registration
          } catch (e) {
            _showSnackBar(context, e.toString());
          }
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
      child: const Text('Sign up', style: TextStyle(color: backGroundColor1)),
    );
  }
}

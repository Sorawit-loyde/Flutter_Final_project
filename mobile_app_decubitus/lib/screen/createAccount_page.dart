import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:mobile_app_decubitus/constant.dart';

class CreateAccountPage extends StatefulWidget {
  CreateAccountPage({super.key});

  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _ssidController = TextEditingController();
  final TextEditingController _sexController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  String? selectedGender; // Variable to hold selected gender

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor1,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey, // Use Form widget
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    _buildTitle(),
                    const SizedBox(height: 8),
                    _buildSubtitle(),
                    const SizedBox(height: 25),
                    _buildTextField(
                        label: 'SSN ID', controller: _ssidController),
                    const SizedBox(height: 16),
                    _buildTextField(
                        label: 'First Name', controller: _firstNameController),
                    const SizedBox(height: 16),
                    _buildTextField(
                        label: 'Last Name', controller: _lastNameController),
                    const SizedBox(height: 16),
                    _buildGenderSelection(), // Add gender selection here
                    const SizedBox(height: 16),
                    _buildTextField(
                        label: 'Phone', controller: _phoneController),
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 30),
                  ],
                ),
              ),
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

  // Method to build Gender Selection
  Widget _buildGenderSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedGender = "Male"; // Set selected gender
                _sexController.text = selectedGender!; // Update controller
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                  vertical: 15.0), // Add padding for better touch area
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: selectedGender == "Male"
                      ? tertiaryColor
                      : secondaryColor, // Change to red if selected
                  border: Border.all(
                      color: selectedGender == "Male"
                          ? primaryColor
                          : secondaryColor)),
              child: Center(
                  child: Text('Male',
                      style: TextStyle(
                          color: selectedGender == "Male"
                              ? Colors.black
                              : Colors.black))),
            ),
          ),
        ),
        const SizedBox(width: 10), // Space between buttons
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedGender = "Female"; // Set selected gender
                _sexController.text = selectedGender!; // Update controller
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                  vertical: 15.0), // Add padding for better touch area
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: selectedGender == "Female"
                      ? tertiaryColor
                      : secondaryColor, // Change to red if selected
                  border: Border.all(
                      color: selectedGender == "Female"
                          ? primaryColor
                          : secondaryColor)),
              child: Center(
                  child: Text('Female',
                      style: TextStyle(
                          color: selectedGender == "Female"
                              ? Colors.black
                              : Colors.black))),
            ),
          ),
        ),
      ],
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
              borderSide: const BorderSide(
                  color: primaryColor), // Change color here if needed
            ),
            contentPadding:
                const EdgeInsets.all(15), // Adjust padding as necessary
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
      String formattedDate = "${picked.toLocal()}".split(' ')[0];
      _dobController.text = formattedDate;
    }
  }

  // Method to validate input fields (if needed)
  bool _validateInputs(BuildContext context) {
    final String firstName = _firstNameController.text.trim();
    final String lastName = _lastNameController.text.trim();
    final String password = _passwordController.text.trim();
    final String confirmPassword = _confirmPasswordController.text.trim();

    final String ssid = _ssidController.text.trim();
    final String phone = _phoneController.text.trim();

    if (ssid.isEmpty) {
      _showSnackBar(context, 'SSID cannot be empty');
      return false;
    }

    if (firstName.isEmpty) {
      _showSnackBar(context, 'First Name cannot be empty');
      return false;
    }

    if (lastName.isEmpty) {
      _showSnackBar(context, 'Last Name cannot be empty');
      return false;
    }

    if (phone.isEmpty || phone.length < 5) {
      // Assuming phone should be at least10 digits
      _showSnackBar(context, 'Phone number must be at least10 digits');
      return false;
    }

    if (_dobController.text.isEmpty) {
      _showSnackBar(context, 'Date of Birth cannot be empty');
      return false;
    }

    if (password.isEmpty || password.length < 6) {
      _showSnackBar(context, 'Password must be at least6 characters');
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
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
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
              ssnId: int.parse(_ssidController.text.trim()),
              sex: _sexController.text.trim(),
              phone: int.parse(_phoneController.text.trim()),
              dateOfBirth: _dobController.text.trim(),
              profileImage: '',
              roleId: 1,
            );
            _showSnackBar(context, 'Account Created!');
            Navigator.pushNamed(context, '/login');
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

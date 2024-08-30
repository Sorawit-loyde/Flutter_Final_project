import 'package:flutter/material.dart';
import 'package:mobile_app_decubitus/constant.dart'; // Updated import path

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _password;
  String? _errorMessage;
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.start, // Align items to the top
                children: [
                  const SizedBox(height: 30), // Space at the top
                  _buildTitle(),
                  const SizedBox(
                      height: 10), // Space between title and welcome message
                  _buildWelcomeMessage(),
                  const SizedBox(
                      height: 30), // Space between welcome message and image
                  _buildImage(), // Added image here
                  const SizedBox(
                      height: 30), // Space between image and email field
                  _buildEmailField(),
                  const SizedBox(height: 20),
                  _buildPasswordField(),
                  const SizedBox(height: 10),
                  _buildForgotPasswordButton(),
                  const SizedBox(height: 10),
                  _buildSignInButton(),
                  const SizedBox(height: 20),
                  _buildCreateAccountButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Login here',
      style: TextStyle(
        fontSize: 35, // Increased size
        fontWeight: FontWeight.w900, // Made title bolder
        color: primaryColor, // Set to primary color
      ),
      textAlign: TextAlign.center, // Center the title
    );
  }

  Widget _buildWelcomeMessage() {
    return const Text(
      'Welcome back! Please sign in to continue.',
      style: TextStyle(
        fontSize: 22, // Size for the welcome message
        fontWeight: FontWeight.bold, // Make it bold
        color: Colors.black, // Changed color back to black
      ),
      textAlign: TextAlign.center, // Center the welcome message
    );
  }

  Widget _buildImage() {
    return Image.asset(
      logoImage, // Replace with your image path
      width: 200,
      height: 200,
      fit: BoxFit.cover, // Adjust the image to cover the area
    );
  }

  Widget _buildEmailField() {
    return Container(
      height: 60,
      width: 350,
      decoration: BoxDecoration(
        color: secondaryColor, // Set the background color to secondaryColor
        borderRadius: BorderRadius.circular(10), // Rounded corners
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4), // Shadow position
          ),
        ],
      ),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Email',
          border: InputBorder.none, // No border
          contentPadding: const EdgeInsets.all(15),
          errorText: _errorMessage != null && _errorMessage!.contains('email')
              ? _errorMessage
              : null, // Show error message if applicable
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your email';
          }
          if (!value.contains('@')) {
            return 'Please enter a valid email';
          }
          return null;
        },
        onSaved: (value) => _email = value,
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      height: 60,
      width: 350,
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Password',
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(15),
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible; // Toggle visibility
              });
            },
          ),
        ),
        obscureText: !_isPasswordVisible, // Toggle the obscureText property
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          }
          return null;
        },
        onSaved: (value) => _password = value,
      ),
    );
  }

  Widget _buildForgotPasswordButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          // Handle forgot password logic
        },
        child: const Text(
          'Forgot your password?',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildSignInButton() {
    return ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            // Perform login logic here
            if (_email == '@admin' && _password == 'admin') {
              Navigator.pushNamed(context, '/home');
            } else {
              setState(() {
                _errorMessage =
                    'Invalid email or password'; // Set error message
              });
            }
          }
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 137, vertical: 15),
            textStyle: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0))),
        child: const Text(
          'Sign in',
          style: TextStyle(color: backGroundColor),
        ));
  }

  Widget _buildCreateAccountButton(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create-account');
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 65, vertical: 15),
            textStyle: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0))),
        child: const Text(
          'Create new account',
          style: TextStyle(color: backGroundColor),
        ));
  }
}

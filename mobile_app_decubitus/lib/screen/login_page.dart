import 'package:flutter/material.dart';
import 'package:mobile_app_decubitus/constant.dart';

import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

//Controller and Key for auth
class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _ssidController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _errorMessage;
  String _ssid = '';
  String _password = '';
  bool _obscureText = true;

  //Manage Content
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backGroundColor1,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    _buildTitle(),
                    const SizedBox(height: 10),
                    _buildWelcomeMessage(),
                    const SizedBox(height: 30),
                    _buildImage(),
                    const SizedBox(height: 30),
                    _buildSsidField(),
                    const SizedBox(height: 20),
                    _buildPasswordField(),
                    const SizedBox(height: 10),
                    _buildForgotPasswordButton(),
                    const SizedBox(height: 10),
                    _buildSignInButton(),
                    const SizedBox(height: 20),
                    _buildCreateAccountButton(context),
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //Title
  Widget _buildTitle() {
    return const Text(
      'Login here',
      style: TextStyle(
        fontSize: 35,
        fontWeight: FontWeight.w900,
        color: primaryColor,
      ),
      textAlign: TextAlign.center,
    );
  }

  //Sub Title
  Widget _buildWelcomeMessage() {
    return const Text(
      'Welcome back! Please sign in to continue.',
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      textAlign: TextAlign.center,
    );
  }

  //Logo img
  Widget _buildImage() {
    return Image.asset(
      logoImage, //img path
      width: 200,
      height: 200,
      fit: BoxFit.cover,
    );
  }

  //SSID Field
  Widget _buildSsidField() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'SSID',
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
            borderSide: const BorderSide(color: primaryColor)),
        contentPadding: const EdgeInsets.all(15),
      ),
      controller: _ssidController, // Updated controller
      onChanged: (value) {
        _ssid = value; // Updated variable
      },
    );
  }

  //Password Field
  Widget _buildPasswordField() {
    return TextField(
      obscureText: _obscureText, //Hide Password
      decoration: InputDecoration(
        labelText: 'Password',
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
            borderSide: const BorderSide(color: primaryColor)),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: primaryColor,
          ),
        ),
        contentPadding: const EdgeInsets.all(15),
      ),
      controller: _passwordController, // Same controller for password
      onChanged: (value) {
        _password = value; // Same variable for password
      },
    );
  }

  //Forgot password button
  Widget _buildForgotPasswordButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          //Navigate to page for forgot password functionality
        },
        child: const Text(
          'Forgot your password?',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

//Sign in Button checking SSID and Password Field
  Widget _buildSignInButton() {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          // Validate inputs
          if (_ssidController.text.isEmpty ||
              _passwordController.text.isEmpty) {
            setState(() {
              _errorMessage = "SSID and Password cannot be empty.";
            });
            return; // Prevent further execution if fields are empty
          }

          // Debug output
          print('SSID: ${_ssidController.text}');
          print('Password: ${_passwordController.text}');

          try {
            await _authService.signIn(_ssidController.text,
                _passwordController.text); // Use SSID from controller

            Navigator.pushReplacementNamed(context, '/home');
          } catch (e) {
            setState(() {
              _errorMessage = "Login failed. Please try again.";
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
        style: TextStyle(color: backGroundColor1),
      ),
    );
  }

//Create Account Button
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
          style: TextStyle(color: backGroundColor1),
        ));
  }
}

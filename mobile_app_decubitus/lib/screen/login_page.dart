import 'package:flutter/material.dart';
import 'package:mobile_app_decubitus/constant.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _errorMessage;
  String _email = '';
  String _password = '';
  bool _obscureText = true;

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
                    _buildEmailField(),
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
    return TextField(
      decoration: InputDecoration(
        labelText: 'Email',
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
      controller: _emailController,
      onChanged: (value) {
        _email = value;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      obscureText: _obscureText,
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
      controller: _passwordController,
      onChanged: (value) {
        _password = value;
      },
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
              _errorMessage = 'Invalid email or password'; // Set error message
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
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: const Text(
        'Sign in',
        style: TextStyle(color: backGroundColor1),
      ),
    );
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
          style: TextStyle(color: backGroundColor1),
        ));
  }
}

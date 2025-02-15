import 'package:flutter/material.dart';
import 'package:mobile_app_decubitus/constant.dart';
import 'package:mobile_app_decubitus/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _ssidController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _errorMessage;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _checkLoginInfo();
  }

  Future<void> _checkLoginInfo() async {
    final loginInfo = await _authService.getLoginInfo();
    if (loginInfo != null) {
      _ssidController.text = loginInfo['ssid']!;
      _passwordController.text = loginInfo['password']!;
      _signIn();
    }
  }

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _authService.signIn(
            _ssidController.text, _passwordController.text);
        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        setState(() {
          _errorMessage = "Login failed. Please try again.";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backGroundColor1,
      body: Center(
        child: SafeArea(
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
      ),
    );
  }

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

  Widget _buildImage() {
    return Image.asset(
      logoImage,
      width: 200,
      height: 200,
      fit: BoxFit.cover,
    );
  }

  Widget _buildSsidField() {
    return TextField(
      controller: _ssidController,
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
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
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
    );
  }

  Widget _buildForgotPasswordButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: backGroundColor1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                content: Container(
                  width: 160,
                  height: 55,
                  alignment: Alignment.center,
                  child: const Text(
                    'Contact your admin : 1234@gmail.com',
                    style: TextStyle(
                        fontSize: 20,
                        color: primaryColor,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          );
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
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          if (_ssidController.text.isEmpty ||
              _passwordController.text.isEmpty) {
            setState(() {
              _errorMessage = "SSID and Password cannot be empty.";
            });
            return;
          }

          try {
            await _authService.signIn(
                _ssidController.text, _passwordController.text);
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
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: const Text(
        'Create new account',
        style: TextStyle(color: backGroundColor1),
      ),
    );
  }
}

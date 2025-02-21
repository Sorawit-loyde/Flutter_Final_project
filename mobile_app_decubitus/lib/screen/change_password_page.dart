import 'package:flutter/material.dart';
import 'package:mobile_app_decubitus/constant.dart';
import 'package:mobile_app_decubitus/services/otp_service.dart';
import 'login_page.dart';

class ChangePasswordPage extends StatefulWidget {
  final int uid;

  ChangePasswordPage({required this.uid});

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final UserService _userService = UserService();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String? _errorMessage;

  Future<void> _changePassword() async {
    if (_passwordController.text.length < 6) {
      setState(() {
        _errorMessage = "Password must be at least 6 characters.";
      });
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = "Passwords do not match.";
      });
      return;
    }

    try {
      await _userService.updateUserDetails(
          widget.uid, _passwordController.text);
      setState(() {});
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to change password. Please try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor1,
      appBar: AppBar(
        title: const Text('Reset Password'),
        backgroundColor: backGroundColor1,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'At least 6 characters for password',
              style: TextStyle(fontSize: 16, color: greyColor3),
            ),
            const SizedBox(height: 15),
            const Text(
              'Sign up your Account',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 15),
            const Text(
              'New Password',
              style: TextStyle(fontSize: 16, color: greyColor3),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'New Password',
                labelStyle: const TextStyle(color: greyColor3),
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
                contentPadding: const EdgeInsets.all(18),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 25),
            const Text(
              'Confirm Password',
              style: TextStyle(fontSize: 16, color: greyColor3),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                labelStyle: const TextStyle(color: greyColor3),
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
                contentPadding: const EdgeInsets.all(18),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 25),
            Center(
              child: ElevatedButton(
                onPressed: _changePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 100),
                  textStyle: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
                child: const Text(
                  'Reset Password',
                  style: TextStyle(color: backGroundColor1, fontSize: 22),
                ),
              ),
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

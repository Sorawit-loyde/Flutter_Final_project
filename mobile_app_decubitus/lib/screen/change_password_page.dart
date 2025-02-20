import 'package:flutter/material.dart';
import 'package:mobile_app_decubitus/constant.dart';
import 'package:mobile_app_decubitus/services/otp_service.dart';
import 'package:mobile_app_decubitus/models/otp_model.dart';

class ChangePasswordPage extends StatefulWidget {
  final int uid;

  ChangePasswordPage({required this.uid});

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final UserService _userService = UserService();
  final TextEditingController _passwordController = TextEditingController();
  User? _user;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      final user = await _userService.getUserDetails(widget.uid);
      setState(() {
        _user = user;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to load user details. Please try again.";
      });
    }
  }

  Future<void> _changePassword() async {
    if (_user == null) return;

    try {
      final userDetails = _user!.toJson();
      userDetails['password'] = _passwordController.text;

      await _userService.updateUserDetails(widget.uid, userDetails);
      setState(() {
        _errorMessage = "Password changed successfully.";
      });
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
        title: const Text('Change Password'),
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
            if (_user != null) ...[
              const Text(
                'Enter your new password',
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
              Center(
                child: ElevatedButton(
                  onPressed: _changePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 140),
                    textStyle: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                  child: const Text(
                    'Change Password',
                    style: TextStyle(color: backGroundColor1),
                  ),
                ),
              ),
            ],
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

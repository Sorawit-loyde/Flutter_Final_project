import 'package:flutter/material.dart';
import 'package:mobile_app_decubitus/constant.dart';
import 'package:mobile_app_decubitus/services/otp_service.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'dart:async';
import 'change_password_page.dart';

class OtpVerificationPage extends StatefulWidget {
  final String phoneNumber;
  final int uid; // Add uid parameter
  final String token; // Add token parameter

  OtpVerificationPage(
      {required this.phoneNumber, required this.uid, required this.token});

  @override
  _OtpVerificationPageState createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final OtpService _otpService = OtpService();
  String? _errorMessage;
  int _countdown = 30;
  Timer? _timer;
  late String _token; // Use late keyword to initialize the token later

  @override
  void initState() {
    super.initState();
    _token = widget
        .token; // Initialize the token with the value passed from the previous page
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  Future<void> _resendOtp() async {
    if (_countdown == 0) {
      try {
        final response = await _otpService.sendOtp(widget.phoneNumber);
        setState(() {
          _token = response.result.token; // Update the token with the new value
          _countdown = 30;
          _startCountdown();
        });
      } catch (e) {
        setState(() {
          _errorMessage = "Failed to resend OTP. Please try again.";
        });
      }
    }
  }

  Future<void> _submitOtp(String otp) async {
    try {
      final isSuccess =
          await _otpService.verifyOtp(_token, otp); // Use the latest token
      if (isSuccess) {
        setState(() {
          _errorMessage = "OTP verified successfully.";
        });
        // Navigate to the change password page with uid
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChangePasswordPage(uid: widget.uid),
          ),
        );
      } else {
        setState(() {
          _errorMessage = "Invalid OTP. Please try again.";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to verify OTP. Please try again.";
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor1,
      appBar: AppBar(
        title: const Text('Verification'),
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
              'We sent you a code to verify your mobile number',
              style: TextStyle(fontSize: 16, color: greyColor3),
            ),
            const SizedBox(height: 15),
            const Text(
              'Enter your OTP code here',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 15),
            OtpTextField(
              textStyle: TextStyle(fontSize: 20),
              focusedBorderColor: primaryColor,
              numberOfFields: 6,
              borderColor: primaryColor,
              showFieldAsBox: true,
              onCodeChanged: (String code) {
                // Handle validation or checks here if necessary
              },
              onSubmit: (String verificationCode) {
                _submitOtp(verificationCode);
              },
            ),
            const SizedBox(height: 25),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Trigger OTP submission
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 140),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(color: backGroundColor1),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Center(
              child: const Text(
                "I don't receive a code",
                style: TextStyle(fontSize: 16, color: greyColor3),
              ),
            ),
            const SizedBox(height: 5),
            Center(
              child: GestureDetector(
                onTap: _resendOtp,
                child: Text(
                  'RESEND',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _countdown == 0 ? primaryColor : greyColor3,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Center(
              child: Text(
                '$_countdown sec',
                style: const TextStyle(fontSize: 16, color: greyColor3),
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

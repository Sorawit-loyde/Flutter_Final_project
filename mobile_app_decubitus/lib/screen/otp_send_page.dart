import 'package:flutter/material.dart';
import 'package:mobile_app_decubitus/constant.dart';
import 'package:mobile_app_decubitus/services/otp_service.dart';
import 'otp_verification_page.dart';

class OtpSendPage extends StatefulWidget {
  @override
  _OtpSendPageState createState() => _OtpSendPageState();
}

class _OtpSendPageState extends State<OtpSendPage> {
  final OtpService _otpService = OtpService();
  final TextEditingController _phoneNumberController = TextEditingController();
  String? _errorMessage;

  Future<void> _sendOtp() async {
    try {
      final response = await _otpService.sendOtp(_phoneNumberController.text);
      setState(() {});
      // Navigate to OTP verification page with token and uid
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpVerificationPage(
            phoneNumber: _phoneNumberController.text,
            uid: response.uid, // Pass the uid
            token: response.result.token, // Pass the token
          ),
        ),
      );
    } catch (e) {
      setState(() {});
    }
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
              'Enter your mobile number to enable 2-step verification',
              style: TextStyle(fontSize: 16, color: greyColor3),
            ),
            const SizedBox(height: 15),
            const Text(
              'Enter your mobile number',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 15),
            const Text(
              'Mobile No',
              style: TextStyle(fontSize: 16, color: greyColor3),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                labelText: 'Enter your mobile number',
                labelStyle: const TextStyle(color: greyColor3),
                filled: true,
                fillColor: secondaryColor,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
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
            ),
            const SizedBox(height: 25),
            Center(
              child: ElevatedButton(
                onPressed: _sendOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 140),
                  textStyle: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(color: backGroundColor1),
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

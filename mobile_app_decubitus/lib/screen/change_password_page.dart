import 'package:flutter/material.dart';
import 'package:mobile_app_decubitus/constant.dart';

class ChangePasswordPage extends StatelessWidget {
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
      body: Center(
        child: Text(
          'Change Password Page',
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
      ),
    );
  }
}

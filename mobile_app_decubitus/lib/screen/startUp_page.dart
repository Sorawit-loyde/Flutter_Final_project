import 'package:mobile_app_decubitus/constant.dart';
import 'package:flutter/material.dart';

class StartupPage extends StatelessWidget {
  const StartupPage({super.key});

  //Manage content
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor1,
      body: Padding(
        padding: const EdgeInsets.only(top: 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildLogo(),
            _buildContent(context),
          ],
        ),
      ),
    );
  }

  //Logo
  Widget _buildLogo() {
    return Image.asset(
      logoWithLabel,
      height: 350,
      width: 350,
    );
  }

  //Manage Title , Description for app and Button
  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 80),
      child: Column(
        children: [
          _buildTitle(),
          _buildDescription(),
          const SizedBox(height: 100),
          _buildGetStartedButton(context),
        ],
      ),
    );
  }

  //Title
  Widget _buildTitle() {
    return const Center(
      child: Text(
        'ยินดีต้อนรับสู่ DECUBITUS',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  //Description
  Widget _buildDescription() {
    return const SizedBox(
      width: 300,
      child: Text(
        'แอปพลิเคชันที่เป็นตัวช่วยการทำนายความรุนแรงของแผลกดทับพร้อมกับวิธีการดูแลเบื้องต้น',
        textAlign: TextAlign.center,
      ),
    );
  }

  //Button
  Widget _buildGetStartedButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushReplacementNamed(
            context, '/login'); //Navigate to Login page
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        textStyle: const TextStyle(fontSize: 25),
      ),
      child: const Text(
        'เริ่มต้นใช้งาน',
        style: TextStyle(color: backGroundColor1),
      ),
    );
  }
}

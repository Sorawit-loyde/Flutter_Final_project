import 'package:mobile_app_decubitus/constant.dart';
import 'package:flutter/material.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildLogo(),
            _buildContent(context), // Pass context here
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      logoWithLabel,
      height: 350,
      width: 350,
    );
  }

  Widget _buildContent(BuildContext context) {
    // Accept context as a parameter
    return Padding(
      padding: const EdgeInsets.only(bottom: 80),
      child: Column(
        children: [
          _buildTitle(),
          _buildDescription(),
          const SizedBox(height: 100),
          _buildGetStartedButton(context), // Pass context here
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return const Center(
      child: Text(
        'Welcome to Decubitus App',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return const SizedBox(
      width: 300,
      child: Text(
        'This app helps you manage and prevent decubitus ulcers.',
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildGetStartedButton(BuildContext context) {
    // Accept context as a parameter
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, '/login');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        textStyle: const TextStyle(fontSize: 25),
      ),
      child: const Text(
        'Get Started',
        style: TextStyle(color: backGroundColor),
      ),
    );
  }
}

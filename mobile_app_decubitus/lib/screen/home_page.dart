import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_app_decubitus/constant.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Prevent default back button
        backgroundColor: primaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        toolbarHeight: 170, // Adjust height of the AppBar
        flexibleSpace: Container(
          padding: const EdgeInsets.only(
              left: 5, top: 40), // Padding for positioning
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back,
                    color: backGroundColor2), // Back arrow icon
                onPressed: () {
                  Navigator.pop(context); // Navigate back
                },
              ),
              const SizedBox(width: 10), // Space between arrow and text
              const Text(
                'Home',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: backGroundColor2,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Text('Content goes here'), // Main content of the page
      ),
    );
  }
}

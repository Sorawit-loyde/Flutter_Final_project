import 'package:flutter/material.dart';
import 'package:mobile_app_decubitus/components/custom_Appbar.dart';
import 'package:mobile_app_decubitus/components/bottom_Navbar.dart';
import 'package:mobile_app_decubitus/screen/home_content.dart';
import 'package:mobile_app_decubitus/screen/followUp_content.dart';
import 'package:mobile_app_decubitus/screen/profile_content.dart';
import 'package:mobile_app_decubitus/screen/chat_content.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false; // Returning false prevents the back action
        },

        //manage main content between nav bar and bottom nav bar
        child: const Scaffold(
          appBar: CustomAppBar(),
          body: BottomNavBar(
            pages: [
              HomeContent(), // Home tab content
              ChatContent(), //Chat tab content
              FollowupContent(), // FollowUp tab content
              ProfileContent(), // Profile tab content
            ],
          ),
        ));
  }
}

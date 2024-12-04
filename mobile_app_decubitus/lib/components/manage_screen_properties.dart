import 'package:flutter/material.dart';
import 'package:mobile_app_decubitus/components/custom_Appbar.dart';
import 'package:mobile_app_decubitus/components/bottom_Navbar.dart';
import 'package:mobile_app_decubitus/screen/chat_page.dart';
import 'package:mobile_app_decubitus/screen/home_content.dart';
import 'package:mobile_app_decubitus/screen/followUp_content.dart';
import 'package:mobile_app_decubitus/screen/profile_content.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return false; // Returning false prevents the back action
        },

        //manage role in this zone seperrate 3 array for 3 roles****
        child: const Scaffold(
          appBar: CustomAppBar(),
          body: BottomNavBar(
            pages: [
              HomeContent(), // Home tab content
              Chatroom(roomId: 1,), //Chat tab content
              FollowupContent(), // FollowUp tab content
              ProfileContent(), // Profile tab content
            ],
          ),
        ));
  }
}

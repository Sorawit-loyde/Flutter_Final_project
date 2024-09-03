import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:mobile_app_decubitus/constant.dart';

class BottomNavBar extends StatefulWidget {
  final List<Widget> pages; // List of pages to display

  const BottomNavBar({super.key, required this.pages});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: widget.pages[
              _selectedIndex], // Display the content based on the selected index
        ),
        GNav(
          backgroundColor: backGroundColor2,
          color: Colors.black,
          activeColor: primaryColor,
          onTabChange: (index) {
            _onItemTapped(index); // Update the selected index
            // Handle navigation based on the selected index
            switch (index) {
              case 0:
                // Navigate to Home
                break;
              case 1:
                // Navigate to Chat
                break;
              case 2:
                // Navigate to Follow Up
                break;
              case 3:
                // Navigate to Profile
                break;
            }
          },
          tabs: const [
            GButton(
              icon: Icons.home,
              text: "Home",
            ),
            GButton(
              icon: Icons.chat,
              text: "Chat",
            ),
            GButton(
              icon: Icons.history,
              text: "Follow Up",
            ),
            GButton(
              icon: Icons.person,
              text: "Profile",
            ),
          ],
        ),
      ],
    );
  }
}

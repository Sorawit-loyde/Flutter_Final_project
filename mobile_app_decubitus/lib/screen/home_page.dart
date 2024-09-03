import 'package:flutter/material.dart';
import 'package:mobile_app_decubitus/components/custom_Appbar.dart';
import 'package:mobile_app_decubitus/components/bottom_Navbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex =
      0; // Track the selected index for the bottom navigation bar

  // List of widgets for each tab
  final List<Widget> _pages = [
    Center(child: Text('Home Page Content')), // Content for Home tab
    Center(child: Text('Search Page Content')), // Content for Search tab
    Center(child: Text('Profile Page Content')), // Content for Profile tab
  ];

  // Function to handle tab selection
  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: _pages[
          _selectedIndex], // Display the content based on the selected index
      bottomNavigationBar: BottomNavBar(
        onTabSelected: _onTabSelected, // Pass the callback to the BottomNavBar
      ),
    );
  }
}

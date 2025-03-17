import 'package:flutter/material.dart';
import 'package:mobile_app_decubitus/components/custom_Appbar.dart';
import 'package:mobile_app_decubitus/components/bottom_Navbar.dart';
import 'package:mobile_app_decubitus/screen/patient/home_content.dart';
import 'package:mobile_app_decubitus/screen/patient/followUp_content.dart';
import 'package:mobile_app_decubitus/screen/patient/profile_content.dart';
import 'package:mobile_app_decubitus/screen/nurse/Nurse_patient_list.dart';
import 'package:mobile_app_decubitus/screen/nurse/Nurse_followUp_list.dart';
import 'package:mobile_app_decubitus/screen/room_page.dart';
import 'package:mobile_app_decubitus/services/user_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<CustomAppBarState> _appBarKey =
      GlobalKey<CustomAppBarState>();

  Future<int> fetchRoleId() async {
    final userService = UserService();
    return await userService.getRoleId();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false; // Prevents back action
      },
      child: Scaffold(
        appBar: CustomAppBar(key: _appBarKey),
        body: FutureBuilder<int>(
          future: fetchRoleId(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error fetching role'));
            } else if (!snapshot.hasData || snapshot.data == 0) {
              return const Center(child: Text('No role assigned'));
            } else {
              final roleId = snapshot.data!;
              List<Widget> pages;

              if (roleId == 2) {
                pages = [
                  const HomeContent(),
                  const RoomPage(),
                  const FollowupContent(),
                  ProfileContent(appBarKey: _appBarKey),
                ];
              } else if (roleId == 3) {
                pages = [
                  const PatientListPage(),
                  const RoomPage(),
                  const NurseFollowupList(),
                  ProfileContent(appBarKey: _appBarKey),
                ];
              } else {
                // Default or other role screens
                pages = [/* Default pages or an error page */];
              }

              return BottomNavBar(
                pages: pages,
              );
            }
          },
        ),
      ),
    );
  }
}

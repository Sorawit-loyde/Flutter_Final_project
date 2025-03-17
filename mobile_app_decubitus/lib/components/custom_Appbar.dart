import 'package:flutter/material.dart';
import 'package:mobile_app_decubitus/config/config.dart';
import 'package:mobile_app_decubitus/constant.dart';
import 'package:mobile_app_decubitus/models/user_model.dart'; // Import your User model
import 'package:mobile_app_decubitus/services/user_service.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  CustomAppBarState createState() => CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(160);
}

class CustomAppBarState extends State<CustomAppBar> {
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
  }

  Future<User> _fetchData() async {
    try {
      return await _userService.getprofile(); // Fetch user profile
    } catch (e) {
      throw Exception('Failed to load user profile');
    }
  }

  void refreshAppBar() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: primaryColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      toolbarHeight: 160,
      flexibleSpace: Padding(
        padding: const EdgeInsets.only(left: 20, top: 52),
        child: FutureBuilder<User>(
          future: _fetchData(), // Fetch user data
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator()); // Loading state
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}'); // Error state
            } else if (snapshot.hasData) {
              User user = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),
                  _userProfile(user), // Pass the fetched user data
                ],
              );
            } else {
              return const Text('No data found'); // Fallback for no data
            }
          },
        ),
      ),
    );
  }

  Widget _userProfile(User user) {
    // Accept user as parameter
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 44,
            backgroundImage: user.profileImage != null
                ? NetworkImage(
                    '${Custom_Config.Image_URL}/${user.profileImage}')
                : const NetworkImage(
                    '${Custom_Config.Image_URL}/static/profile.jpg'), // Fallback image if no profile image is provided
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${user.firstName} ${user.lastName}", // Display fetched name
                style: const TextStyle(
                    color: backGroundColor2,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 3),
              // Display the role name
              if (user.roles.isNotEmpty) // Check if there are roles available
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 1, 15, 1),
                  decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(13.0)),
                  child: Text(
                    user.roles[0].name, // Display the name of the first role
                    style: const TextStyle(color: primaryColor, fontSize: 16),
                  ),
                )
              else
                const SizedBox.shrink(), // If no roles, show nothing
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mobile_app_decubitus/services/user_profile_service.dart';
import 'package:mobile_app_decubitus/models/user_profile_model.dart';

class ProfileContent extends StatefulWidget {
  const ProfileContent({Key? key}) : super(key: key);

  @override
  State<ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  Map<String, String> userInfo = {}; // To store the fetched user data
  bool isLoading = true; // To show a loading spinner
  String errorMessage = ''; // To show error messages

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      userpf user = await UserProfileService().getUserProfile();
      setState(() {
        userInfo = {
          'ชื่อ': user.firstName ?? 'N/A',
          'นามสกุล': user.lastName ?? 'N/A',
          'เพศ': user.gender ?? 'N/A',
          'วัน/เดือน/ปีเกิด': user.birthDate ?? 'N/A',
          'เลขรหัสประชาชน': user.ssid ?? 'N/A',
          'เบอโทรศัทพ์ติดต่อ': user.phone ?? 'N/A',
        };
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage.isNotEmpty
                ? Center(
                    child: Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView(
                    children: userInfo.entries.map((entry) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 5.0),
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Text(
                              entry.key,
                              style: const TextStyle(
                                fontSize: 19.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          subtitle: Text(entry.value),
                        ),
                      );
                    }).toList(),
                  ),
      ),
    );
  }
}

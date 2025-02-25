import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_app_decubitus/services/user_profile_service.dart';
import 'package:mobile_app_decubitus/models/user_profile_model.dart';
import 'package:mobile_app_decubitus/config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:mobile_app_decubitus/constant.dart'; // Import the constants
import 'package:mobile_app_decubitus/components/custom_Appbar.dart';

class ProfileContent extends StatefulWidget {
  final GlobalKey<CustomAppBarState> appBarKey;

  const ProfileContent({super.key, required this.appBarKey});

  @override
  State<ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  Map<String, String> userInfo = {}; // To store the fetched user data
  bool isLoading = true; // To show a loading spinner
  String profileImageUrl = ''; // To store the profile image URL
  bool isEditing = false; // To track if the user is in edit mode
  int roleId = 0; // To store the role ID
  String password = ''; // To store the password
  File? _image; // To store the selected image
  TextEditingController? _birthdateController; // Controller for birthdate field
  String selectedGender = ''; // Add this line

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
          'ชื่อ': user.first_name ?? 'N/A',
          'นามสกุล': user.last_name ?? 'N/A',
          'เพศ': user.sex ?? 'N/A',
          'วัน/เดือน/ปีเกิด': user.birthdate != null
              ? DateFormat('dd/MM/yyyy').format(DateTime.parse(user.birthdate!))
              : 'N/A',
          'เลขรหัสประชาชน': user.ssid ?? 'N/A',
          'เบอโทรศัทพ์ติดต่อ': user.phone ?? 'N/A',
        };
        profileImageUrl = user.profile_image ?? '';
        roleId = user.roles.isNotEmpty ? user.roles[0].id : 0;
        password = user.password ?? '';
        isLoading = false;
        _birthdateController =
            TextEditingController(text: userInfo['วัน/เดือน/ปีเกิด']);
        selectedGender = userInfo['เพศ'] ?? ''; // Add this line
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showSnackBar(
          context,
          e
              .toString()
              .replaceAll('Exception: ', '')); // Show error message in SnackBar
    }
  }

  Future<void> updateUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getString('Uid');
      final updatedData = {
        'ssid': userInfo['เลขรหัสประชาชน'],
        'sex': userInfo['เพศ'],
        'phone': userInfo['เบอโทรศัทพ์ติดต่อ'],
        'first_name': userInfo['ชื่อ'],
        'last_name': userInfo['นามสกุล'],
        'birthdate': DateFormat('yyyy-MM-dd').format(DateFormat('dd/MM/yyyy')
            .parse(userInfo['วัน/เดือน/ปีเกิด']!)
            .add(Duration(days: 1))),
        'profile_image': profileImageUrl,
      };
      await UserProfileService().updateUserProfile(id!, updatedData);
      setState(() {
        isEditing = false;
      });
      widget.appBarKey.currentState?.refreshAppBar(); // Refresh the app bar
      await fetchUserProfile(); // Fetch the updated user profile
    } catch (e) {
      _showSnackBar(
          context,
          e
              .toString()
              .replaceAll('Exception: ', '')); // Show error message in SnackBar
    }
  }

  Future<void> refrech() async {
    try {
      await fetchUserProfile();
      setState(() {
        isEditing = false;
      });
    } catch (e) {
      _showSnackBar(
          context,
          e
              .toString()
              .replaceAll('Exception: ', '')); // Show error message in SnackBar
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        profileImageUrl = pickedFile.path; // Update the profile image URL
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: darkColor, // Body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: primaryColor, // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      // Use local time to avoid time zone issues
      final DateTime selectedDate =
          DateTime(picked.year, picked.month, picked.day);
      setState(() {
        userInfo['วัน/เดือน/ปีเกิด'] =
            DateFormat('dd/MM/yyyy').format(selectedDate);
        _birthdateController?.text = userInfo['วัน/เดือน/ปีเกิด']!;
      });
    }
  }

  Future<void> _logout() async {
    // Implement your logout logic here
    // For example, clear the shared preferences and navigate to the login screen
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isEditing) {
          setState(() {
            isEditing = false;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: backGroundColor1,
          toolbarHeight: 40,
          automaticallyImplyLeading:
              isEditing, // Show back arrow icon when editing
          leading: isEditing
              ? IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      isEditing = false;
                    });
                  },
                )
              : null,
          actions: [
            IconButton(
              icon: Icon(isEditing ? Icons.save : Icons.edit),
              onPressed: () {
                if (isEditing) {
                  updateUserProfile();
                } else {
                  setState(() {
                    isEditing = true;
                  });
                }
              },
            ),
          ],
        ),
        body: Container(
          color: backGroundColor1,
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  children: [
                    if (profileImageUrl.isNotEmpty)
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            if (isEditing) {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: Icon(Icons.camera),
                                      title: Text('Camera'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        _pickImage(ImageSource.camera);
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.photo_library),
                                      title: Text('Gallery'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        _pickImage(ImageSource.gallery);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: _image != null
                                ? FileImage(_image!)
                                : NetworkImage(
                                    profileImageUrl.isNotEmpty
                                        ? '${Custom_Config.Image_URL}/$profileImageUrl'
                                        : '${Custom_Config.Image_URL}/static/profile.jpg',
                                  ) as ImageProvider,
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    ...userInfo.entries.map((entry) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 5.0),
                        color: tertiaryColor,
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Text(
                              entry.key,
                              style: const TextStyle(
                                fontSize: 19.0,
                                fontWeight: FontWeight.bold,
                                color: darkColor,
                              ),
                            ),
                          ),
                          subtitle: isEditing
                              ? entry.key == 'วัน/เดือน/ปีเกิด'
                                  ? TextFormField(
                                      controller: _birthdateController,
                                      decoration: InputDecoration(
                                        hintText: 'Select Date',
                                        hintStyle: TextStyle(color: greyColor3),
                                      ),
                                      readOnly:
                                          true, // Make the field read-only to prevent manual input
                                      onTap: () => _selectDate(
                                          context), // Show date picker on tap
                                    )
                                  : entry.key == 'เพศ'
                                      ? Row(
                                          children: [
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    selectedGender = 'Male';
                                                    userInfo['เพศ'] = 'Male';
                                                  });
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      selectedGender == 'Male'
                                                          ? primaryColor
                                                          : secondaryColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.male,
                                                      color: Colors.black,
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text(
                                                      'Male',
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    selectedGender = 'Female';
                                                    userInfo['เพศ'] = 'Female';
                                                  });
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      selectedGender == 'Female'
                                                          ? primaryColor
                                                          : secondaryColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.female,
                                                      color: Colors.black,
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text(
                                                      'Female',
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : TextFormField(
                                          initialValue: entry.value,
                                          onChanged: (value) {
                                            setState(() {
                                              userInfo[entry.key] = value;
                                            });
                                          },
                                          decoration: InputDecoration(
                                            hintStyle:
                                                TextStyle(color: greyColor3),
                                          ),
                                        )
                              : Text(
                                  entry.value,
                                  style: TextStyle(color: darkColor),
                                ),
                        ),
                      );
                    }),
                    const SizedBox(height: 5),
                    if (!isEditing)
                      Center(
                        child: ElevatedButton(
                          onPressed: _logout,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: primaryColor, // Button text color
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            'ออกจากระบบ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}

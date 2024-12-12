import 'package:flutter/material.dart';
import 'package:mobile_app_decubitus/services/user_service.dart';
import 'package:http/http.dart' as http;

final Map<String, String> userInfo = {
    'ชื่อ': 'John',
    'นามสกุล': 'Doe',
    'เพศ': 'Male',
    'วัน/เดือน/ปีเกิด': '01/01/1990',
    'เลขรหัสประชาชน': '123-45-6789',
    'เบอโทรศัทพ์ติดต่อ': '+1 234 567 8900',
};

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('User Profile'),
      //   centerTitle: true,
      // ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            // User Info
            Expanded(
              child: ListView(
                children: userInfo.entries.map((entry) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5.0),
                    child: ListTile(
                      // leading: Icon(Icons.person),
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Text(entry.key, style: TextStyle(fontSize:19.0, fontWeight: FontWeight.bold)),
                      ),
                      subtitle: Text(entry.value),
                      minLeadingWidth: 60,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

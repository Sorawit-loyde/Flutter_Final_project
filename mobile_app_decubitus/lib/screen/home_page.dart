import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_app_decubitus/constant.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          padding: const EdgeInsets.only(left: 5, top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: backGroundColor2),
                    onPressed: () => Navigator.pop(context),
                  ),
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
              const Padding(
                padding: EdgeInsets.only(left: 25),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 44,
                      backgroundImage:
                          NetworkImage('https://example.com/profile.jpg'),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Sorawit"),
                        Text("1100600467462"),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: const Center(
        child: Text('Content goes here'),
      ),
    );
  }
}

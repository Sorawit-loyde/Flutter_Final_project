import 'package:flutter/material.dart';
import 'package:mobile_app_decubitus/constant.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

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
        padding: const EdgeInsets.only(left: 20, top: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 10),
            _userProfile(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return const Row(
      children: [
        Text(
          'Home',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600,
            color: backGroundColor2,
          ),
        ),
      ],
    );
  }

  Widget _userProfile() {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 44,
            backgroundImage: NetworkImage('https://via.placeholder.com/150'),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Sorawit",
                style: TextStyle(
                    color: backGroundColor2,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),
              const Text(
                "1100600467462",
                style: TextStyle(
                    color: backGroundColor2,
                    fontSize: 17,
                    fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 3),
              Container(
                padding: const EdgeInsets.fromLTRB(15, 1, 15, 1),
                decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(13.0)),
                child: const Text('Patient',
                    style: TextStyle(color: primaryColor, fontSize: 16)),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.edit),
            color: backGroundColor2,
            onPressed: () {
              print('Edit icon clicked!');
            },
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(160);
}

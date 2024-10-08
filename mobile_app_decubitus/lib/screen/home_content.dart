import 'package:flutter/material.dart';
import 'package:mobile_app_decubitus/constant.dart';
import 'package:mobile_app_decubitus/services/user_service.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  List<String> items = []; // This will hold your service data
  bool isLoading = true; // To track loading state
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _fetchData(); // Call your service here
  }

  Future<void> _fetchData() async {
    // Simulating a network call or service
    await _userService.getprofile();
    await Future.delayed(const Duration(seconds: 2)); // Simulate a delay
    setState(() {
      // Assuming you fetch a list of items from your service
      items = List.generate(5, (index) => 'Item ${index + 1}');
      isLoading = false; // Update loading state
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor1,
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: greyColor1),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                fillColor: greyColor1,
                filled: true,
                suffixIcon: const Icon(Icons.search),
              ),
            ),
          ),

          // Main Content Area (List)
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator()) // Loading indicator
                : ListView.separated(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(items[index]),
                        // Add more properties as needed
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider(
                        color: greyColor2,
                        thickness: 1.0,
                        indent: 16.0,
                        endIndent: 16.0,
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your button press logic here
        },
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0.0,
        shape: const CircleBorder(),
        tooltip: 'Add Item',
        child: const Icon(
          Icons.add,
          size: 25.0,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mobile_app_decubitus/constant.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample static items for display
    List<String> items = List.generate(5, (index) => 'Item ${index + 1}');

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
            child: ListView.separated(
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

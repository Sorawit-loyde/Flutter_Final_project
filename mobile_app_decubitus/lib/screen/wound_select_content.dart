import 'package:flutter/material.dart';
import 'package:mobile_app_decubitus/models/perusal_model.dart';
import 'package:mobile_app_decubitus/models/wound_model.dart'; // Import the wound model
import 'package:mobile_app_decubitus/screen/home_content.dart'; // Import HomeContent for navigation
import 'package:mobile_app_decubitus/services/wound_service.dart'; // Import the wound service
import 'package:mobile_app_decubitus/constant.dart'; // Import your constants
import 'package:mobile_app_decubitus/config/config.dart';
import 'package:mobile_app_decubitus/screen/wound_select_form.dart'; // Import your wound form page

class WoundSelectPage extends StatefulWidget {
  final Perusal perusal;

  const WoundSelectPage({super.key, required this.perusal});

  @override
  _WoundSelectPageState createState() => _WoundSelectPageState();
}

class _WoundSelectPageState extends State<WoundSelectPage> {
  late Future<List<WoundGroup>> futureWounds;

  @override
  void initState() {
    super.initState();
    futureWounds =
        WoundService(Custom_Config.BASE_URL) // Use appropriate URL for emulator
            .fetchGroupedWounds(widget.perusal.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            backGroundColor1, // Set AppBar background color to backGroundColor1
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const HomeContent()), // Navigate to HomeContent
            );
          },
        ),
      ),
      body: Container(
        color:
            backGroundColor1, // Set body background color to backGroundColor1
        child: FutureBuilder<List<WoundGroup>>(
          future: futureWounds,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('Error fetching data: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No wounds found.'));
            }

            final woundGroups = snapshot.data!;

            // Display categorized wound groups with details
            return ListView.builder(
              itemCount: woundGroups.length,
              itemBuilder: (context, index) {
                final group = woundGroups[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  color:
                      backGroundColor1, // Set card background color to backGroundColor1
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: primaryColor,
                        width: 2), // Set outline color to primaryColor
                    borderRadius:
                        BorderRadius.circular(8), // Optional rounded corners
                  ),
                  elevation:
                      0, // Remove shadow effect to avoid grey line collapse
                  child: ExpansionTile(
                    title: Text(
                      group.area,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18), // Increased font size for area title
                    ),
                    childrenPadding: const EdgeInsets.symmetric(
                        vertical: 8.0), // Add padding for child items
                    children: group.wounds.asMap().entries.map((entry) {
                      int woundIndex = entry.key + 1; // Start numbering from 1
                      Wound wound = entry.value;
                      String woundLabel =
                          'แผล $woundIndex'; // Format the wound label
                      String status = 'Status: ${wound.status}';

                      return GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const WoundSelectForm()),
                          );
                        },
                        child: ListTile(
                          title: Text(woundLabel),
                          subtitle: Text(status),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    WoundSelectForm()), // Navigate to the wound form page
          );
        },
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0.0,
        tooltip: 'Add Wound',
        child: const Icon(Icons.add), // Icon for the FAB
      ),
    );
  }
}

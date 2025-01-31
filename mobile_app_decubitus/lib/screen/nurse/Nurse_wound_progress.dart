import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_decubitus/models/wound_list_model.dart';
import 'package:mobile_app_decubitus/screen/nurse/Nurse_followUp_content.dart';
import 'package:mobile_app_decubitus/services/wound_list_service.dart';
import 'package:mobile_app_decubitus/config/config.dart';
import 'package:mobile_app_decubitus/constant.dart';
import 'package:mobile_app_decubitus/screen/nurse/Nurse_follow_up_result.dart';
import 'package:mobile_app_decubitus/screen/nurse/Nurse_followUp_content.dart';

class NurseWoundProgress extends StatelessWidget {
  final int woundId;

  const NurseWoundProgress({super.key, required this.woundId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor1,
      appBar: AppBar(
        toolbarHeight: 50.0, // Narrow the AppBar
        backgroundColor:
            backGroundColor1, // Set AppBar color to match the background
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NurseFollowupContent(),
              ),
            );
          },
        ),
      ),
      body: Container(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 10.0), // Avoid overlap with AppBar
          child: SingleChildScrollView(
            // Wrap the whole content in a scrollable view
            child: Column(
              mainAxisSize: MainAxisSize.min, // Center content
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align cards to the top
              children: [
                // The dynamic ListView to display multiple cards
                FutureBuilder<List<Wound>>(
                  future: WoundService().fetchWounds(woundId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return ListView.builder(
                        shrinkWrap:
                            true, // Prevent the ListView from taking unnecessary space
                        physics:
                            const NeverScrollableScrollPhysics(), // Disable scrolling within the ListView
                        itemCount:
                            snapshot.data!.length, // Number of cards to display
                        itemBuilder: (context, index) {
                          var wound = snapshot
                              .data![index]; // Get the wound at this index
                          return GestureDetector(
                            onTap: () {
                              // Navigate to ModelResultScreen with wound_id
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NurseFollowupResultScreen(
                                    woundId: wound.id, // Pass the wound ID
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              elevation: 5,
                              color:
                                  backGroundColor2, // Set the background color to backgroundColor2
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    // Image on the left
                                    Image.network(
                                      '${Custom_Config.Image_URL}/${wound.woundImage}',
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(width: 15),
                                    // Details on the right
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Date of the last action
                                          Text(
                                            'วันที่ทำรายการล่าสุด: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(wound.updatedAt))}',
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                          const SizedBox(height: 8),
                                          // Wound severity level (just the ID number)
                                          Text(
                                            'ระดับความรุนแรงแผล: ${wound.woundState.id}', // Show only the ID number
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                          const SizedBox(height: 8),
                                          // Wound reference area (if exists)
                                          Text(
                                            'แผลกดทับที่: ${wound.area}',
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Text('No wounds found.');
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

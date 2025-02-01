import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_decubitus/config/config.dart';
import 'package:mobile_app_decubitus/constant.dart';
import 'package:mobile_app_decubitus/models/wound_list_model.dart';
import 'package:mobile_app_decubitus/services/wound_list_service.dart';
import 'package:mobile_app_decubitus/screen/nurse/Nurse_follow_up_content.dart';
import 'package:mobile_app_decubitus/screen/nurse/Nurse_follow_up_result.dart';

class NurseWoundProgress extends StatelessWidget {
  final int woundId;
  final String patientId; // Add patientId parameter

  const NurseWoundProgress(
      {super.key,
      required this.woundId,
      required this.patientId}); // Update constructor

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
                builder: (context) => NurseFollowUpContent(
                  patientId: patientId,
                ),
              ),
            );
          },
        ),
      ),
      body: FutureBuilder<List<Wound>>(
        future: WoundService().fetchWounds(woundId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var wound = snapshot.data![index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NurseFollowupResultScreen(
                          woundId: wound.id,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    elevation: 5,
                    color: backGroundColor2,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Image.network(
                            '${Custom_Config.Image_URL}/${wound.woundImage}',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'วันที่ทำรายการล่าสุด: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(wound.updatedAt))}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'ระดับความรุนแรงแผล: ${wound.woundState.id}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'แผลกดทับที่: ${wound.area}',
                                  style: const TextStyle(fontSize: 16),
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
            return const Center(child: Text('ยังไม่มีแผลให้ติดตาม'));
          }
        },
      ),
    );
  }
}

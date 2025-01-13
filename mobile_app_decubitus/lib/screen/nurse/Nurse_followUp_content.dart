import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_decubitus/models/wound_follow_up_model.dart';
import 'package:mobile_app_decubitus/services/wound_follow_up_service.dart';
import 'package:mobile_app_decubitus/config/config.dart';
import 'package:mobile_app_decubitus/constant.dart';
import 'package:mobile_app_decubitus/screen/patient/wound_progress.dart'; // Import the wound progress page

class NurseFollowupContent extends StatefulWidget {
  const NurseFollowupContent({super.key});

  @override
  _NurseFollowupContentState createState() => _NurseFollowupContentState();
}

class _NurseFollowupContentState extends State<NurseFollowupContent> {
  final FollowUpService _followUpService = FollowUpService();
  late Future<List<FollowUp>> _futureFollowUps;

  @override
  void initState() {
    super.initState();
    _futureFollowUps = _followUpService.fetchFollowUps('patientId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor1,
      body: Navigator(
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            builder: (context) => Container(
              color: backGroundColor1, // Set the background color of the page
              child: FutureBuilder<List<FollowUp>>(
                future: _futureFollowUps,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final followUps = snapshot.data!;
                    return ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: followUps.length,
                      itemBuilder: (context, index) {
                        final followUp = followUps[index];
                        return FollowUpCard(followUp: followUp);
                      },
                    );
                  } else {
                    return const Center(child: Text('No data available'));
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class FollowUpCard extends StatelessWidget {
  final FollowUp followUp;

  const FollowUpCard({required this.followUp});

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd/MM/yyyy').format(followUp.createdAt);

    return GestureDetector(
      onTap: () {
        // Navigate to WoundProgressPage, passing the woundId
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WoundProgress(woundId: followUp.id),
          ),
        );
      },
      child: Card(
        color: backGroundColor2,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  '${Custom_Config.Image_URL}/${followUp.imageUrl}',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'วันที่ทำรายการล่าสุด: $formattedDate',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'ระดับความรุนแรงแผล: ${followUp.woundState.id}',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'แผลกดทับที่ : ${followUp.area}',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

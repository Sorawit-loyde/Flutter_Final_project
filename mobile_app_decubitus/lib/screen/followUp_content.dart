import 'package:flutter/material.dart';
import 'package:mobile_app_decubitus/models/wound_follow_up_model.dart';
import 'package:mobile_app_decubitus/services/wound_follow_up_service.dart';
import 'package:mobile_app_decubitus/config/config.dart';

class FollowupContent extends StatefulWidget {
  const FollowupContent({super.key});

  @override
  _FollowupContentState createState() => _FollowupContentState();
}

class _FollowupContentState extends State<FollowupContent> {
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
      appBar: AppBar(
        title: const Text('Follow Up'),
      ),
      body: FutureBuilder<List<FollowUp>>(
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
    );
  }
}

class FollowUpCard extends StatelessWidget {
  final FollowUp followUp;

  const FollowUpCard({required this.followUp});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network('${Custom_Config.Image_URL}/${followUp.imageUrl}'),
            const SizedBox(height: 8),
            Text('วันที่ทำรายการ: ${followUp.createdAt.toLocal()}'),
            Text('ระดับความรุนแรงแผล: ${followUp.count}'),
            Text('สถานที่ทำรายการ: ${followUp.area}'),
          ],
        ),
      ),
    );
  }
}

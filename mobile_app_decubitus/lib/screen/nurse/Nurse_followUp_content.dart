import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_decubitus/models/patient_model.dart';
import 'package:mobile_app_decubitus/services/patient_service.dart';
import 'package:mobile_app_decubitus/config/config.dart';
import 'package:mobile_app_decubitus/constant.dart';
import 'package:mobile_app_decubitus/screen/patient/wound_progress.dart';

class NurseFollowupContent extends StatefulWidget {
  const NurseFollowupContent({super.key});

  @override
  _NurseFollowupContentState createState() => _NurseFollowupContentState();
}

class _NurseFollowupContentState extends State<NurseFollowupContent> {
  final ApiService _apiService = ApiService();
  late Future<List<Patient>> _futurePatients;

  @override
  void initState() {
    super.initState();
    _futurePatients = _apiService.fetchNursePatients();
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
              child: FutureBuilder<List<Patient>>(
                future: _futurePatients,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final patients = snapshot.data!;
                    return ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: patients.length,
                      itemBuilder: (context, index) {
                        final patient = patients[index];
                        return FollowUpCard(patient: patient);
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
  final Patient patient;

  const FollowUpCard({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('dd/MM/yyyy').format(DateTime.parse(patient.createdAt));

    return GestureDetector(
      onTap: () {
        // Navigate to WoundProgressPage, passing the woundId
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WoundProgress(woundId: patient.id),
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
                  '${Custom_Config.Image_URL}/${patient.profileImage}',
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
                      '${patient.firstName} ${patient.lastName}',
                      style: const TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Patient Status: ${patient.patientStatus}',
                      style: const TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Created At: $formattedDate',
                      style: const TextStyle(
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

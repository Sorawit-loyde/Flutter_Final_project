import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_decubitus/models/patient_model.dart';
import 'package:mobile_app_decubitus/services/patient_service.dart';
import 'package:mobile_app_decubitus/config/config.dart';
import 'package:mobile_app_decubitus/constant.dart';

class PatientListPage extends StatefulWidget {
  const PatientListPage({Key? key}) : super(key: key);

  @override
  _PatientListPageState createState() => _PatientListPageState();
}

class _PatientListPageState extends State<PatientListPage> {
  String _searchQuery = '';
  List<Patient> _allPatients = [];
  List<Patient> _filteredPatients = [];
  bool _showFab = true;

  @override
  void initState() {
    super.initState();
    fetchPatients();
  }

  Future<void> fetchPatients() async {
    final patients = await ApiService().fetchPatients();
    setState(() {
      _allPatients = patients;
      _filteredPatients = patients;
    });
  }

  void _filterPatients(String query) {
    setState(() {
      _searchQuery = query;
      _filteredPatients = _searchQuery.isEmpty
          ? _allPatients
          : _allPatients
              .where((patient) => '${patient.firstName} ${patient.lastName}'
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
              .toList();
    });
  }

  String formatPatientDate(String dateStr) {
    DateTime date = DateTime.parse(dateStr);
    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor1,
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              onChanged: _filterPatients,
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
          Expanded(
            child: _filteredPatients.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _filteredPatients.length,
                    itemBuilder: (context, index) {
                      final patient = _filteredPatients[index];
                      return Card(
                        color: tertiaryColor,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 5.0),
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16.0),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                '${Custom_Config.Image_URL}/${patient.profileImage}'),
                          ),
                          title:
                              Text('${patient.firstName} ${patient.lastName}'),
                          subtitle: Text(
                              'Date Added: ${formatPatientDate(patient.createdAt)}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              // Implement delete functionality if needed
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: _showFab
          ? FloatingActionButton(
              onPressed: () {
                // Implement add functionality if needed
              },
              backgroundColor: tertiaryColor,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

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
  List<Patient> _nursePatients = [];
  List<Patient> _filteredPatients = [];
  bool _showFab = true;

  @override
  void initState() {
    super.initState();
    fetchNursePatients(); // Fetch nurse-specific patients for the list view
  }

  // Fetch nurse-specific patients using the API for the ListView
  Future<void> fetchNursePatients() async {
    final patients = await ApiService().fetchNursePatients();
    setState(() {
      _nursePatients = patients;
      _filteredPatients = patients;
    });
  }

  // Fetch all patients using the API for the dialog
  Future<void> fetchAllPatientsForDialog() async {
    final patients = await ApiService().fetchAllPatients();
    setState(() {
      _filteredPatients = patients;
    });
  }

  void _filterPatients(String query) {
    setState(() {
      _searchQuery = query;
      _filteredPatients = _searchQuery.isEmpty
          ? _nursePatients
          : _nursePatients
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

  void _showDialogList(BuildContext context) {
    List<int> selectedIndices = [];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Select Patients'),
              content: SizedBox(
                width: double.maxFinite,
                height: 300.0, // Set a fixed height for the list container
                child: Scrollbar(
                  thumbVisibility: true,
                  child: FutureBuilder(
                    future: ApiService()
                        .fetchAllPatients(), // Use fetchAllPatients for the dialog
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData) {
                        return const Center(child: Text('No patients found.'));
                      } else {
                        final patients = snapshot.data as List<Patient>;
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: patients.length,
                          itemBuilder: (context, index) {
                            final patient = patients[index];
                            bool isSelected = selectedIndices.contains(index);
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    '${Custom_Config.Image_URL}/${patient.profileImage}'),
                              ),
                              title: Text(
                                  '${patient.firstName} ${patient.lastName}'),
                              trailing: Checkbox(
                                value: isSelected,
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (value == true) {
                                      selectedIndices.add(index);
                                    } else {
                                      selectedIndices.remove(index);
                                    }
                                  });
                                },
                              ),
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    selectedIndices.remove(index);
                                  } else {
                                    selectedIndices.add(index);
                                  }
                                });
                              },
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    // Handle confirm action with selectedIndices
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text('Confirm'),
                ),
              ],
            );
          },
        );
      },
    );
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
            child: _nursePatients.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _nursePatients.length,
                    itemBuilder: (context, index) {
                      final patient = _nursePatients[index];
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
                          subtitle: Text('Status: ${patient.patientStatus}'),
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
                _showDialogList(
                    context); // Show the dialog with fetchAllPatients
              },
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              elevation: 0.0,
              shape: const CircleBorder(),
              tooltip: 'Add Item',
              child: const Icon(Icons.add, size: 25.0),
            )
          : null,
    );
  }
}

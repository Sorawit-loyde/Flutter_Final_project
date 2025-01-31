import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_decubitus/models/patient_model.dart';
import 'package:mobile_app_decubitus/services/patient_service.dart';
import 'package:mobile_app_decubitus/config/config.dart';
import 'package:mobile_app_decubitus/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_app_decubitus/screen/nurse/Nurse_home_content.dart';

class PatientListPage extends StatefulWidget {
  const PatientListPage({super.key});

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
    List<Patient> patients = [];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('เลือกผู้ป่วยที่จะดูแล'),
              content: SizedBox(
                width: double.maxFinite,
                height: 300.0,
                child: Scrollbar(
                  thumbVisibility: true,
                  child: FutureBuilder(
                    future: ApiService().fetchAllPatientsForDropdown(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData) {
                        return const Center(child: Text('No patients found.'));
                      } else {
                        patients = snapshot.data as List<Patient>;
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
                                activeColor:
                                    primaryColor, // Change this to your desired color
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
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    final nurseId = prefs.getString('Uid');
                    if (nurseId != null) {
                      for (int index in selectedIndices) {
                        final patientId = patients[index].id;
                        await ApiService()
                            .assignPatientsToNurse(patientId, nurseId);
                      }
                      Navigator.of(context).pop();
                      await fetchNursePatients();
                    }
                  },
                  child: const Text('ยืนยัน',
                      style: TextStyle(color: primaryColor)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('ยกเลิก',
                      style: TextStyle(color: primaryColor)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<bool> _showDeleteConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('ยืนยันการลบ'),
              content: const Text(
                  'คุณแน่ใจหรือว่าต้องการลบผู้ป่วยคนนี้ออกจากการดูแล'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('ยืนยัน',
                      style: TextStyle(color: primaryColor)),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('ยกเลิก',
                      style: TextStyle(color: primaryColor)),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  void _onDeletePatient(int patientId) async {
    // Show delete confirmation dialog
    bool confirmed = await _showDeleteConfirmationDialog();
    if (confirmed) {
      // Fetch the nurse's ID from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final nurseId = prefs.getString('Uid');
      if (nurseId != null && nurseId.isNotEmpty) {
        await ApiService().deletePatient(patientId, nurseId);
        setState(() {
          _nursePatients.removeWhere((patient) => patient.id == patientId);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor1,
      body: Navigator(onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (context) => Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextField(
                  onChanged: _filterPatients,
                  decoration: InputDecoration(
                    hintText: 'ค้นหาผู้ป่วย...',
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
                      ? Center(
                          child:
                              _filteredPatients.isEmpty && _searchQuery.isEmpty
                                  ? const Text(
                                      'ยังไม่มีผู้ป่วยในการดูแล',
                                    )
                                  : const CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          itemCount: _filteredPatients.length,
                          itemBuilder: (context, index) {
                            final patient = _filteredPatients[index];
                            final String status = patient.patientStatus;

                            // Define the text color based on the status
                            Color statusColor;
                            if (status == 'รอตรวจ') {
                              statusColor = errorColor;
                            } else if (status == 'เรียบร้อย') {
                              statusColor = primaryColor;
                            } else {
                              statusColor = Colors
                                  .black; // Default color for other statuses
                            }

                            return Card(
                              color: tertiaryColor,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 5.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _showFab = false;
                                  });
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NurseHomeContent(
                                        patientId: patient.id,
                                      ),
                                    ),
                                  );
                                },
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        '${Custom_Config.Image_URL}/${patient.profileImage}'),
                                  ),
                                  title: Text(
                                      '${patient.firstName} ${patient.lastName}'),
                                  subtitle: Text(
                                    'Status: $status',
                                    style: TextStyle(color: statusColor),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () =>
                                        _onDeletePatient(patient.id),
                                  ),
                                ),
                              ),
                            );
                          },
                        )),
            ],
          ),
        );
      }),
      floatingActionButton: (_showFab
          ? FloatingActionButton(
              onPressed: () {
                _showDialogList(context);
              },
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              elevation: 0.0,
              shape: const CircleBorder(),
              tooltip: 'Add Item',
              child: const Icon(Icons.add, size: 25.0),
            )
          : null),
    );
  }
}

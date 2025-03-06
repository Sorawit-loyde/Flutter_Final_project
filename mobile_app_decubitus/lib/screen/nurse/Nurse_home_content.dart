import 'package:flutter/material.dart';
import 'package:mobile_app_decubitus/constant.dart';
import 'package:mobile_app_decubitus/services/perusal_service.dart';
import 'package:mobile_app_decubitus/models/perusal_model.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_decubitus/screen/nurse/Nurse_wound_select_page.dart';
import 'package:mobile_app_decubitus/screen/nurse/Nurse_patient_list.dart';

class NurseHomeContent extends StatefulWidget {
  const NurseHomeContent({super.key, required this.patientId});
  final int patientId;

  @override
  _NurseHomeContentState createState() => _NurseHomeContentState();
}

class _NurseHomeContentState extends State<NurseHomeContent> {
  String _patientName = 'Loading...';
  String _searchQuery = '';
  List<Perusal> _allPerusals = [];
  List<Perusal> _filteredPerusals = [];
  bool _showFab = true;

  @override
  void initState() {
    super.initState();
    fetchPatientName();
    fetchPerusals().then((perusals) {
      setState(() {
        _allPerusals = perusals;
        _filteredPerusals = perusals;
      });
    });
  }

  Future<void> fetchPatientName() async {
    try {
      final name = await PerusalService().getPatientName(widget.patientId);
      setState(() {
        _patientName = name;
      });
    } catch (e) {
      setState(() {
        _patientName = 'Unknown';
      });
      print('Error fetching patient name: $e');
    }
  }

  Future<List<Perusal>> fetchPerusals() async {
    final perusalService = PerusalService();
    final perusals = await perusalService.getPerusalsNurse(widget.patientId);
    for (int i = 0; i < perusals.length; i++) {
      perusals[i] =
          perusals[i].copyWith(originalIndex: i + 1); // Set the original index
    }
    return perusals;
  }

  String formatPerusalDate(DateTime date, int originalIndex) {
    return "การตรวจครั้งที่ $originalIndex - ${DateFormat('dd/MM/yyyy').format(date)}";
  }

  void _filterPerusals(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      if (_searchQuery.isEmpty) {
        _filteredPerusals = _allPerusals;
      } else {
        int? searchIndex = int.tryParse(_searchQuery);
        if (searchIndex != null) {
          _filteredPerusals = _allPerusals
              .where((perusal) => perusal.originalIndex == searchIndex)
              .toList();
        } else {
          _filteredPerusals = _allPerusals
              .where((perusal) =>
                  formatPerusalDate(perusal.perusalDate, perusal.originalIndex)
                      .toLowerCase()
                      .contains(_searchQuery))
              .toList();
        }
      }
    });
  }

  void _showAddPerusalDialog() {
    DateTime today = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy').format(today);
    int newIndex = _allPerusals.length + 1;

    String displayText = "การตรวจครั้งที่ $newIndex - $formattedDate";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('เพิ่มรายการตรวจ', style: TextStyle(fontSize: 24)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(displayText, style: const TextStyle(fontSize: 16)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  await PerusalService()
                      .NurseaddPerusal(today, widget.patientId);
                  Navigator.pop(context);
                  fetchUpdatedPerusals();
                } catch (e) {
                  print(e);
                }
              },
              child:
                  const Text('ยืนยัน', style: TextStyle(color: primaryColor)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:
                  const Text('ยกเลิก', style: TextStyle(color: primaryColor)),
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchUpdatedPerusals() async {
    final fetchedPerusals = await fetchPerusals();
    setState(() {
      _allPerusals = fetchedPerusals;
      _filteredPerusals = fetchedPerusals;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor1,
      body: Navigator(
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(
                backgroundColor: backGroundColor1,
                toolbarHeight: 50.0,
                title: Text(_patientName),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      _showFab = false;
                    });
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PatientListPage(),
                      ),
                    );
                  },
                ),
              ),
              backgroundColor: backGroundColor1,
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 14.0),
                    child: TextField(
                      onChanged: _filterPerusals,
                      decoration: InputDecoration(
                        hintText: 'ค้นหาการตรวจ...',
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
                    child: _filteredPerusals.isEmpty
                        ? const Center(
                            child:
                                Text('กดปุ่มเพิ่มขวาล่างเพื่อเพิ่มรายการตรวจ'),
                          )
                        : ListView.separated(
                            itemCount: _filteredPerusals.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final perusal = _filteredPerusals[index];

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _showFab = false;
                                  });
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          NurseWoundSelectPage(
                                        perusalId: perusal.id,
                                        patientId: widget.patientId,
                                      ),
                                    ),
                                  );
                                },
                                child: Card(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  color: tertiaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ListTile(
                                    contentPadding:
                                        const EdgeInsets.fromLTRB(10, 4, 10, 4),
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            formatPerusalDate(
                                                perusal.perusalDate,
                                                perusal.originalIndex),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
              floatingActionButton: (_showFab
                  ? FloatingActionButton(
                      onPressed: () {
                        _showAddPerusalDialog();
                      },
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0.0,
                      shape: const CircleBorder(),
                      tooltip: 'Add Item',
                      child: const Icon(Icons.add, size: 25.0),
                    )
                  : null),
            ),
          );
        },
      ),
    );
  }
}

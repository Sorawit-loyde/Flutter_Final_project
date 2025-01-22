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
    fetchPerusals();
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
    return await perusalService.getPerusalsNurse(widget.patientId);
  }

  Future<void> deletePerusal(int id) async {
    bool confirmDelete = await _showDeleteConfirmationDialog();
    if (confirmDelete) {
      try {
        await PerusalService().deletePerusal(id);
        setState(() {
          _allPerusals.removeWhere((perusal) => perusal.id == id);
          _filteredPerusals = _allPerusals;
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Future<bool> _showDeleteConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('ยืนยันการลบ'),
              content: const Text('คุณแน่ใจหรือว่าต้องการลบรายการตรวจครั้งนี้'),
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

  String formatPerusalDate(DateTime date, int index) {
    return "การตรวจครั้งที่ $index - ${DateFormat('dd/MM/yyyy').format(date)}";
  }

  void _filterPerusals(String query) {
    setState(() {
      _searchQuery = query;
      _filteredPerusals = _searchQuery.isEmpty
          ? _allPerusals
          : _allPerusals
              .where((perusal) =>
                  perusal.perusalDate.toString().contains(_searchQuery))
              .toList();
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
                  await PerusalService().addPerusal(today);
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
                toolbarHeight: 60.0,
                title: Text(_patientName),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PatientListPage()),
                    );
                  },
                ),
              ),
              backgroundColor: backGroundColor1,
              body: Column(
                children: [
                  Expanded(
                    child: FutureBuilder<List<Perusal>>(
                      future: fetchPerusals(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text(
                                  'Error fetching data: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text(
                                  'กดปุ่มเพิ่มขวาล่างเพื่อเพิ่มรายการตรวจ'));
                        } else {
                          _allPerusals = snapshot.data!;
                          _filteredPerusals = _allPerusals;

                          return ListView.separated(
                            itemCount: _filteredPerusals.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 8),
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
                                              patientId: widget.patientId),
                                    ),
                                  );
                                },
                                child: Card(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  color: tertiaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
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
                                                perusal.perusalDate, index + 1),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () {
                                            deletePerusal(perusal.id);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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
    );
  }
}

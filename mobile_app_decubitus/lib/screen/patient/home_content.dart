import 'package:flutter/material.dart';
import 'package:mobile_app_decubitus/constant.dart';
import 'package:mobile_app_decubitus/services/perusal_service.dart';
import 'package:mobile_app_decubitus/models/perusal_model.dart';
import 'package:intl/intl.dart';
import 'wound_select_content.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String _searchQuery = '';
  List<Perusal> _allPerusals = [];
  List<Perusal> _filteredPerusals = [];
  bool _showFab = true;

  @override
  void initState() {
    super.initState();
    fetchPerusals().then((perusals) {
      setState(() {
        _allPerusals = perusals
            .asMap()
            .entries
            .map((entry) => entry.value.copyWith(originalIndex: entry.key))
            .toList();
        _filteredPerusals = _allPerusals;
      });
    });
  }

  Future<List<Perusal>> fetchPerusals() async {
    final perusalService = PerusalService();
    return await perusalService.getPerusals();
  }

  String formatPerusalDate(DateTime date, int index) {
    return "การตรวจครั้งที่ $index - ${DateFormat('dd/MM/yyyy').format(date)}";
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
              .where((perusal) => perusal.originalIndex + 1 == searchIndex)
              .toList();
        } else {
          _filteredPerusals = _allPerusals
              .where((perusal) => formatPerusalDate(
                      perusal.perusalDate, perusal.originalIndex + 1)
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
            builder: (context) => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
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
                          child: Text('กดปุ่มเพิ่มขวาล่างเพื่อเพิ่มรายการตรวจ'),
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
                                    builder: (context) => WoundSelectPage(
                                      perusalId: perusal.id,
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
                                          formatPerusalDate(perusal.perusalDate,
                                              perusal.originalIndex + 1),
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

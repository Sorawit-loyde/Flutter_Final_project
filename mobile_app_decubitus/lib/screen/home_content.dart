import 'package:flutter/material.dart';
import 'package:mobile_app_decubitus/constant.dart';
import 'package:mobile_app_decubitus/services/perusal_service.dart';
import 'package:mobile_app_decubitus/models/perusal_model.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'wound_select_content.dart'; // Import your wound selection page

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String _searchQuery = '';
  List<Perusal> _allPerusals = [];
  List<Perusal> _filteredPerusals = [];
  bool _showFab = true; // Variable to control FAB visibility

  Future<List<Perusal>> fetchPerusals() async {
    final perusalService = PerusalService();
    return await perusalService.getPerusals();
  }

  String formatPerusalDate(DateTime date, int index) {
    return "การตรวจครั้งที่ $index - ${DateFormat('dd/MM/yyyy').format(date)}";
  }

  void _filterPerusals(String query) {
    setState(() {
      _searchQuery = query;
      if (_searchQuery.isEmpty) {
        _filteredPerusals = _allPerusals;
      } else {
        _filteredPerusals = _allPerusals.where((perusal) {
          return perusal.perusalDate.toString().contains(_searchQuery);
        }).toList();
      }
    });
  }

  void _showAddPerusalDialog() {
    // Get today's date
    DateTime today = DateTime.now();
    String formattedDate =
        DateFormat('dd/MM/yyyy').format(today); // Format date

    // Determine the count of existing perusals
    int newIndex = _allPerusals.length + 1; // Index for new entry

    // Create the text to display
    String displayText = "การตรวจครั้งที่ $newIndex - $formattedDate";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'เพิ่มรายการตรวจ',
            style: TextStyle(fontSize: 24), // Adjust font size for title
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                displayText,
                style: const TextStyle(
                    fontSize: 16), // Adjust font size for content
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  await PerusalService()
                      .addPerusal(today); // Save with today's date
                  Navigator.pop(context); // Close the dialog

                  // Refresh the perusals list after adding a new one
                  setState(() {
                    fetchPerusals().then((value) {
                      _allPerusals = value; // Update all perusals
                      _filteredPerusals = _allPerusals; // Reset filtered list
                    });
                  });
                } catch (e) {
                  // Handle error (e.g., show an error message)
                  print(e);
                }
              },
              child: const Text(
                'ยืนยัน',
                style: TextStyle(color: primaryColor),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog without saving
              },
              child: const Text(
                'ยกเลิก',
                style: TextStyle(color: primaryColor),
              ),
            ),
          ],
        );
      },
    );
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
                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: TextField(
                    onChanged: _filterPerusals, // Update filter on text change
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

                // Main Content Area (List)
                Expanded(
                  child: FutureBuilder<List<Perusal>>(
                    future: fetchPerusals(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                            child:
                                Text('Error fetching data: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child:
                                Text('กดปุ่มเพิ่มขวาล่างเพื่อเพิ่มรายการตรวจ'));
                      } else {
                        _allPerusals = snapshot
                            .data!; // Store all fetched perusals in state variable
                        _filteredPerusals =
                            _allPerusals; // Initialize filtered list with all entries

                        return ListView.separated(
                          itemCount: _filteredPerusals.length,
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                                height: 8); // Space between cards
                          },
                          itemBuilder: (context, index) {
                            final perusal = _filteredPerusals[
                                index]; // Get filtered perusal entry

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _showFab = false; // Hide FAB when navigating
                                });
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        WoundSelectPage(perusal: perusal),
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
                                  title: Text(
                                      formatPerusalDate(
                                          perusal.perusalDate, index + 1),
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.black)),
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
          );
        },
      ),
      floatingActionButton: (_showFab
          ? FloatingActionButton(
              onPressed: () {
                _showAddPerusalDialog(); // Show dialog when pressed
              },
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              elevation: 0.0,
              shape: const CircleBorder(),
              tooltip: 'Add Item',
              child: const Icon(Icons.add, size: 25.0),
            )
          : null), // Show FAB only if `_showFab` is true
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

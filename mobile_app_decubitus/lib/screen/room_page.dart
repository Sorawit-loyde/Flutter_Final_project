import 'package:flutter/material.dart';
import 'package:mobile_app_decubitus/constant.dart';
import 'package:mobile_app_decubitus/services/perusal_service.dart';
import 'package:mobile_app_decubitus/models/perusal_model.dart';
import 'package:intl/intl.dart';
import 'wound_select_content.dart';

class RoomPage extends StatefulWidget {
  const RoomPage({super.key});

  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  String _searchQuery = '';
  List<Perusal> _allPerusals = [];
  List<Perusal> _filteredPerusals = [];
  bool _showFab = true;

  @override
  void initState() {
    super.initState();
    fetchPerusals();
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
      _searchQuery = query;
      _filteredPerusals = _searchQuery.isEmpty
          ? _allPerusals
          : _allPerusals
              .where((perusal) =>
                  perusal.perusalDate.toString().contains(_searchQuery))
              .toList();
    });
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
                                        WoundSelectPage(perusalId: perusal.id),
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
          );
        },
      ),
    );
  }
}

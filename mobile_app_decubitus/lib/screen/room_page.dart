import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this import
import 'package:mobile_app_decubitus/constant.dart';
import 'package:mobile_app_decubitus/models/room_model.dart';
import 'package:mobile_app_decubitus/screen/chat_page.dart';
import 'package:mobile_app_decubitus/services/room_service.dart';

class RoomPage extends StatefulWidget {
  const RoomPage({super.key});

  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  List<Room> _allRooms = [];
  List<Room> _filteredRooms = [];
  bool _showFab = true;

  @override
  void initState() {
    super.initState();
    fetchRooms();
  }

  Future<List<Room>> fetchRooms() async {
    final roomService = RoomService();
    return await roomService.getRooms();
  }

  String formatRoomName(String name, int index) {
    DateTime dateTime = DateTime.parse(name);
    String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
    return "ห้องที่ $index - $formattedDate";
  }

  Future<void> fetchUpdatedRooms() async {
    final fetchedRooms = await fetchRooms();
    setState(() {
      _allRooms = fetchedRooms;
      _filteredRooms = fetchedRooms;
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
                const SizedBox(
                    height: 10), // Add this line for 10px space from top
                Expanded(
                  child: FutureBuilder<List<Room>>(
                    future: fetchRooms(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                            child:
                                Text('Error fetching data: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('ไม่มีห้องแชท กรุณาสร้างการตรวจ'));
                      } else {
                        _allRooms = snapshot.data!;
                        _filteredRooms = _allRooms;

                        return ListView.separated(
                          itemCount: _filteredRooms.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final room = _filteredRooms[index];

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _showFab = false;
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Chatroom(roomId: room.id),
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
                                    formatRoomName(room.name, index + 1),
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black),
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

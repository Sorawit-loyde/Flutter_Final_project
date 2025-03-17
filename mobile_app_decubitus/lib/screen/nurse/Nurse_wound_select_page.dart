import 'package:flutter/material.dart';
import 'package:mobile_app_decubitus/constant.dart';
import 'package:mobile_app_decubitus/config/config.dart';
import 'package:mobile_app_decubitus/models/wound_model.dart';
import 'package:mobile_app_decubitus/services/wound_service.dart';
import 'package:mobile_app_decubitus/screen/nurse/Nurse_home_content.dart';
import 'package:mobile_app_decubitus/screen/nurse/Nurse_wound_select_form.dart';
import 'package:mobile_app_decubitus/screen/nurse/Nurse_model_result.dart';

class NurseWoundSelectPage extends StatefulWidget {
  final int perusalId;
  final int patientId;

  const NurseWoundSelectPage(
      {super.key, required this.perusalId, required this.patientId});

  @override
  _NurseWoundSelectPageState createState() => _NurseWoundSelectPageState();
}

class _NurseWoundSelectPageState extends State<NurseWoundSelectPage> {
  late Future<List<WoundGroup>> futureWounds;
  final bool _showFab = true;

  @override
  void initState() {
    super.initState();
    futureWounds = WoundService(Custom_Config.BASE_URL)
        .fetchGroupedWounds(widget.perusalId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backGroundColor1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      NurseHomeContent(patientId: widget.patientId)),
            );
          },
        ),
      ),
      body: Container(
        color: backGroundColor1,
        child: FutureBuilder<List<WoundGroup>>(
          future: futureWounds,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Error fetching data: ${snapshot.error}'),
              );
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                  child: Text('กดปุ่มเพิ่มขวาล่างเพื่อเพิ่มรายการแผล'));
            }

            final woundGroups = snapshot.data!;
            return ListView.builder(
              itemCount: woundGroups.length,
              itemBuilder: (context, index) {
                final group = woundGroups[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 4.0),
                  color: backGroundColor1,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: primaryColor, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                  child: ExpansionTile(
                    title: Text(
                      group.area,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    childrenPadding: const EdgeInsets.symmetric(vertical: 4.0),
                    children: group.wounds.map((wound) {
                      return ListTile(
                        title: Text('แผล ${wound.count}'),
                        subtitle: Text(
                          'สถานะ: ${wound.status}', // Added date formatting
                          style: TextStyle(
                            color: wound.status == 'ตรวจแล้ว'
                                ? primaryColor
                                : errorColor,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            bool shouldDelete =
                                await _showDeleteConfirmationDialog(context);
                            if (shouldDelete) {
                              try {
                                await WoundService(Custom_Config.BASE_URL)
                                    .deleteWound(wound.id);
                                setState(() {
                                  group.wounds.remove(wound);
                                });
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Failed to delete wound: $e')),
                                );
                              }
                            }
                          },
                        ),
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NurseModelResultScreen(
                                woundId: wound.id,
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NurseWoundSelectForm(
                perusalId: widget.perusalId,
                patinetId: widget.patientId,
              ),
            ),
          );
        },
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0.0,
        shape: const CircleBorder(),
        tooltip: 'Add Item',
        child: const Icon(Icons.add, size: 25.0),
      ),
    );
  }

  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('ยืนยันการลบ'),
              content: const Text('คุณแน่ใจหรือว่าต้องการลบรายการแผลนี้'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('ยืนยัน',
                      style: TextStyle(color: primaryColor)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('ยกเลิก',
                      style: TextStyle(color: primaryColor)),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}

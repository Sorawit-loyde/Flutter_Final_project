import 'package:flutter/material.dart';
import 'package:mobile_app_decubitus/models/perusal_model.dart';
import 'package:mobile_app_decubitus/models/wound_model.dart';
import 'package:mobile_app_decubitus/screen/home_content.dart';
import 'package:mobile_app_decubitus/services/wound_service.dart';
import 'package:mobile_app_decubitus/constant.dart';
import 'package:mobile_app_decubitus/config/config.dart';
import 'package:mobile_app_decubitus/screen/wound_select_form.dart';
import 'package:mobile_app_decubitus/screen/model_result_page.dart';

class WoundSelectPage extends StatefulWidget {
  final Perusal perusal;
  const WoundSelectPage({super.key, required this.perusal});

  @override
  _WoundSelectPageState createState() => _WoundSelectPageState();
}

class _WoundSelectPageState extends State<WoundSelectPage> {
  late Future<List<WoundGroup>> futureWounds;

  @override
  void initState() {
    super.initState();
    futureWounds = WoundService(Custom_Config.BASE_URL)
        .fetchGroupedWounds(widget.perusal.id);
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
              MaterialPageRoute(builder: (context) => const HomeContent()),
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
              return const Center(child: Text('No wounds found.'));
            }

            final woundGroups = snapshot.data!;
            return ListView.builder(
              itemCount: woundGroups.length,
              itemBuilder: (context, index) {
                final group = woundGroups[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
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
                    childrenPadding: const EdgeInsets.symmetric(vertical: 8.0),
                    children: group.wounds.map((wound) {
                      return GestureDetector(
                        onTap: () {
                          // Pass the woundId to the ModelResultScreen
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ModelResultScreen(
                                woundId: wound.id, // Pass woundId here
                              ),
                            ),
                          );
                        },
                        child: ListTile(
                          title: Text('แผล ${wound.count}'),
                          subtitle: Text('Status: ${wound.status}'),
                        ),
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
              builder: (context) => WoundSelectForm(
                perusalId: widget.perusal.id,
              ),
            ),
          );
        },
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0.0,
        tooltip: 'Add Wound',
        child: const Icon(Icons.add),
      ),
    );
  }
}

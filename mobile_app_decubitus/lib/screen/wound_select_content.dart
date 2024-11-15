import 'package:flutter/material.dart';
import 'package:mobile_app_decubitus/models/perusal_model.dart';

class WoundSelectPage extends StatelessWidget {
  final Perusal perusal;

  const WoundSelectPage({Key? key, required this.perusal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wound Selection'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Perusal ID: ${perusal.id}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Perusal Date: ${perusal.perusalDate.toLocal()}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            // Add more details or functionality as needed
          ],
        ),
      ),
    );
  }
}

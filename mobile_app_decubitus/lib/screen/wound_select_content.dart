import 'package:flutter/material.dart';
import 'package:mobile_app_decubitus/models/perusal_model.dart';

class WoundSelectPage extends StatelessWidget {
  final Perusal perusal;

  const WoundSelectPage({super.key, required this.perusal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wound Selection'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Perusal ID: ${perusal.id}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Perusal Date: ${perusal.perusalDate.toLocal()}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            // Add more details or functionality as needed
          ],
        ),
      ),
    );
  }
}

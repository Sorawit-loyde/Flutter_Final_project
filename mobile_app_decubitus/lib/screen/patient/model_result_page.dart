import 'package:flutter/material.dart';
import 'package:mobile_app_decubitus/constant.dart';
import 'package:mobile_app_decubitus/models/diagnosis_model.dart';
import 'package:mobile_app_decubitus/services/diagnosis_service.dart';
import 'package:mobile_app_decubitus/config/config.dart';
import 'package:mobile_app_decubitus/screen/patient/wound_select_content.dart';
import 'package:intl/intl.dart';

class ModelResultScreen extends StatefulWidget {
  final int woundId;

  const ModelResultScreen({super.key, required this.woundId});

  @override
  _ModelResultScreenState createState() => _ModelResultScreenState();
}

class _ModelResultScreenState extends State<ModelResultScreen> {
  late Future<Diagnosis> diagnosis;

  @override
  void initState() {
    super.initState();
    diagnosis = DiagnosisService().fetchDiagnosis(widget.woundId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backGroundColor1,
      appBar: AppBar(
        backgroundColor: backGroundColor1,
        elevation: 0,
        toolbarHeight: 40,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            diagnosis.then((data) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      WoundSelectPage(perusalId: data.perusalId),
                ),
              );
            });
          },
        ),
      ),
      body: FutureBuilder<Diagnosis>(
        future: diagnosis,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDateSection(data.createdAt),
                  const SizedBox(height: 20),
                  _buildStatusSection(
                      data.woundStatus), // Updated to use woundStatus
                  const SizedBox(height: 20),
                  _buildImageSection(data.woundImage),
                  const SizedBox(height: 20),
                  _buildDescriptionSection(data.description),
                  const SizedBox(height: 20),
                  _buildTreatmentSteps(data.treat),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }

  Widget _buildDateSection(String date) {
    DateTime dateTime = DateTime.parse(date);
    String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'วันที่สร้างรายการ:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              formattedDate,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusSection(String status) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'สถานะ:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              status,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageSection(String woundImage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'รูปแผลกดทับ:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          height: 200, // Adjust the height as needed
          decoration: BoxDecoration(
            border: Border.all(color: primaryColor, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              '${Custom_Config.Image_URL}/$woundImage',
              fit: BoxFit
                  .contain, // Ensures the entire image fits within the box
              errorBuilder: (context, error, stackTrace) {
                return const Center(child: Text('Image not available'));
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'แผลระดับ: ',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          description,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildTreatmentSteps(List<Treatment> steps) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'แนวทางการรักษาเบื้องต้น:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 10),
        ...steps.map((step) => _buildTreatmentStep(step.description)),
      ],
    );
  }

  Widget _buildTreatmentStep(String step) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle, color: Colors.green, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            step,
            style: const TextStyle(
              fontSize: 16,
              color: primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}

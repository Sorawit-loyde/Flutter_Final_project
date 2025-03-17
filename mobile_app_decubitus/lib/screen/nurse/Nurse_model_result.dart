import 'package:flutter/material.dart';
import 'package:mobile_app_decubitus/constant.dart';
import 'package:mobile_app_decubitus/models/diagnosis_model.dart';
import 'package:mobile_app_decubitus/services/diagnosis_service.dart';
import 'package:mobile_app_decubitus/config/config.dart';
import 'package:mobile_app_decubitus/screen/Nurse/Nurse_wound_select_page.dart';
import 'package:intl/intl.dart';
import 'Nurse_model_edit.dart';

class NurseModelResultScreen extends StatefulWidget {
  final int woundId;

  const NurseModelResultScreen({super.key, required this.woundId});

  @override
  _NurseModelResultScreen createState() => _NurseModelResultScreen();
}

class _NurseModelResultScreen extends State<NurseModelResultScreen> {
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
                  builder: (context) => NurseWoundSelectPage(
                      perusalId: data.perusalId, patientId: data.patientId),
                ),
              );
            });
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: primaryColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      NurseModelResultEditScreen(woundId: widget.woundId),
                ),
              );
            },
          ),
        ],
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
                  const SizedBox(height: 10),
                  _buildStatusSection(data.woundStatus),
                  const SizedBox(height: 10),
                  _buildImageSection(data.woundImage),
                  const SizedBox(height: 10),
                  _buildDescriptionSection(data.description, data.state),
                  const SizedBox(height: 10),
                  _buildTreatmentSteps(data.treat),
                  const SizedBox(height: 10),
                  if (data.woundStatus == "ตรวจแล้ว")
                    _buildCommentBox(data.remark),
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
          'วันที่สร้างรายการ: ',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 10),
        Container(
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
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: primaryColor, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              '${Custom_Config.Image_URL}/$woundImage',
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                return const Center(child: Text('Image not available'));
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(String description, int state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'แผลระดับ: $state',
          style: const TextStyle(
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
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: steps.length,
          itemBuilder: (context, index) {
            return _buildTreatmentStep(steps[index].description);
          },
        ),
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

  Widget _buildCommentBox(String? remark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ความคิดเห็น:',
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
          child: Text(
            remark ?? 'ไม่มีความคิดเห็น',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}

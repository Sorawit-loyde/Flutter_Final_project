import 'package:flutter/material.dart';
import 'package:mobile_app_decubitus/constant.dart';
import 'package:mobile_app_decubitus/models/diagnosis_model.dart';
import 'package:mobile_app_decubitus/services/diagnosis_service.dart';
import 'package:mobile_app_decubitus/config/config.dart';
import 'package:mobile_app_decubitus/screen/nurse/Nurse_model_result.dart';
import 'package:intl/intl.dart';

class NurseModelResultEditScreen extends StatefulWidget {
  final int woundId;

  const NurseModelResultEditScreen({super.key, required this.woundId});

  @override
  _NurseModelResultEditScreen createState() => _NurseModelResultEditScreen();
}

class _NurseModelResultEditScreen extends State<NurseModelResultEditScreen> {
  late Future<Diagnosis> diagnosis;
  final TextEditingController _remarkController = TextEditingController();
  int _woundState = 1; // Default wound state
  int _persualId = 1;
  String _selectedWoundState = 'แผลระดับ: 1'; // Default selected value

  @override
  void initState() {
    super.initState();
    diagnosis = DiagnosisService().fetchDiagnosis(widget.woundId).then((data) {
      setState(() {
        _selectedWoundState = 'แผลระดับ: ${data.state}';
        _woundState = data.state;
        _persualId = data.perusalId;
      });
      return data;
    });
  }

  @override
  void dispose() {
    _remarkController.dispose();
    super.dispose();
  }

  Future<void> _updateDiagnosis() async {
    try {
      await DiagnosisService().updateDiagnosis(
        woundId: widget.woundId,
        woundState: _woundState,
        remark: _remarkController.text,
      );

      await DiagnosisService().joinRoomwithPerusal(_persualId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Diagnosis updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update diagnosis: $e')),
      );
    }
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
                      NurseModelResultScreen(woundId: widget.woundId),
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
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          } else {
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
                  _buildCommentBox(),
                  const SizedBox(height: 10),
                  _buildUpdateButton(),
                ],
              ),
            );
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
          'สถานะ: ',
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
          'รูปแผลกดทับ: ',
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
        _buildWoundLevelDropdown(),
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
          'แนวทางการรักษาเบื้องต้น: ',
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

  Widget _buildCommentBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ความคิดเห็น: ',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _remarkController,
          decoration: InputDecoration(
            hintText: 'ความคิดเห็นเพิ่มเติม',
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.grey[200],
          ),
          maxLines: 4,
        ),
      ],
    );
  }

  Widget _buildWoundLevelDropdown() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: _selectedWoundState,
            items: const [
              DropdownMenuItem(
                  value: 'แผลระดับ: 1',
                  child: Text('แผลระดับ 1', style: TextStyle(fontSize: 20))),
              DropdownMenuItem(
                  value: 'แผลระดับ: 2',
                  child: Text('แผลระดับ 2', style: TextStyle(fontSize: 20))),
              DropdownMenuItem(
                  value: 'แผลระดับ: 3',
                  child: Text('แผลระดับ 3', style: TextStyle(fontSize: 20))),
              DropdownMenuItem(
                  value: 'แผลระดับ: 4',
                  child: Text('แผลระดับ 4', style: TextStyle(fontSize: 20))),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedWoundState = value;
                  _woundState =
                      int.parse(value.split(': ')[1]); // Convert to int
                  print("wound state selected: $_selectedWoundState");
                });
              }
            },
            style: const TextStyle(color: Colors.white, fontSize: 16),
            dropdownColor: primaryColor,
            underline: Container(),
            iconEnabledColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildUpdateButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          await _updateDiagnosis();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  NurseModelResultScreen(woundId: widget.woundId),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          side: const BorderSide(color: primaryColor, width: 2),
        ),
        child: const Text(
          'รายงานผลการตรวจ',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

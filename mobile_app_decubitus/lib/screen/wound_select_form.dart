import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:mobile_app_decubitus/constant.dart'; // Import your constants file
import 'package:dropdown_button2/dropdown_button2.dart'; // Import DropdownButton2
import 'package:mobile_app_decubitus/models/wound_model.dart'; // Import your wound model
import 'package:mobile_app_decubitus/services/wound_service.dart'; // Import your wound service
import 'package:mobile_app_decubitus/config/config.dart';
import 'package:mobile_app_decubitus/models/user_model.dart';

class WoundSelectForm extends StatefulWidget {
  final int perusalId; // Add perusal ID as a parameter

  const WoundSelectForm(
      {super.key, required this.perusalId}); // Update constructor

  @override
  _WoundSelectFormState createState() => _WoundSelectFormState();
}

class _WoundSelectFormState extends State<WoundSelectForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  String? selectedLocation;
  String? selectedOldWound;
  bool isNewWound = false;
  XFile? imageFile;

  final List<String> locations = ['หัว', 'แขน', 'หลัง', 'ขา', 'ก้น', 'เท้า'];

  // This will hold the list of old wounds fetched from the backend
  List<Wound> oldWoundsList = [];

  @override
  void initState() {
    super.initState();
    // Fetch old wounds when the form initializes
    _fetchOldWounds();
  }

  Future<void> _fetchOldWounds() async {
    try {
      WoundService service =
          WoundService(Custom_Config.BASE_URL); // Your base URL
      oldWoundsList = await service.fetchOldWounds(widget.perusalId,
          "หัว"); // Replace "หัว" with the appropriate area if needed
      setState(() {}); // Update UI after fetching data
    } catch (e) {
      print('Error fetching old wounds: $e');
    }
  }

  Future<void> _selectImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await showModalBottomSheet<XFile>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          height: MediaQuery.of(context).size.height * 0.21,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text('เลือกแหล่งที่มาของภาพ',
                  style: TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('เปิดกล้อง'),
                onTap: () async {
                  Navigator.of(context)
                      .pop(await picker.pickImage(source: ImageSource.camera));
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('เลือกจากแกลเลอรี'),
                onTap: () async {
                  Navigator.of(context)
                      .pop(await picker.pickImage(source: ImageSource.gallery));
                },
              ),
            ],
          ),
        );
      },
    );

    if (pickedFile != null) {
      setState(() {
        imageFile = pickedFile;
      });
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      // Create a new Wound object using the perusalId passed from the previous page
      Wound newWound = Wound(
        id: 0, // Set to a default value; backend will generate this ID
        perusalId: widget.perusalId, // Use the passed perusalId
        woundImage:
            imageFile?.path ?? '', // Ensure you handle image paths correctly
        area: selectedLocation ?? '',
        status: 'รอตรวจ', // Default status or based on user input
        woundType:
            isNewWound ? "แผลใหม่" : "แผลเก่า", // Set based on user selection
        woundRef: selectedOldWound != null
            ? int.parse(selectedOldWound!)
            : null, // Use null for no reference when creating a new wound.
      );

      print('Submitting Wound: ${newWound.toJson()}'); // Debug print

      try {
        await WoundService(Custom_Config.BASE_URL).createWound(newWound);
        print('Wound submitted successfully');
        // Optionally, navigate back or show success message
      } catch (e) {
        print('Error submitting wound: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wound Information'),
        backgroundColor: backGroundColor1,
      ),
      body: Container(
        color: backGroundColor1,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'วันที่สร้างรายการ : ${selectedDate?.toLocal().toString().split(' ')[0] ?? DateTime.now().toLocal().toString().split(' ')[0]}',
                  style: const TextStyle(fontSize: 18),
                ),
                GestureDetector(
                  onTap: _selectImage,
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: primaryColor),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: imageFile != null
                          ? Image.file(File(imageFile!.path), fit: BoxFit.cover)
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt, size: 50),
                                const SizedBox(height: 10),
                                const Text(
                                    'กดเพื่อถ่ายรูปแผลหรืออัปโหลดรูปจากเครื่อง',
                                    style: TextStyle(fontSize: 16)),
                              ],
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('ตำแหน่งของแผลบนร่างกาย',
                    style: TextStyle(fontSize: 16)),
                DropdownButtonFormField2<String>(
                  value: selectedLocation,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: backGroundColor1,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: tertiaryColor)),
                  ),
                  hint: Text('เลือกตำแหน่งแผล',
                      style: TextStyle(color: Colors.grey[600])),
                  items: locations.map((location) {
                    return DropdownMenuItem<String>(
                      value: location,
                      child:
                          Text(location, style: const TextStyle(fontSize: 16)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedLocation = value;
                    });
                  },
                  isExpanded: true,
                ),
                const SizedBox(height: 20),
                const Text('กรุณาเลือกประเภทแผล:',
                    style: TextStyle(fontSize: 18)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: isNewWound,
                          activeColor: primaryColor,
                          onChanged: (value) {
                            setState(() {
                              isNewWound = value!;
                            });
                          },
                        ),
                        const Expanded(child: Text('ใช่, แผลในรูปเป็นแผลใหม่')),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          value: !isNewWound,
                          activeColor: primaryColor,
                          onChanged: (value) {
                            setState(() {
                              isNewWound = !value!;
                            });
                          },
                        ),
                        const Expanded(
                            child: Text(
                                'ไม่ใช่, แผลในรูปเป็นแผลที่เคยมีการบันทึกในแอปแล้ว')),
                      ],
                    ),
                  ],
                ),
                if (!isNewWound) ...[
                  const SizedBox(height: 20),
                  const Text('หากเป็นแผลเก่า ท่านต้องการจะอัพเดทแผลต่อจากแผลใด',
                      style: TextStyle(fontSize: 16)),
                  DropdownButtonFormField2<String>(
                    value: selectedOldWound,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: backGroundColor1,
                      border: OutlineInputBorder(),
                      hintText: 'เลือกแผล',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: tertiaryColor)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: primaryColor)),
                    ),
                    items: oldWoundsList.map((wound) {
                      // Use fetched list of old wounds here
                      return DropdownMenuItem<String>(
                        value: wound.id.toString(), // Use the wound ID as value
                        child: Text('แผล ID ${wound.id}',
                            style: const TextStyle(fontSize: 16)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedOldWound = value;
                      });
                    },
                    isExpanded: true,
                  ),
                ],
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: tertiaryColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32.0, vertical: 16.0),
                        textStyle: const TextStyle(
                            fontSize: 18, color: backGroundColor1),
                      ),
                      child: const Text('ยืนยันข้อมูลเพื่อส่งประมวลผล'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

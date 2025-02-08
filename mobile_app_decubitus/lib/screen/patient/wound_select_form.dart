import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:mobile_app_decubitus/constant.dart'; // Import your constants file
import 'package:dropdown_button2/dropdown_button2.dart'; // Import DropdownButton2
import 'package:mobile_app_decubitus/models/wound_model.dart'; // Import your wound model
import 'package:mobile_app_decubitus/services/wound_service.dart'; // Import your wound service
import 'package:mobile_app_decubitus/config/config.dart';
import 'package:mobile_app_decubitus/screen/patient/model_result_page.dart';

class WoundSelectForm extends StatefulWidget {
  final int perusalId;
  final WoundService _woundService = WoundService(Custom_Config.BASE_URL);

  WoundSelectForm({
    super.key,
    required this.perusalId,
  });

  @override
  _WoundSelectFormState createState() => _WoundSelectFormState();
}

class _WoundSelectFormState extends State<WoundSelectForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  String? selectedLocation; // Selected location from dropdown
  String? selectedOldWound; // Selected old wound reference
  bool isNewWound = false; // Flag for new or old wound
  XFile? imageFile; // Image file for the wound
  final List<String> locations = ['หัว', 'แขน', 'หลัง', 'ขา', 'ก้น', 'เท้า'];
  List<Wound> oldWoundsList = []; // List to hold old wounds
  int? userId; // User ID (changed to int for consistency)

  @override
  void initState() {
    super.initState();
    _fetchUserId(); // Fetch user ID on initialization
  }

  Future<void> _fetchUserId() async {
    try {
      userId = (await widget._woundService.getId());
      if (userId != null) {
        print('Fetched User ID: $userId'); // Log the user ID
        await _fetchOldWounds(); // Fetch old wounds after getting user ID
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user ID: $e')),
      );
    }
  }

  Future<void> _fetchOldWounds() async {
    try {
      if (selectedLocation != null) {
        oldWoundsList = await widget._woundService
            .fetchOldWounds(userId!, selectedLocation!);
        print(userId);
        print(selectedLocation!);
        setState(() {});
      }
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
        imageFile = pickedFile; // Set selected image file
      });
    }
  }

// Widget to display the selected image with BoxFit.contain
  Widget _buildImagePreview() {
    if (imageFile != null) {
      return Container(
        width: double.infinity,
        height: 200, // Adjust the height as needed
        decoration: BoxDecoration(
          border: Border.all(color: primaryColor, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            File(imageFile!.path),
            fit: BoxFit.contain, // Ensures the image fits within the box
            errorBuilder: (context, error, stackTrace) {
              return const Center(child: Text('Image not available'));
            },
          ),
        ),
      );
    } else {
      return const SizedBox.shrink(); // Or some placeholder
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      int? woundRef;
      String? uploadedImagePath;

      // Upload the image
      if (imageFile != null) {
        try {
          uploadedImagePath =
              await widget._woundService.uploadImageFromPath(imageFile!.path);
          if (uploadedImagePath == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to upload image.')),
            );
            return;
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error uploading image: $e')),
          );
          return;
        }
      }

      // Handle old wound reference
      if (!isNewWound && selectedOldWound != null) {
        final selectedWound = oldWoundsList.firstWhere(
          (wound) => wound.id.toString() == selectedOldWound,
        );
        woundRef = selectedWound.woundRef ?? selectedWound.id;
      }

      // Create new wound object
      Wound newWound = Wound(
        id: 0,
        perusalId: widget.perusalId,
        woundImage: uploadedImagePath ?? '',
        area: selectedLocation ?? '',
        status: 'รอตรวจ',
        woundType: isNewWound ? "แผลใหม่" : "แผลเก่า",
        woundRef: isNewWound ? null : woundRef,
        count: 0,
      );

      try {
        final woundId = await widget._woundService.createWound(newWound);
        if (woundId != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ModelResultScreen(woundId: woundId),
            ),
          );
        } else {
          throw Exception('Failed to retrieve wound ID.');
        }
      } catch (e) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backGroundColor1,
      child: Scaffold(
        backgroundColor:
            Colors.transparent, // Make Scaffold background transparent
        appBar: AppBar(
          title: const Text('ข้อมูลแผล'),
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
                            ? Image.file(File(imageFile!.path),
                                fit: BoxFit.contain)
                            : const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.camera_alt, size: 50),
                                  SizedBox(height: 10),
                                  Text(
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
                          borderSide: const BorderSide(color: tertiaryColor)),
                    ),
                    hint: Text('เลือกตำแหน่งแผล',
                        style: TextStyle(color: Colors.grey[600])),
                    items: locations.map((location) {
                      return DropdownMenuItem<String>(
                        value: location,
                        child: Text(location,
                            style: const TextStyle(fontSize: 16)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedLocation = value;
                        _fetchOldWounds(); // Fetch old wounds when location is selected
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
                      Row(children: [
                        Checkbox(
                            value: isNewWound,
                            activeColor: primaryColor,
                            onChanged: (value) {
                              setState(() {
                                isNewWound = value!;
                              });
                            }),
                        const Expanded(child: Text('ใช่, แผลในรูปเป็นแผลใหม่')),
                      ]),
                      Row(children: [
                        Checkbox(
                            value: !isNewWound,
                            activeColor: primaryColor,
                            onChanged: (value) {
                              setState(() {
                                isNewWound = !value!;
                              });
                            }),
                        const Expanded(
                            child: Text(
                                'ไม่ใช่, แผลในรูปเป็นแผลที่เคยมีการบันทึกในแอปแล้ว')),
                      ]),
                    ],
                  ),
                  if (!isNewWound) ...[
                    const SizedBox(height: 20),
                    const Text(
                        'หากเป็นแผลเก่า ท่านต้องการจะอัพเดทแผลต่อจากแผลใด',
                        style: TextStyle(fontSize: 16)),
                    DropdownButtonFormField2<String>(
                      value: selectedOldWound,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: backGroundColor1,
                        border: const OutlineInputBorder(),
                        hintText: 'เลือกแผล',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: tertiaryColor)),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: primaryColor)),
                      ),
                      items: oldWoundsList.map((wound) {
                        return DropdownMenuItem<String>(
                          value: wound.id.toString(),
                          child: Text('แผล ${wound.count}',
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
      ),
    );
  }
}

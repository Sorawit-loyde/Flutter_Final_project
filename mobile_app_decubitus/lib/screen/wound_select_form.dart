import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_app_decubitus/config/config.dart';
import 'dart:io';
import 'package:mobile_app_decubitus/constant.dart'; // Import your constants file
import 'package:dropdown_button2/dropdown_button2.dart'; // Import DropdownButton2
import 'package:mobile_app_decubitus/services/wound_service.dart'; // Import WoundService

class WoundSelectForm extends StatefulWidget {
  const WoundSelectForm({super.key});

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

  final List<String> locations = ['Location1', 'Location2', 'Location3'];
  final List<String> oldWounds = ['Old Wound1', 'Old Wound2', 'Old Wound3'];

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

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      print('Form submitted');

      if (imageFile != null) {
        // Instantiate WoundService
        final woundService = WoundService(Custom_Config.BASE_URL);

        // Upload the image and get the response
        String? uploadedImagePath =
            await woundService.uploadImageFromPath(imageFile!.path);

        if (uploadedImagePath != null) {
          print('Image uploaded successfully! Path: $uploadedImagePath');
          // Handle successful upload (e.g., show a success message, navigate, etc.)
        } else {
          print('Failed to upload image.');
          // Handle upload failure (e.g., show an error message)
        }
      } else {
        print('No image selected.');
        // Handle case where no image is selected
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

                // Using DropdownButton2 for Location selection
                DropdownButtonFormField2<String>(
                  value: selectedLocation,
                  decoration: const InputDecoration(
                    filled: true, // Fill color
                    fillColor: backGroundColor1, // Background color
                    border: OutlineInputBorder(),
                    hintText: 'เลือกส่วนที่เป็นแผล',
                    hintStyle: TextStyle(color: greyColor3), // Hint text color
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: tertiaryColor)), // Default border color
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: primaryColor)), // Focused border color
                  ),

                  items: locations.map((location) {
                    return DropdownMenuItem<String>(
                      value: location,
                      child: Text(location,
                          style: const TextStyle(
                              fontSize: 16)), // Customize text style
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedLocation = value;
                    });
                  },
                  isExpanded: true, // Ensure it takes full width
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
                    decoration: const InputDecoration(
                      filled: true, // Fill color
                      fillColor: backGroundColor1, // Background color
                      border: OutlineInputBorder(),
                      hintText: 'เลือกแผล',
                      hintStyle:
                          TextStyle(color: greyColor3), // Hint text color
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: tertiaryColor)), // Default border color
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: primaryColor)), // Focused border color
                    ),
                    items: oldWounds.map((wound) {
                      return DropdownMenuItem<String>(
                        value: wound,
                        child: Text(wound,
                            style: const TextStyle(
                                fontSize: 16)), // Customize text style
                      );
                    }).toList(),

                    onChanged: (value) {
                      setState(() {
                        selectedOldWound = value;
                      });
                    },
                    isExpanded: true, // Ensure it takes full width
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
                            fontSize: 18,
                            color:
                                backGroundColor1), // Set text color to background color
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

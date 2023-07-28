import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:speedo/view/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({
    Key? key,
  }) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  // Get image from camera
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  Future<void> getImage(ImageSource camera) async {
    final XFile? image = await _picker.pickImage(
      maxWidth: 150,
      maxHeight: 200,
      source: camera,
    );

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('name', nameController.text);
    prefs.setString('phone', phoneController.text);
  }

  Future<void> _clearProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('name');
    prefs.remove('phone');
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.green,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Center(
                    child: Text(
                      "Personal Information",
                      style: TextStyle(
                        fontSize: 28,
                        height: 1.8,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.2,
                    child: const Stack(
                      children: [
                        // Your image display code
                      ],
                    ),
                  ),
                  Container(
                    height: 15,
                  ),
                  CupertinoTextField(
                    controller: nameController,
                    placeholder: "Name",
                    keyboardType: TextInputType.text,
                    clearButtonMode: OverlayVisibilityMode.editing,
                    textInputAction: TextInputAction.next,
                  ),
                  Container(
                    height: 14,
                  ),
                  CupertinoTextField(
                    controller: phoneController,
                    placeholder: "Phone Number",
                    keyboardType: TextInputType.phone,
                    clearButtonMode: OverlayVisibilityMode.editing,
                    textInputAction: TextInputAction.next,
                  ),
                  Container(
                    height: 14,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Obx(
                          () => CupertinoButton(
                            color: Colors.green,
                            minSize: 48,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Add your loading indicator widget here if needed
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Submit',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            onPressed: () async {
                              // Check for empty fields
                              if (nameController.text.isEmpty ||
                                  phoneController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Please fill all required fields',
                                    ),
                                  ),
                                );
                              } else {
                                await _saveProfileData();
                                Get.offAll(() => const HomePage());
                              }
                            },
                          ),
                        ),
                      ],
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

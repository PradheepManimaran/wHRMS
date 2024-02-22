import 'package:flutter/material.dart';

import 'package:wHRMS/ThemeColor/theme.dart';
import 'package:wHRMS/apiHandlar/editApi.dart';

import 'package:shared_preferences/shared_preferences.dart';

class IdentityScreen extends StatefulWidget {
  const IdentityScreen({super.key});

  @override
  State<IdentityScreen> createState() => _IdentityScreenState();
}

class _IdentityScreenState extends State<IdentityScreen> {
  TextEditingController uanController = TextEditingController();
  TextEditingController panController = TextEditingController();
  TextEditingController workNumberController = TextEditingController();
  TextEditingController personalNumberController = TextEditingController();
  TextEditingController personalEmailController = TextEditingController();
  TextEditingController presentAddressLine1Controller = TextEditingController();

  int currentSection = 1;
  bool isLastSection = false;

  @override
  void initState() {
    super.initState();
    _loadIdentityData();
  }

  Future<void> _loadIdentityData() async {
    try {
      String? token = await PersonalApi.getAuthToken();

      if (token == null) {
        print('Token not found in shared preferences');
        return;
      }

      List<Map<String, dynamic>>? personalData =
          await PersonalApi.getPersonalInformation(token);

      if (personalData != null && personalData.isNotEmpty) {
        setState(() {
          Map<String, dynamic> latestPersonalData = personalData.last;
          uanController.text = latestPersonalData['uan'] ?? '';
          panController.text = latestPersonalData['pan'] ?? '';
          workNumberController.text = latestPersonalData['working_phone'] ?? '';
          personalNumberController.text =
              latestPersonalData['personal_phone'] ?? '';
          personalEmailController.text =
              latestPersonalData['personal_email'] ?? '';
          presentAddressLine1Controller.text =
              latestPersonalData['address'] ?? '';
        });
      }
    } catch (e) {
      print('Error loading identity data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: ThemeColor.app_bar,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 8.0),
        child: Center(
          child: Column(
            children: [
              _buildProfileFields(),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: 340.0,
                  height: 60.0,
                  child: ElevatedButton(
                    onPressed: () {
                      _nextSection();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      backgroundColor: ThemeColor.btn_color,
                    ),
                    child: Text(
                      isLastSection ? 'Submit' : 'Next',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  void _nextSection() async {
    try {
      Map<String, dynamic> personalInformationData = {
        'uan': uanController.text,
        'pan': panController.text,
        'working_phone': workNumberController.text,
        'personal_phone': personalNumberController.text,
        'personal_email': personalEmailController.text,
        'address': presentAddressLine1Controller.text,
      };

      await PersonalApi.personalInformationData(
          personalInformationData, context);
    } catch (e) {
      print('Error updating personal information: $e');
    }
  }

  Widget _buildProfileFields() {
    switch (currentSection) {
      case 1:
        return _buildPersonalInformationFields();

      default:
        return Container();
    }
  }

  Widget _buildPersonalInformationFields() {
    return Column(
      children: [
        const SizedBox(height: 15),
        const Align(
          alignment: Alignment.center,
          child: Text(
            'Identity Information',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            textAlign: TextAlign.start,
          ),
        ),
        const SizedBox(height: 15),
        _buildTextField(
          hintText: 'UAN Number',
          prefixIconData: Icons.pin,
          controller: uanController,
        ),
        const SizedBox(height: 15),
        _buildTextField(
          hintText: 'PAN Number',
          prefixIconData: Icons.pin,
          controller: panController,
        ),
        const SizedBox(height: 15),
        _buildTextField(
          hintText: 'Working Num',
          prefixIconData: Icons.pin,
          controller: workNumberController,
        ),
        const SizedBox(height: 15),
        _buildTextField(
          hintText: 'Personal Number',
          prefixIconData: Icons.pin,
          controller: personalNumberController,
        ),
        const SizedBox(height: 15),
        _buildTextField(
          hintText: 'Personal Email',
          prefixIconData: Icons.pin,
          controller: personalEmailController,
        ),
        const SizedBox(height: 15),
        _buildTextField(
          controller: presentAddressLine1Controller,
          hintText: 'Address Line 1',
          prefixIconData: Icons.person,
        ),
      ],
    );
  }

  Widget _buildTextField({
    TextEditingController? controller,
    String hintText = 'Enter text here',
    IconData? prefixIconData,
  }) {
    return Center(
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(prefixIconData),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(
              color: Colors.black,
              width: 2.0,
            ),
          ),
          filled: true,
          fillColor: ThemeColor.TextFieldColor,
        ),
      ),
    );
  }
}

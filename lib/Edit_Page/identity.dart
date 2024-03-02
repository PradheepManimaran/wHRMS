import 'package:flutter/material.dart';
import 'package:wHRMS/CSC/csc_picker.dart';

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

  String? selectedCountry;
  String? selectedState;
  String? selectedCity;

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
      // String address = presentAddressLine1Controller.text;
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
      final String address = presentAddressLine1Controller.text;
      Map<String, dynamic> personalInformationData = {
        'uan': uanController.text,
        'pan': panController.text,
        'working_phone': workNumberController.text,
        'personal_phone': personalNumberController.text,
        'personal_email': personalEmailController.text,
        'address': '$address,$selectedCity,$selectedState,$selectedCountry',
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
          prefixIconData: Icons.pan_tool,
          controller: panController,
        ),
        const SizedBox(height: 15),
        _buildTextField(
          hintText: 'Working Num',
          prefixIconData: Icons.pin_drop_outlined,
          controller: workNumberController,
        ),
        const SizedBox(height: 15),
        _buildTextField(
          hintText: 'Personal Number',
          prefixIconData: Icons.phone_android,
          controller: personalNumberController,
        ),
        const SizedBox(height: 15),
        _buildTextField(
          hintText: 'Personal Email',
          prefixIconData: Icons.email_outlined,
          controller: personalEmailController,
        ),
        const SizedBox(height: 15),
        _buildTextField(
          controller: presentAddressLine1Controller,
          hintText: 'Address Line 1',
          prefixIconData: Icons.person,
        ),
        const SizedBox(height: 15),
        CSCPicker(
          showStates: true,
          showCities: true,
          flagState: CountryFlag.DISABLE,
          dropdownDecoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(3)),
            color: Colors.grey.withOpacity(0),
            border: Border.all(
              color: Colors.grey.withOpacity(0.5),
              width: 1.0,
            ),
          ),
          disabledDropdownDecoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(3)),
            color: Colors.grey.withOpacity(0.0),
            border: Border.all(
              color: Colors.grey.withOpacity(0.5),
              width: 1.0,
            ),
          ),
          countrySearchPlaceholder: "Country",
          stateSearchPlaceholder: "State",
          citySearchPlaceholder: "City",
          countryDropdownLabel: "Country",
          stateDropdownLabel: "State",
          cityDropdownLabel: "City",
          selectedItemStyle: TextStyle(
            height: 3,
            color: Colors.black.withOpacity(0.7),
            fontSize: 14,
          ),
          dropdownHeadingStyle: const TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
          dropdownItemStyle: const TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
          dropdownDialogRadius: 10.0,
          searchBarRadius: 10.0,
          onCountryChanged: (value) {
            setState(() {
              selectedCountry = value;
            });
          },
          onStateChanged: (value) {
            setState(() {
              selectedState = value;
            });
          },
          onCityChanged: (value) {
            setState(() {
              selectedCity = value;
            });
          },
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
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
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

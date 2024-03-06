import 'package:flutter/material.dart';
import 'package:wHRMS/ThemeColor/theme.dart';
import 'package:wHRMS/apiHandlar/editApi.dart';

class FamilyEditScreen extends StatefulWidget {
  final Map<String, dynamic> familyData;
  const FamilyEditScreen({super.key, required this.familyData});

  @override
  State<FamilyEditScreen> createState() => _FamilyEditScreenState();
}

class _FamilyEditScreenState extends State<FamilyEditScreen> {
  TextEditingController nominenameController = TextEditingController();
  TextEditingController relationshipController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController nomineaddressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadIdentityData();
    // _companyData();
  }

  Future<void> _loadIdentityData() async {
    try {
      String? token = await FamilyApi.getAuthToken();

      if (token == null) {
        print('Token not found in shared preferences');
        return;
      }

      List<Map<String, dynamic>>? familyData = await FamilyApi.getFamily(token);
      print('Response Data: $familyData');
      if (familyData != null && familyData.isNotEmpty) {
        setState(() {
          Map<String, dynamic> latestPersonalData = familyData.last;
          nominenameController.text = latestPersonalData['name'] ?? '';
          relationshipController.text =
              latestPersonalData['relationship'] ?? '';

          numberController.text = latestPersonalData['phone_number'] ?? '';

          nomineaddressController.text = latestPersonalData['address'] ?? '';
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
          'Family Edit',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: ThemeColor.app_bar,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Column(
            children: [
              const Text(
                'Edit Family Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              _buildTextField(
                hintText: 'Nomine Name',
                prefixIconData: Icons.person,
                controller: nominenameController,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                hintText: 'Relationship',
                prefixIconData: Icons.receipt_long,
                controller: relationshipController,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                hintText: 'Phone Number',
                prefixIconData: Icons.phone_android_sharp,
                controller: numberController,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                hintText: 'Address',
                prefixIconData: Icons.add_reaction_sharp,
                controller: nomineaddressController,
              ),
              const SizedBox(height: 15),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  height: 60.0,
                  child: ElevatedButton(
                    onPressed: () {
                      _nextSection(context);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      backgroundColor: ThemeColor.btn_color,
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(
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

  void _nextSection(BuildContext context) async {
    // Add the BuildContext parameter
    try {
      Map<String, dynamic> familyInformationData = {
        'name': nominenameController.text,
        'relationship': relationshipController.text,
        'phone_number': numberController.text,
        'address': nomineaddressController.text,
      };
      // final familyId = widget.familyData['id'].toString();
      await FamilyApi.familyData(
          familyInformationData, context); // Remove familyId from arguments
    } catch (e) {
      print('Error updating Family information: $e');
    }
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

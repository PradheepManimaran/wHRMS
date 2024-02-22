import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wHRMS/ThemeColor/theme.dart';
import 'package:wHRMS/apiHandlar/editApi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalEditScreen extends StatefulWidget {
  const PersonalEditScreen({super.key});

  @override
  State<PersonalEditScreen> createState() => _PersonalEditScreenState();
}

class _PersonalEditScreenState extends State<PersonalEditScreen> {
  TextEditingController usernameController = TextEditingController();

  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController aboutMeController = TextEditingController();
  TextEditingController emaiController = TextEditingController();

  // final Logger _logger = Logger();

  int currentSection = 1;
  bool isLastSection = false;

  bool isSameAsPresentAddress = false;
  bool isFresher = false;

  bool isAdditionalFieldsAdded = false;
  bool isAdditionalFieldsWork = false;

  String? selectedRole;
  String? selectedStatus;
  final List<String> genderOptions = ['Male', 'Female'];
  final List<String> statusOptions = ['Single', 'Married'];

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
          int? age = latestPersonalData['age'];
          ageController.text = age != null ? age.toString() : '';
          dateOfBirthController.text =
              latestPersonalData['date_of_birth'] ?? '';
          emaiController.text = latestPersonalData['personal_email'] ?? '';
          aboutMeController.text = latestPersonalData['about_us'] ?? '';
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
              const SizedBox(height: 190),
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
                      isLastSection ? 'Submit' : 'Submit',
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
        // 'age': ageController.text,
        'date_of_birth': dateOfBirthController.text,
        'personal_email': emaiController.text,
        'about_us': aboutMeController.text,
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
            'Personal Information',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            textAlign: TextAlign.start,
          ),
        ),
        // const SizedBox(height: 15),
        // _buildTextField(
        //   hintText: 'User Name',
        //   prefixIconData: Icons.person,
        //   controller: ageController,
        // ),
        const SizedBox(height: 15),
        _buildTextField(
          hintText: 'age',
          prefixIconData: Icons.person,
          controller: ageController,
        ),
        const SizedBox(height: 15),
        // _buildDropdownFormField(
        //   items: genderOptions,
        //   selectedValue: selectedRole,
        //   hintText: 'Gender',
        //   onChanged: (String? value) {
        //     setState(() {
        //       selectedRole = value;
        //     });
        //   },
        //   prefixIconData: Icons.person,
        // ),
        // const SizedBox(height: 15),
        _buildDateField(
          'Date Of Birth',
          dateOfBirthController,
          ageController,
        ),
        // const SizedBox(height: 15),
        // _buildTextField(
        //   hintText: 'Age',
        //   prefixIconData: Icons.person,
        //   controller: ageController,
        // ),
        // const SizedBox(height: 15),
        // _buildDropdownFormField(
        //   items: statusOptions,
        //   selectedValue: selectedStatus,
        //   hintText: 'Marital Status',
        //   onChanged: (String? value) {
        //     setState(() {
        //       selectedStatus = value;
        //     });
        //   },
        //   prefixIconData: Icons.person,
        // ),
        const SizedBox(height: 15),
        _buildTextField(
          hintText: 'Email',
          prefixIconData: Icons.person,
          controller: emaiController,
        ),
        const SizedBox(height: 15),
        // _buildLeaveReasonField(),
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

  Widget _buildDateField(String hintText, TextEditingController controller,
      TextEditingController ageController) {
    return SizedBox(
      child: TextField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.date_range,
          ),
          hintText: hintText,
          labelStyle: const TextStyle(fontSize: 10),
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: ThemeColor.TextFieldColor,
        ),
        onTap: () async {
          DateTime currentDate = DateTime.now();
          DateTime firstAllowedDate = DateTime(1900, 1, 1);

          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: currentDate,
            firstDate: firstAllowedDate,
            lastDate: currentDate,
          );

          if (pickedDate != null) {
            String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
            controller.text = formattedDate;

            int age = currentDate.year -
                pickedDate.year -
                ((currentDate.month > pickedDate.month ||
                        (currentDate.month == pickedDate.month &&
                            currentDate.day >= pickedDate.day))
                    ? 0
                    : 1);

            ageController.text = age.toString();
          }
        },
      ),
    );
  }

  Widget _buildLeaveReasonField() {
    return SizedBox(
      width: double.infinity,
      child: TextField(
        controller: aboutMeController,
        maxLines: null,
        decoration: InputDecoration(
          prefix: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: SizedBox(
              width: 5,
              child: Container(
                color: Colors.black,
              ),
            ),
          ),
          hintText: 'About Me',
          hintStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: ThemeColor.TextFieldColor,
        ),
      ),
    );
  }

  Widget _buildDropdownFormField({
    required List<String> items,
    required String? selectedValue,
    required String hintText,
    required void Function(String?) onChanged,
    IconData? prefixIconData,
  }) {
    return SizedBox(
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: ThemeColor.TextFieldColor,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(5.0),
          ),
          prefixIcon: Icon(prefixIconData),
        ),
        value: selectedValue,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          );
        }).toList(),
        dropdownColor: ThemeColor.log_background,
        onChanged: onChanged,
        style: const TextStyle(),
      ),
    );
  }
}

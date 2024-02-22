// import 'dart:io';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:logger/logger.dart';
// import 'package:wHRMS/ThemeColor/theme.dart';
// import 'package:wHRMS/apiHandlar/editApi.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class EditEmployeeProfile extends StatefulWidget {
//   const EditEmployeeProfile({super.key});

//   @override
//   State<EditEmployeeProfile> createState() => _EditEmployeeProfileState();
// }

// class _EditEmployeeProfileState extends State<EditEmployeeProfile> {
//   TextEditingController firstNameController = TextEditingController();
//   TextEditingController lastNameController = TextEditingController();
//   TextEditingController genderController = TextEditingController();
//   TextEditingController dateofbirthController = TextEditingController();
//   TextEditingController ageController = TextEditingController();
//   TextEditingController martialStatusController = TextEditingController();
//   TextEditingController aboutmeController = TextEditingController();

//   //Identity Information Controller's
//   TextEditingController uanController = TextEditingController();
//   TextEditingController panController = TextEditingController();
//   TextEditingController aadharController = TextEditingController();

//   //Image Upload Controller's
//   TextEditingController aadharCardController = TextEditingController();
//   TextEditingController photoController = TextEditingController();

//   //Address present Controller's
//   TextEditingController presentAddressLine1Controller = TextEditingController();
//   TextEditingController presentAddressLine2Controller = TextEditingController();
//   TextEditingController presentCityController = TextEditingController();
//   TextEditingController presentStateController = TextEditingController();
//   TextEditingController presentCountryController = TextEditingController();
//   TextEditingController presentPinCodeController = TextEditingController();

//   //permanet address Controller's
//   TextEditingController permanentAddressLine1Controller =
//       TextEditingController();
//   TextEditingController permanentAddressLine2Controller =
//       TextEditingController();
//   TextEditingController permanentCityController = TextEditingController();
//   TextEditingController permanentStateController = TextEditingController();
//   TextEditingController permanentCountryController = TextEditingController();
//   TextEditingController permanentPinCodeController = TextEditingController();
//   //Contact Details Controller's
//   TextEditingController workNumberController = TextEditingController();
//   TextEditingController personalNumberController = TextEditingController();
//   TextEditingController personalEmailController = TextEditingController();

//   //Date Controller's
//   TextEditingController dateOfBirthController = TextEditingController();
//   TextEditingController fromDateController = TextEditingController();
//   TextEditingController toDateController = TextEditingController();
//   TextEditingController completionDateController = TextEditingController();

//   //Work Experience Controller's
//   TextEditingController companynameController = TextEditingController();
//   TextEditingController jobtitleController = TextEditingController();
//   TextEditingController jobdecController = TextEditingController();
//   TextEditingController relevantController = TextEditingController();
//   TextEditingController desController = TextEditingController();
//   TextEditingController useridController = TextEditingController();
//   //Education Details Controller's
//   TextEditingController institutenameController = TextEditingController();
//   TextEditingController degreeController = TextEditingController();
//   TextEditingController specializationController = TextEditingController();
//   TextEditingController dateofcompletionController = TextEditingController();
//   File? aadharCardImagePath;
//   File? photoImagePath;
//   String? token;

//   final Logger _logger = Logger();
//   //Image Picking
//   Future<String?> _pickImage(TextEditingController controller) async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.image,
//     );

//     if (result != null) {
//       PlatformFile file = result.files.first;

//       if (_isImageFile(file)) {
//         controller.text = file.path!;
//         return file.path;
//       } else {
//         print("Error: Selected file is not an image");
//         return null;
//       }
//     } else {
//       print("No file picked");
//       return null;
//     }
//   }

//   bool _isImageFile(PlatformFile file) {
//     return file.name.toLowerCase().endsWith('.jpg') ||
//         file.name.toLowerCase().endsWith('.jpeg') ||
//         file.name.toLowerCase().endsWith('.png');
//   }

//   int currentSection = 1;
//   bool isLastSection = false;

//   bool isSameAsPresentAddress = false;
//   bool isFresher = false;

//   bool isAdditionalFieldsAdded = false;
//   bool isAdditionalFieldsWork = false;

//   String? selectedRole;
//   String? selectedStatus;
//   String? selectedRelevant;
//   final List<String> gender = ['Male', 'Female'];
//   final List<String> status = ['Single', 'Married'];
//   List<bool> relevant = [true, false];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             'Edit Profile',
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//               fontSize: 20,
//             ),
//           ),
//           // centerTitle: true,
//           backgroundColor: ThemeColor.app_bar,
//           iconTheme: const IconThemeData(color: Colors.white),
//         ),
//         body: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 8.0),
//           child: Center(
//             child: Column(
//               children: [
//                 _buildProfileFields(),
//                 const SizedBox(height: 30),
//                 Align(
//                   alignment: Alignment.bottomCenter,
//                   child: SizedBox(
//                     width: 340.0,
//                     height: 60.0,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         _nextSection();
//                       },
//                       style: ElevatedButton.styleFrom(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(6.0),
//                         ),
//                         backgroundColor: ThemeColor.btn_color,
//                       ),
//                       child: Text(
//                         isLastSection ? 'Submit' : 'Next',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 20,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ));
//   }

//   Future<String?> getAuthToken() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('token');
//   }

//   void _nextSection() async {
//     if (currentSection < 5) {
//       setState(() {
//         currentSection++;
//         isLastSection = currentSection == 5;
//       });
//     } else {
//       try {
//         print('Profile Details Complete');

//         // Retrieve the token from SharedPreferences
//         String? token = await getAuthToken();

//         // Check if token is not null before making the API call
//         if (token == null) {
//           print('Error: Token is null.');
//           return;
//         }

//         // Retrieve the list of user work experiences
//         List<Map<String, dynamic>>? userWorkExperiences =
//             await UpdateWorkApi.getUserWorkExperiences(token);

//         if (userWorkExperiences != null && userWorkExperiences.isNotEmpty) {
//           // Assume you want to update the latest work experience
//           Map<String, dynamic> latestWorkExperience = userWorkExperiences.last;

//           // Retrieve the work experience ID
//           String? workExperienceId = latestWorkExperience['id'].toString();

//           print(
//               'Work Experience ID: $workExperienceId'); // Print the workExperienceId

//           // Refactor the null check to avoid unnecessary null comparisons
//           if (workExperienceId.isEmpty) {
//             print('Error: Work Experience ID is null or empty.');
//             return;
//           }
//           final comname = companynameController.text;
//           final designation = desController.text;
//           final fromDate = fromDateController.text;
//           final toDate = toDateController.text;
//           final description = jobtitleController.text;
//           final relevant = selectedRelevant;
//           final tableid = workExperienceId;
//           _logger.d(
//               'Testing Id: $tableid,COM NAME: $comname,DEG: $designation,FROM Date: $fromDate,TO Date: $toDate,Job: $description,Selecte: $relevant');
//           // Call the updateWorkData method from the class UpdateWorkApi
//           // ignore: use_build_context_synchronously
//           await UpdateWorkApi.updateWorkData({
//             'company_name': comname,
//             'designation': designation,
//             'from_date': fromDate,
//             'to_date': toDate,
//             'description': description,
//             'relavent': relevant,
//             'table_id': tableid
//           }, context);

//           // Handle any additional logic or UI updates after the update
//         } else {
//           print('No user work experiences found.');
//         }
//       } catch (e) {
//         print('Error in _nextSection: $e');
//       }
//     }
//   }

//   Widget _buildProfileFields() {
//     switch (currentSection) {
//       case 1:
//         return _buildPersonalInformationFields();
//       case 2:
//         return _buildEducationalInformationFields();
//       case 3:
//         return _buildContactDetailsFields();
//       case 4:
//         return _buildWorkExperienceFields();
//       case 5:
//         return _buildEducationFields();

//       default:
//         return Container();
//     }
//   }

//   //Personal Information's
//   Widget _buildPersonalInformationFields() {
//     TextEditingController ageController = TextEditingController();

//     return Column(
//       children: [
//         const SizedBox(height: 15),
//         const Align(
//           alignment: Alignment.topLeft,
//           child: Text(
//             'Personal Information',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 18,
//             ),
//             textAlign: TextAlign.start,
//           ),
//         ),
//         const SizedBox(height: 15),
//         _buildTextField(
//           hintText: 'First Name',
//           prefixIconData: Icons.person,
//           controller: firstNameController,
//         ),
//         const SizedBox(height: 15),
//         _buildTextField(
//           hintText: 'Last Name',
//           prefixIconData: Icons.person,
//           controller: lastNameController,
//         ),
//         const SizedBox(height: 15),
//         buildDropdownFormField(
//           items: gender,
//           selectedValue: selectedRole,
//           hintText: 'Gender',
//           onChanged: (String? value) {
//             setState(() {
//               selectedRole = value;
//             });
//           },
//           prefixIconData: Icons.person,
//         ),
//         const SizedBox(height: 15),
//         _buildDateField(
//           'Date Of Birth',
//           dateOfBirthController,
//           ageController,
//         ),
//         const SizedBox(height: 15),
//         _buildTextField(
//           hintText: 'Age',
//           prefixIconData: Icons.person,
//           controller: ageController,
//         ),
//         const SizedBox(height: 15),
//         buildDropdownFormField(
//           items: status,
//           selectedValue: selectedStatus,
//           hintText: 'Martial Status',
//           onChanged: (String? value) {
//             setState(() {
//               selectedStatus = value;
//             });
//           },
//           prefixIconData: Icons.keyboard_option_key,
//         ),
//         const SizedBox(height: 15),
//         _buildLeaveReasonField(),
//       ],
//     );
//   }

//   //Identity Information's
//   Widget _buildEducationalInformationFields() {
//     return Column(
//       children: [
//         const SizedBox(height: 15),
//         const Align(
//           alignment: Alignment.topLeft,
//           child: Text(
//             'Identity Information',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 18,
//             ),
//             textAlign: TextAlign.start,
//           ),
//         ),
//         const SizedBox(height: 15),
//         _buildTextField(
//           hintText: 'UAN Number',
//           prefixIconData: Icons.pin,
//           controller: uanController,
//         ),
//         const SizedBox(height: 15),
//         _buildTextField(
//           hintText: 'PAN Number',
//           prefixIconData: Icons.pin,
//           controller: panController,
//         ),
//         const SizedBox(height: 15),
//         _buildTextField(
//           hintText: 'Aadhar Number',
//           prefixIconData: Icons.pin,
//           controller: aadharController,
//         ),
//         const SizedBox(height: 15),
//         TextFormField(
//           controller: aadharCardController,
//           decoration: const InputDecoration(labelText: 'Aadhar Card Path'),
//         ),
//         ElevatedButton(
//           onPressed: () async {
//             String? imagePath = await _pickImage(aadharCardController);
//             if (imagePath != null) {
//               setState(() {
//                 aadharCardController.text = imagePath;
//               });
//             }
//           },
//           child: const Text('Pick Aadhar Card Image'),
//         ),
//         const SizedBox(height: 15),
//         TextFormField(
//           controller: photoController,
//           decoration: const InputDecoration(labelText: 'Profile Photo Path'),
//         ),
//         ElevatedButton(
//           onPressed: () async {
//             String? imagePath = await _pickImage(photoController);
//             if (imagePath != null) {
//               setState(() {
//                 photoController.text = imagePath;
//               });
//             }
//           },
//           child: const Text('Pick Profile Photo'),
//         ),
//         const SizedBox(height: 80),
//       ],
//     );
//   }

//   //Contact Details
//   Widget _buildContactDetailsFields() {
//     return Column(
//       children: [
//         const SizedBox(height: 15),
//         const Align(
//           alignment: Alignment.topLeft,
//           child: Text(
//             'Contact Details',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 18,
//             ),
//             textAlign: TextAlign.start,
//           ),
//         ),
//         const SizedBox(height: 15),
//         _buildTextField(
//           hintText: 'Work Phone Number',
//           prefixIconData: Icons.phone_android,
//           controller: workNumberController,
//         ),
//         const SizedBox(height: 15),
//         _buildTextField(
//           hintText: 'Personal Phone Number',
//           prefixIconData: Icons.phone_android_sharp,
//           controller: personalNumberController,
//         ),
//         const SizedBox(height: 15),
//         _buildTextField(
//           hintText: 'Personal Email Address',
//           prefixIconData: Icons.email,
//           controller: personalEmailController,
//         ),
//         const SizedBox(height: 15),
//         const Row(
//           children: [
//             Align(
//               alignment: Alignment.topLeft,
//               child: Text(
//                 'Present Address',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                 ),
//                 textAlign: TextAlign.start,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 5),
//         _buildTextField(
//           controller: presentAddressLine1Controller,
//           hintText: 'Address Line 1',
//           prefixIconData: Icons.person,
//         ),
//         const SizedBox(height: 15),
//         _buildTextField(
//           controller: presentAddressLine2Controller,
//           hintText: 'Address Line 2',
//           prefixIconData: Icons.person,
//         ),
//         const SizedBox(height: 15),
//         _buildTextField(
//           controller: presentCityController,
//           hintText: 'City',
//           prefixIconData: Icons.location_city,
//         ),
//         const SizedBox(height: 15),
//         _buildTextField(
//           controller: presentStateController,
//           hintText: 'State',
//           prefixIconData: Icons.location_city,
//         ),
//         const SizedBox(height: 15),
//         _buildTextField(
//           controller: presentCountryController,
//           hintText: 'Country',
//           prefixIconData: Icons.flag,
//         ),
//         const SizedBox(height: 15),
//         _buildTextField(
//           controller: presentPinCodeController,
//           hintText: 'Pin Code',
//           prefixIconData: Icons.pin,
//         ),
//         const SizedBox(height: 15),
//         Row(
//           children: [
//             const Align(
//               alignment: Alignment.topLeft,
//               child: Text(
//                 'Permanent Address',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 13,
//                 ),
//                 textAlign: TextAlign.start,
//               ),
//             ),
//             const SizedBox(width: 1),
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Row(
//                 children: [
//                   Checkbox(
//                     value: isSameAsPresentAddress,
//                     onChanged: (bool? value) {
//                       setState(() {
//                         isSameAsPresentAddress = value ?? false;
//                         if (isSameAsPresentAddress) {
//                           // Copy present address to permanent address
//                           permanentAddressLine1Controller.text =
//                               presentAddressLine1Controller.text;
//                           permanentAddressLine2Controller.text =
//                               presentAddressLine2Controller.text;
//                           permanentCityController.text =
//                               presentCityController.text;
//                           permanentStateController.text =
//                               presentStateController.text;
//                           permanentCountryController.text =
//                               presentCountryController.text;
//                           permanentPinCodeController.text =
//                               presentPinCodeController.text;
//                         } else {
//                           permanentAddressLine1Controller.clear();
//                           permanentAddressLine2Controller.clear();
//                           permanentCityController.clear();
//                           permanentStateController.clear();
//                           permanentCountryController.clear();
//                           permanentPinCodeController.clear();
//                         }
//                       });
//                     },
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(4.0),
//                     ),
//                   ),
//                   const Text('Same address'),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 5),
//         _buildTextField(
//           controller: permanentAddressLine1Controller,
//           hintText: 'Address Line 1',
//           prefixIconData: Icons.person,
//         ),
//         const SizedBox(height: 15),
//         _buildTextField(
//           controller: permanentAddressLine2Controller,
//           hintText: 'Address Line 2',
//           prefixIconData: Icons.person,
//         ),
//         const SizedBox(height: 15),
//         _buildTextField(
//           controller: permanentCityController,
//           hintText: 'City',
//           prefixIconData: Icons.location_city,
//         ),
//         const SizedBox(height: 15),
//         _buildTextField(
//           controller: permanentStateController,
//           hintText: 'State',
//           prefixIconData: Icons.location_city,
//         ),
//         const SizedBox(height: 15),
//         _buildTextField(
//           controller: permanentCountryController,
//           hintText: 'Country',
//           prefixIconData: Icons.flag,
//         ),
//         const SizedBox(height: 15),
//         _buildTextField(
//           controller: permanentPinCodeController,
//           hintText: 'Pin Code',
//           prefixIconData: Icons.pin,
//         ),
//       ],
//     );
//   }

//   //Work Experience's
//   Widget _buildWorkExperienceFields() {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text(
//               'Work Experience',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//               ),
//             ),
//             // const SizedBox(height: 60),
//             Checkbox(
//               value: isFresher,
//               onChanged: (bool? value) {
//                 setState(() {
//                   isFresher = value ?? false;
//                 });
//               },
//               activeColor: Colors.blue,
//               checkColor: Colors.white,
//             ),
//             const Text(
//               'Fresher',
//               style: TextStyle(
//                 // fontWeight: FontWeight.bold,
//                 fontSize: 14,
//                 color: Colors.blue,
//               ),
//             ),
//             IconButton(
//               color: Colors.blue,
//               icon: isAdditionalFieldsWork
//                   ? const Icon(Icons.remove)
//                   : const Icon(Icons.add),
//               onPressed: () {
//                 setState(() {
//                   isAdditionalFieldsWork = !isAdditionalFieldsWork;
//                 });
//               },
//             ),
//             const Text(
//               'Add',
//               style: TextStyle(
//                 // fontWeight: FontWeight.bold,
//                 color: Colors.blue,
//                 fontSize: 14,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 15),
//         Visibility(
//           visible: !isFresher, // Hide if the user is a fresher
//           child: Column(
//             children: [
//               _buildTextField(
//                 hintText: 'Company Name',
//                 prefixIconData: Icons.business,
//                 controller: companynameController,
//               ),
//               const SizedBox(height: 15),
//               _buildTextField(
//                 hintText: 'Job Title',
//                 prefixIconData: Icons.work,
//                 controller: jobtitleController,
//               ),
//               const SizedBox(height: 15),
//               _buildDateFields('From Date', fromDateController),
//               const SizedBox(height: 15),
//               _buildDateFields('To Date', toDateController),
//               const SizedBox(height: 15),
//               _buildTextField(
//                   hintText: 'Job Description',
//                   prefixIconData: Icons.description,
//                   controller: desController),
//               const SizedBox(height: 15),
//               buildDropdownFormFieldss(
//                 items: relevant,
//                 selectedValue: selectedRelevant,
//                 hintText: 'Relevant',
//                 onChanged: (String? value) {
//                   setState(() {
//                     selectedRelevant = value;
//                   });
//                 },
//                 prefixIconData: Icons.real_estate_agent,
//               ),
//               if (isAdditionalFieldsWork)
//                 Column(
//                   children: [
//                     const SizedBox(height: 15),
//                     const Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         'Additional Fields',
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//                     _buildTextField(
//                       hintText: 'Company Name',
//                       prefixIconData: Icons.business,
//                     ),
//                     const SizedBox(height: 15),
//                     _buildTextField(
//                       hintText: 'Job Title',
//                       prefixIconData: Icons.work,
//                     ),
//                     const SizedBox(height: 15),
//                     _buildDateFields('From Date', fromDateController),
//                     const SizedBox(height: 15),
//                     _buildDateFields('To Date', toDateController),
//                     const SizedBox(height: 15),
//                     _buildTextField(
//                       hintText: 'Job Description',
//                       prefixIconData: Icons.description,
//                     ),
//                     const SizedBox(height: 15),
//                     buildDropdownFormFieldss(
//                       items: relevant,
//                       selectedValue: selectedRelevant,
//                       hintText: 'Relevant',
//                       onChanged: (String? value) {
//                         setState(() {
//                           selectedRelevant = value;
//                         });
//                       },
//                       prefixIconData: Icons.real_estate_agent,
//                     ),
//                   ],
//                 ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   //Education Details
//   Widget _buildEducationFields() {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text(
//               'Education Details',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//               ),
//             ),
//             Row(
//               children: [
//                 IconButton(
//                   color: Colors.blue,
//                   icon: isAdditionalFieldsAdded
//                       ? const Icon(Icons.remove)
//                       : const Icon(Icons.add),
//                   onPressed: () {
//                     setState(() {
//                       isAdditionalFieldsAdded = !isAdditionalFieldsAdded;
//                     });
//                   },
//                 ),
//                 const Text(
//                   'Add',
//                   style: TextStyle(
//                     // fontWeight: FontWeight.bold,
//                     color: Colors.blue,
//                     fontSize: 16,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         const SizedBox(height: 20),
//         _buildTextField(
//           hintText: 'Institute Name',
//           prefixIconData: Icons.location_city,
//           controller: institutenameController,
//         ),
//         const SizedBox(height: 15),
//         _buildTextField(
//           hintText: 'Degree/Diploma',
//           prefixIconData: Icons.cast_for_education_sharp,
//           controller: degreeController,
//         ),
//         const SizedBox(height: 15),
//         _buildTextField(
//           hintText: 'Specialization',
//           prefixIconData: Icons.cast_for_education,
//           controller: specializationController,
//         ),
//         const SizedBox(height: 15),
//         _buildDateFields('Date Of Completion', completionDateController),
//         // Display additional fields based on the flag
//         if (isAdditionalFieldsAdded)
//           Column(
//             children: [
//               const SizedBox(height: 15),
//               const Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   'Additional Fields',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ),
//               const SizedBox(height: 15),
//               _buildTextField(
//                 hintText: 'Institute Name 1',
//                 prefixIconData: Icons.location_city,
//               ),
//               const SizedBox(height: 15),
//               _buildTextField(
//                 hintText: 'Degree/Diploma 1',
//                 prefixIconData: Icons.cast_for_education_sharp,
//               ),
//               const SizedBox(height: 15),
//               _buildTextField(
//                 hintText: 'Specialization 1',
//                 prefixIconData: Icons.cast_for_education,
//               ),
//               const SizedBox(height: 15),
//               _buildDateFields('Date Of Completion 1', TextEditingController()),
//             ],
//           ),
//         const SizedBox(height: 150),
//       ],
//     );
//   }

//   //Common TextField Method
//   Widget _buildTextField({
//     TextEditingController? controller,
//     String hintText = 'Enter text here',
//     IconData? prefixIconData,
//     // bool readOnly = false, // Add this line
//   }) {
//     return Center(
//       child: TextField(
//         controller: controller,
//         // readOnly: readOnly, // Use the provided readOnly parameter
//         decoration: InputDecoration(
//           hintText: hintText,
//           prefixIcon: Icon(prefixIconData),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(6),
//             borderSide: const BorderSide(
//               color: Colors.black,
//               width: 2.0,
//             ),
//           ),
//           filled: true,
//           fillColor: ThemeColor.TextFieldColor,
//         ),
//       ),
//     );
//   }

//   //Date Field Method in Age Calculation for Date Of Birth
//   Widget _buildDateField(String hintText, TextEditingController controller,
//       TextEditingController ageController) {
//     return SizedBox(
//       // width: 160,
//       child: TextField(
//         controller: controller,
//         readOnly: true, // Make the field read-only
//         decoration: InputDecoration(
//           prefixIcon: const Icon(
//             Icons.date_range,
//             // color: Colors.blue,
//           ),
//           hintText: hintText,
//           labelStyle: const TextStyle(fontSize: 10),
//           border: const OutlineInputBorder(),
//           filled: true,
//           fillColor: ThemeColor.TextFieldColor,
//         ),
//         onTap: () async {
//           DateTime currentDate = DateTime.now();
//           DateTime firstAllowedDate = DateTime(1900, 1, 1);

//           DateTime? pickedDate = await showDatePicker(
//             context: context,
//             initialDate: currentDate,
//             firstDate: firstAllowedDate,
//             lastDate: currentDate,
//           );

//           if (pickedDate != null) {
//             String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
//             controller.text = formattedDate;

//             // Calculate age based on selected date
//             int age = currentDate.year -
//                 pickedDate.year -
//                 ((currentDate.month > pickedDate.month ||
//                         (currentDate.month == pickedDate.month &&
//                             currentDate.day >= pickedDate.day))
//                     ? 0
//                     : 1);

//             // Set the calculated age in the age field
//             ageController.text = age.toString();
//           }
//         },
//       ),
//     );
//   }

//   //About Me method
//   Widget _buildLeaveReasonField() {
//     return SizedBox(
//       width: double.infinity,
//       // height: 159,
//       child: TextField(
//         maxLines: null, // Allow multiple lines
//         decoration: InputDecoration(
//           prefix: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 4.0),
//             child: SizedBox(
//               width: 5,
//               child: Container(
//                 color: Colors.black,
//               ),
//             ),
//           ),
//           hintText: 'About Me',
//           hintStyle: const TextStyle(
//             fontSize: 15,
//             fontWeight: FontWeight.bold,
//           ),
//           border: const OutlineInputBorder(),
//           filled: true,
//           fillColor: ThemeColor.TextFieldColor,
//         ),
//       ),
//     );
//   }

//   Widget buildDropdownFormFieldss({
//     required List<bool> items,
//     required String? selectedValue,
//     required String hintText,
//     required Function(String?) onChanged,
//     required IconData prefixIconData,
//   }) {
//     return DropdownButtonFormField<bool>(
//       value: selectedValue == 'true' ? true : false,
//       items: items.map((bool value) {
//         return DropdownMenuItem<bool>(
//           value: value,
//           child: Text(value.toString()), // Display 'true' or 'false'
//         );
//       }).toList(),
//       onChanged: (bool? newValue) {
//         onChanged(newValue?.toString()); // Convert bool to String
//       },
//       decoration: InputDecoration(
//         hintText: hintText,
//         prefixIcon: Icon(prefixIconData),
//         border: OutlineInputBorder(),
//       ),
//     );
//   }

//   //DropDown Method
//   Widget buildDropdownFormField({
//     required List<String> items,
//     required String? selectedValue,
//     required String hintText,
//     required void Function(String?) onChanged,
//     IconData? prefixIconData,
//   }) {
//     return SizedBox(
//       child: DropdownButtonFormField<String>(
//         decoration: InputDecoration(
//           hintText: hintText,
//           filled: true,
//           fillColor: ThemeColor.TextFieldColor,
//           enabledBorder: OutlineInputBorder(
//             borderSide: const BorderSide(
//               color: Colors.grey,
//               width: 1.0,
//             ),
//             borderRadius: BorderRadius.circular(5.0),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderSide: const BorderSide(
//               color: Colors.grey,
//               width: 1.0,
//             ),
//             borderRadius: BorderRadius.circular(5.0),
//           ),
//           border: OutlineInputBorder(
//             borderSide: BorderSide.none,
//             borderRadius: BorderRadius.circular(5.0),
//           ),
//           prefixIcon: Icon(prefixIconData),
//         ),
//         value: selectedValue,
//         items: items.map((String item) {
//           return DropdownMenuItem<String>(
//             value: item,
//             child: Text(
//               item,
//               style: const TextStyle(
//                 color: Colors.black,
//               ),
//             ),
//           );
//         }).toList(),
//         dropdownColor: ThemeColor.log_background,
//         onChanged: onChanged,
//         style: const TextStyle(
//             // color: Colors.black,
//             ),
//         // iconEnabledColor: Colors.black,
//       ),
//     );
//   }

//   //Date method in From Date, To Date
//   Widget _buildDateFields(String hintText, TextEditingController controller) {
//     return SizedBox(
//       // width: 160,
//       child: TextField(
//         controller: controller,
//         readOnly: true, // Make the field read-only
//         decoration: InputDecoration(
//           prefixIcon: const Icon(
//             Icons.date_range,
//             // color: Colors.blue,
//           ),
//           hintText: hintText,
//           labelStyle: const TextStyle(fontSize: 10),
//           border: const OutlineInputBorder(),
//           filled: true,
//           fillColor: ThemeColor.TextFieldColor,
//         ),
//         onTap: () async {
//           DateTime? pickedDate = await showDatePicker(
//             context: context,
//             initialDate: DateTime.now(),
//             firstDate: DateTime(2000),
//             lastDate: DateTime(3000),
//           );

//           if (pickedDate != null) {
//             String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
//             controller.text = formattedDate;
//           }
//         },
//       ),
//     );
//   }

//   //Image Upload's Field's
//   Widget _buildImageTextField({
//     required TextEditingController controller,
//     required String hintText,
//     required IconData prefixIconData,
//   }) {
//     return Row(
//       children: [
//         Expanded(
//           child: TextField(
//             controller: controller,
//             onTap: () async {
//               await _pickImage(controller);
//             },
//             decoration: InputDecoration(
//               hintText: hintText,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(6),
//                 borderSide: const BorderSide(
//                   color: Colors.black,
//                   width: 2.0,
//                 ),
//               ),
//               filled: true,
//               fillColor: ThemeColor.TextFieldColor,
//               prefixIcon: Icon(prefixIconData),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

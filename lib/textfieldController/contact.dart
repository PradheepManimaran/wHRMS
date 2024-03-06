// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:wHRMS/ThemeColor/theme.dart';

// class contactBuild {
//   //Contact Details
//   Widget _buildContactDetailsFields(BuildContext context) {
//     TextEditingController presentAddressLine1Controller =
//         TextEditingController();
//     TextEditingController presentAddressLine2Controller =
//         TextEditingController();
//     TextEditingController presentCityController = TextEditingController();
//     TextEditingController presentStateController = TextEditingController();
//     TextEditingController presentCountryController = TextEditingController();
//     TextEditingController presentPinCodeController = TextEditingController();
//     // String? selectedCountry;
//     // String? selectedState;
//     // String? selectedCity;

//     //permanet address Controller's
//     TextEditingController permanentAddressLine1Controller =
//         TextEditingController();
//     TextEditingController permanentAddressLine2Controller =
//         TextEditingController();
//     TextEditingController permanentCityController = TextEditingController();
//     TextEditingController permanentStateController = TextEditingController();
//     TextEditingController permanentCountryController = TextEditingController();
//     TextEditingController permanentPinCodeController = TextEditingController();

//     //Contact Details Controller's
//     TextEditingController workNumberController = TextEditingController();
//     TextEditingController personalNumberController = TextEditingController();
//     TextEditingController personalEmailController = TextEditingController();
//     bool isSameAsPresentAddress = false;

//     void _copyPresentToPermanent(TextEditingController presentController,
//         TextEditingController permanentController) {
//       if (isSameAsPresentAddress) {
//         permanentController.text = presentController.text;
//       }
//     }

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
//         _buildphoneNumber(
//           hintText: 'Work Phone Number',
//           prefixIconData: Icons.phone_android,
//           controller: workNumberController,
//           fieldName: 'Work Phone Number',
//         ),
//         const SizedBox(height: 15),
//         _buildphoneNumber(
//           hintText: 'Personal Phone Number',
//           prefixIconData: Icons.phone_android_sharp,
//           controller: personalNumberController,
//           fieldName: 'Personal Number',
//         ),
//         const SizedBox(height: 15),
//         _buildTextField(
//           hintText: 'Personal Email Address',
//           prefixIconData: Icons.email,
//           controller: personalEmailController,
//           fieldName: 'Personal Email',
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
//           fieldName: 'Address',
//         ),
//         const SizedBox(height: 15),
//         _buildTextField(
//           controller: presentAddressLine2Controller,
//           hintText: 'Address Line 2',
//           prefixIconData: Icons.person,
//           fieldName: 'Address',
//         ),
//         const SizedBox(height: 15),
//         _buildTextField(
//           controller: presentCityController,
//           hintText: 'City',
//           prefixIconData: Icons.location_city,
//           fieldName: 'City',
//         ),
//         const SizedBox(height: 15),
//         _buildTextField(
//           controller: presentStateController,
//           hintText: 'State',
//           prefixIconData: Icons.location_city,
//           fieldName: 'State',
//         ),
//         const SizedBox(height: 15),
//         _buildTextField(
//           controller: presentCountryController,
//           hintText: 'Country',
//           prefixIconData: Icons.flag,
//           fieldName: 'Country',
//         ),
//         const SizedBox(height: 15),
//         _buildTextField(
//           controller: presentPinCodeController,
//           hintText: 'Pin Code',
//           prefixIconData: Icons.pin,
//           fieldName: 'Pin Code',
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
//                           _copyPresentToPermanent(presentAddressLine1Controller,
//                               permanentAddressLine1Controller);
//                           _copyPresentToPermanent(presentAddressLine2Controller,
//                               permanentAddressLine2Controller);
//                           _copyPresentToPermanent(
//                               presentCityController, permanentCityController);
//                           _copyPresentToPermanent(
//                               presentStateController, permanentStateController);
//                           _copyPresentToPermanent(presentCountryController,
//                               permanentCountryController);
//                           _copyPresentToPermanent(presentPinCodeController,
//                               permanentPinCodeController);
//                         } else {
//                           permanentAddressLine1Controller.clear();
//                           permanentAddressLine2Controller.clear();
//                           // selectedCity = null;
//                           // selectedState = null;
//                           // selectedCountry = null;
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
//           fieldName: 'Address',
//         ),
//         const SizedBox(height: 15),
//         _buildTextField(
//           controller: permanentAddressLine2Controller,
//           hintText: 'Address Line 2',
//           prefixIconData: Icons.person,
//           fieldName: 'Address',
//         ),
//         const SizedBox(height: 15),
//         _buildTextField(
//           controller: permanentCityController,
//           hintText: 'City',
//           prefixIconData: Icons.location_city,
//           fieldName: 'City',
//         ),
//         const SizedBox(height: 15),
//         _buildTextField(
//           controller: permanentStateController,
//           hintText: 'State',
//           prefixIconData: Icons.location_city,
//           fieldName: 'State',
//         ),
//         const SizedBox(height: 15),
//         _buildTextField(
//           controller: permanentCountryController,
//           hintText: 'Country',
//           prefixIconData: Icons.flag,
//           fieldName: 'Country',
//         ),
//         const SizedBox(height: 15),
//         _buildTextField(
//           controller: permanentPinCodeController,
//           hintText: 'Pin Code',
//           prefixIconData: Icons.pin,
//           fieldName: 'Pin Code',
//         ),
//         const SizedBox(height: 15),
//       ],
//     );
//   }

//   //Common TextField Method
//   Widget _buildTextField({
//     TextEditingController? controller,
//     String hintText = 'Enter text here',
//     IconData? prefixIconData,
//     required String fieldName,
//     // bool readOnly = false, // Add this line
//   }) {
//     return Center(
//       child: TextFormField(
//         controller: controller,
//         // inputFormatters: [LengthLimitingTextInputFormatter(10)],
//         decoration: InputDecoration(
//           hintText: hintText,
//           prefixIcon: Icon(prefixIconData),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(1),
//             borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
//             borderRadius: BorderRadius.circular(1),
//           ),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(1),
//             borderSide: const BorderSide(
//               // color: Colors.black,
//               width: 1.0,
//             ),
//           ),
//           filled: true,
//           fillColor: ThemeColor.TextFieldColor,
//         ),
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Please enter $fieldName';
//           }
//           return null;
//         },
//       ),
//     );
//   }

//   //Phone Number Method
//   Widget _buildphoneNumber({
//     TextEditingController? controller,
//     String hintText = 'Enter text here',
//     IconData? prefixIconData,
//     required String fieldName,
//     // bool readOnly = false, // Add this line
//   }) {
//     return Center(
//       child: TextFormField(
//         controller: controller,
//         inputFormatters: [LengthLimitingTextInputFormatter(10)],
//         decoration: InputDecoration(
//           enabledBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
//             borderRadius: BorderRadius.circular(1),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
//             borderRadius: BorderRadius.circular(1),
//           ),
//           hintText: hintText,
//           prefixIcon: Icon(prefixIconData),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(1),
//             borderSide: const BorderSide(
//               // color: Colors.black,
//               width: 1.0,
//             ),
//           ),
//           filled: true,
//           fillColor: ThemeColor.TextFieldColor,
//         ),
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Please enter $fieldName';
//           }
//           return null;
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
// import 'package:wHRMS/ThemeColor/theme.dart';

// class profileTextForm {

//   //Date Field Method in Age Calculation for Date Of Birth
//   static Widget buildDateField(String hintText, TextEditingController controller,
//       TextEditingController ageController) {
//     return SizedBox(
//       child: TextField(
//         controller: controller,
//         readOnly: true,
//         decoration: InputDecoration(
//           prefixIcon: const Icon(
//             Icons.date_range,
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

//             int age = currentDate.year -
//                 pickedDate.year -
//                 ((currentDate.month > pickedDate.month ||
//                         (currentDate.month == pickedDate.month &&
//                             currentDate.day >= pickedDate.day))
//                     ? 0
//                     : 1);

//             ageController.text = age.toString();
//           }
//         },
//       ),
//     );
//   }

//   //About Me method
//   static Widget buildLeaveReasonField() {
//     TextEditingController aboutmeController = TextEditingController();
//     return SizedBox(
//       width: double.infinity,
//       // height: 159,
//       child: TextFormField(
//         controller: aboutmeController,
//         maxLines: null,
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Please enter the about me ';
//           }
//           return null;
//         },
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

//   static Widget buildDropdownFormFieldss({
//     required List<bool> items,
//     required bool? selectedValue,
//     required String hintText,
//     required Function(bool?) onChanged,
//     required IconData prefixIconData,
//   }) {
//     return DropdownButtonFormField<bool>(
//       value: selectedValue,
//       items: items.map((bool value) {
//         return DropdownMenuItem<bool>(
//           value: value,
//           child: Text(value ? 'true' : 'false'),
//         );
//       }).toList(),
//       onChanged: onChanged,
//       decoration: InputDecoration(
//         hintText: hintText,
//         prefixIcon: Icon(prefixIconData),
//         border: OutlineInputBorder(),
//       ),
//     );
//   }

//   //DropDown Method
//   static Widget buildDropdownFormField({
//     required List<String> items,
//     required String? selectedValue,
//     required String hintText,
//     required void Function(String?) onChanged,
//     required String fieldName,
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
//         style: const TextStyle(),
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Please enter $fieldName';
//           }
//           return null;
//         },
//       ),
//     );
//   }

//   // //Date method in From Date, To Date
//   // static Widget buildDateFields(
//   //     BuildContext context, hintText, TextEditingController controller) {
//   //   return SizedBox(
//   //     // width: 160,
//   //     child: TextField(
//   //       controller: controller,
//   //       readOnly: true, // Make the field read-only
//   //       decoration: InputDecoration(
//   //         prefixIcon: const Icon(
//   //           Icons.date_range,
//   //           // color: Colors.blue,
//   //         ),
//   //         hintText: hintText,
//   //         labelStyle: const TextStyle(fontSize: 10),
//   //         border: const OutlineInputBorder(),
//   //         enabledBorder: const OutlineInputBorder(
//   //           borderSide: BorderSide(color: Colors.grey),
//   //         ),
//   //         focusedBorder: const OutlineInputBorder(
//   //           borderSide: BorderSide(color: Colors.grey),
//   //         ),
//   //         filled: true,
//   //         fillColor: ThemeColor.TextFieldColor,
//   //       ),
//   //       onTap: () async {
//   //         DateTime? pickedDate = await showDatePicker(
//   //           context: context,
//   //           initialDate: DateTime.now(),
//   //           firstDate: DateTime(2000),
//   //           lastDate: DateTime(3000),
//   //         );

//   //         if (pickedDate != null) {
//   //           String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
//   //           controller.text = formattedDate;
//   //         }
//   //       },
//   //     ),
//   //   );
//   // }

//   //Aadhar Number Validation
//   static Widget buildAadharNumber({
//     required TextEditingController controller,
//     required String hintText,
//     required IconData prefixIconData,
//     required String fieldName,
//   }) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: TextInputType.number,
//       inputFormatters: [LengthLimitingTextInputFormatter(12)],
//       decoration: InputDecoration(
//         hintText: hintText,
//         labelText: fieldName,
//         prefixIcon: Icon(prefixIconData),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(6),
//           borderSide: const BorderSide(
//             color: Colors.grey,
//             width: 2.0,
//           ),
//         ),
//         enabledBorder: const OutlineInputBorder(
//           borderSide: BorderSide(color: Colors.grey),
//         ),
//         focusedBorder: const OutlineInputBorder(
//           borderSide: BorderSide(color: Colors.grey),
//         ),
//         filled: true,
//         fillColor: Colors.white,
//       ),
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please enter $fieldName';
//         } else if (value.length != 12) {
//           return 'Aadhar Number must be 12 digits long';
//         } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
//           return 'Aadhar Number can only contain digits';
//         }
//         return null;
//       },
//     );
//   }
// }

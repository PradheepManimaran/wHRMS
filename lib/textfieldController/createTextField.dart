import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:wHRMS/ThemeColor/theme.dart';

class createText {
  static Widget buildTextFormFields({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIconData,
    // required String fieldName,
  }) {
    return SizedBox(
      width: 150,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(7.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(7.0),
          ),
          hintText: hintText,
          filled: true,
          fillColor: Colors.white,
          prefixText: 'WEMP',
          prefixIcon: Icon(prefixIconData),
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          // Check if the current value starts with 'WEMP'
          if (!value.startsWith('WEMP')) {
            // If not, prepend 'WEMP' to the entered value
            controller.value = controller.value.copyWith(
              text: 'WEMP$value',
              selection: TextSelection.collapsed(offset: ('WEMP$value').length),
              composing: TextRange.empty,
            );
          }
        },
        // validator: (value) {
        //   if (value == null || value.isEmpty) {
        //     return '$fieldName is required';
        //   }
        //   return null;
        // },
      ),
    );
  }

  static Widget buildEmployeeText({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIconData,
    String prefixText = 'WEMP', // Default prefix text is 'WEMP'
  }) {
    return SizedBox(
      width: 150,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(7.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(7.0),
          ),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(prefixIconData),
          border: const OutlineInputBorder(),
          hintText: 'EMP ID',
          // hintStyle: const TextStyle(color: Colors.blue),
        ),
        inputFormatters: [
          FilteringTextInputFormatter.deny(RegExp(r'[^0-9]')),
        ],
        onChanged: (value) {
          if (!value.startsWith(prefixText)) {
            controller.value = TextEditingValue(
              text: '$prefixText$value',
              selection: TextSelection.fromPosition(
                  TextPosition(offset: value.length + prefixText.length)),
            );
          }
        },
        onSaved: (value) {
          value = '$prefixText$value';
        },
      ),
    );
  }

  //Email TextField Formate
  static Widget buildEmailTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIconData,
    required String fieldName,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(7.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(7.0),
        ),
        labelText: fieldName,
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(prefixIconData),
        border: const OutlineInputBorder(),
        suffixText: '@gmail.com',
        suffixStyle: const TextStyle(color: Colors.blue),
      ),
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp(r'[A-Z]')),
      ],
      onChanged: (value) {
        if (value.endsWith('@gmail.com')) {
          controller.value = TextEditingValue(
            text: value.substring(0, value.length - '@gmail.com'.length),
            selection: TextSelection.collapsed(
                offset: value.length - '@gmail.com'.length),
          );
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter an email address.';
        }
        // Additional email validation logic if needed
        return null;
      },
    );
  }

  //Normal TextField Method's
  static Widget buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIconData,
    required String fieldName,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(7.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(7.0),
        ),
        hintText: hintText,
        prefixIcon: Icon(prefixIconData),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 2.0,
          ),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $fieldName';
        }
        return null;
      },
    );
  }

  //Row TextField Method's
  static Widget buildTextFields({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIconData,
    // required String fieldName,
  }) {
    return SizedBox(
      width: 150,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(prefixIconData),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(7.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(7.0),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7.0),
            borderSide: const BorderSide(
              color: Colors.grey,
              width: 2.0,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        // validator: (value) {
        //   if (value == null || value.isEmpty) {
        //     return 'Please enter $fieldName';
        //   }
        //   return null;
        // },
      ),
    );
  }

  //Department DropDown Method's
  static Widget buildDropdown({
    required List<DropdownMenuItem<String>> items,
    required String? selectedValue,
    required String hintText,
    required void Function(String?) onChanged,
    required IconData prefixIconData,
    required String fieldName,
  }) {
    return Container(
      width: double.infinity,
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        value: selectedValue,
        items: items,
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(7.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(7.0),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(7.0),
          ),
          prefixIcon: Icon(prefixIconData),
        ),
        onChanged: onChanged,
        style: const TextStyle(
          color: Colors.black,
        ),
        iconEnabledColor: Colors.grey,
        icon: const Icon(Icons.keyboard_arrow_down),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select $fieldName'; // Update the error message
          }
          return null;
        },
      ),
    );
  }

  //Date of Joining Method
  static Widget buildDateField(
      BuildContext context, String hintText, TextEditingController controller) {
    return SizedBox(
      width: 150,
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.date_range,
            // color: Colors.blue,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(7.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(7.0),
          ),
          hintText: hintText,
          labelStyle: const TextStyle(fontSize: 10),
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: ThemeColor.TextFieldColor,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select a date';
          }
          return null;
        },
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1),
            lastDate: DateTime(2101),
          );

          if (pickedDate != null) {
            String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
            controller.text = formattedDate;
          }
        },
      ),
    );
  }

  //Row side DropDown Method's
  static Widget buildDropdowns({
    required List<DropdownMenuItem<String>> items,
    required String? selectedValue,
    required String hintText,
    required void Function(String?) onChanged,
    required IconData prefixIconData,
    required String fieldName,
  }) {
    return Container(
      width: 150.0,
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        value: selectedValue,
        items: items,
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(7.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(7.0),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(7.0),
          ),
          prefixIcon: Icon(prefixIconData),
        ),
        onChanged: onChanged,
        style: const TextStyle(
          color: Colors.black,
        ),
        iconEnabledColor: Colors.grey,
        icon: const Icon(Icons.keyboard_arrow_down),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select $fieldName';
          }
          return null;
        },
      ),
    );
  }
}

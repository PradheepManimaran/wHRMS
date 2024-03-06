import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wHRMS/ThemeColor/theme.dart';

class TextWidget {
  //Normal TextField's
  static Widget buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIconData,
    required String fieldName,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        prefixIcon: Icon(prefixIconData),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
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

//
  static Widget buildDateTimeField({
    required BuildContext context,
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIconData,
    required String fieldName,
    bool isDateField = false,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        hintText: hintText,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        prefixIcon: Icon(prefixIconData),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
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
      onTap: () async {
        // Get the current time
        // DateTime currentTime = DateTime.now();

        // Create a DateTime object for 10:00 AM today
        // DateTime attendanceTimeToday = DateTime(
        //     currentTime.year, currentTime.month, currentTime.day, 9, 30);

        // Check if the current time is before 10:00 AM
        // if (currentTime.isBefore(attendanceTimeToday)) {
        if (isDateField) {
          final DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDatePickerMode: DatePickerMode.day,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2101),
          );
          if (pickedDate != null) {
            DateTime dateTime = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              DateTime.now().hour,
              DateTime.now().minute,
            );
            String formattedDateTime =
                DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
            controller.text = formattedDateTime;
          }
        }
        //  . }
        else {
          // Show a message or take appropriate action if it's after 10:00 AM
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content:
                  Text('Attendance can only be checked in before 09:30 AM.'),
            ),
          );
        }
      },
    );
  }

//
  static Widget buildDateField({
    required BuildContext context,
    required String hintText,
    required IconData prefixIconData,
    required String fieldName,
    bool isDateField = false,
  }) {
    // Get today's date
    String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return TextFormField(
      readOnly: true,
      initialValue: todayDate,
      decoration: InputDecoration(
        hintText: hintText,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        prefixIcon: Icon(prefixIconData),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
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
      onTap: () async {
        if (isDateField) {
          // Do nothing when tapped if it's a date field
          // This prevents the date picker from appearing
        }
      },
    );
  }

  static Widget buildDropdownFormField({
    required List<String> items,
    required String? selectedValue,
    required String hintText,
    required void Function(String?) onChanged,
    required String fieldName,
    IconData? prefixIconData,
  }) {
    // Set the initial selected value to null if it's empty or null
    if (selectedValue == null || !items.contains(selectedValue)) {
      selectedValue = null;
    }

    return SizedBox(
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: ThemeColor.TextFieldColor,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.5),
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(7.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.5),
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(7.0),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(7.0),
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
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $fieldName';
          }
          return null;
        },
      ),
    );
  }
}

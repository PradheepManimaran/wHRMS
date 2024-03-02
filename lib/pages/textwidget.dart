import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TextWidget {
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
  static Widget buildTextFieldss({
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
        DateTime currentTime = DateTime.now();

        // Create a DateTime object for 10:00 AM today
        DateTime attendanceTimeToday =
            DateTime(currentTime.year, currentTime.month, currentTime.day, 10);

        // Check if the current time is before 10:00 AM
        if (currentTime.isBefore(attendanceTimeToday)) {
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
        } else {
          // Show a message or take appropriate action if it's after 10:00 AM
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content:
                  Text('Attendance can only be checked in before 10:00 AM.'),
            ),
          );
        }
      },
    );
  }

//
  static Widget buildTextFields({
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
        if (isDateField) {
          final DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(3000),
          );
          if (pickedDate != null) {
            String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
            controller.text = formattedDate;
          }
        }
      },
    );
  }
}

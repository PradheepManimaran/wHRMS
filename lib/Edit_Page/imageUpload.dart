import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wHRMS/apiHandlar/baseUrl.dart';

class ProfileImageUploader {
  static Future<String?> _fetchTableId(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${URLConstants.baseUrl}/api/profileimg'),
        headers: {
          'Authorization': 'token $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        if (data.isNotEmpty) {
          final Map<String, dynamic> firstItem = data.first;
          return firstItem['table_id'].toString();
        } else {
          print('Empty response');
          return null;
        }
      } else {
        print('Failed to load table_id. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error loading table_id data: $e');
      return null;
    }
  }

  static Future<void> uploadProfilePicture(
      File imageFile, String id, String filename, BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        print('Token not found');
        return;
      }

      String? tableId = await _fetchTableId(token);

      if (tableId == null) {
        print('Table ID not found');
        return;
      }

      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('${URLConstants.baseUrl}/api/profileimg'),
      );

      request.files.add(
        http.MultipartFile(
          'profile_picture',
          imageFile.readAsBytes().asStream(),
          imageFile.lengthSync(),
          filename: filename, // Set the filename here
        ),
      );

      request.fields['id'] = tableId;
      request.fields['table_id'] = id;

      request.headers['Authorization'] = 'token $token';

      var streamedResponse = await request.send();

      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // var responseData = json.decode(response.body);
        print('Profile picture uploaded successfully.');

        print('Response body: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Profile Image update Successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      } else if (response.statusCode == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Bad Request.Try again'),
            duration: Duration(seconds: 2),
          ),
        );
        print(
            'Failed to upload profile picture. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        print('Table ID: $tableId');
        print('Image Name: $filename');
      } else if (response.statusCode == 500) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Internal Server Error. Please try again later'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error uploading profile picture: $e');
    }
  }

  static Future<String?> fetchUserId() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        print('Token not found');
        return null;
      }

      // Make a GET request to fetch the user ID
      final response = await http.get(
        Uri.parse('${URLConstants.baseUrl}/api/profileimg'),
        headers: {
          'Authorization': 'token $token',
          'Content-Type': 'application/json',
        },
      );

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // Parse the response body (assuming it's JSON)
        final List<dynamic> responseData = json.decode(response.body);

        // Check if the response contains any data
        if (responseData.isNotEmpty) {
          // Access the first object in the array
          final dynamic firstItem = responseData.first;

          // Extract the user ID from the first item
          final int? id = firstItem['id'];

          // Return the userId
          return id.toString(); // Convert int to String
        } else {
          print('Response is empty');
          return null;
        }
      } else {
        // Handle unsuccessful request
        print('Failed to fetch user ID. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      // Handle any errors that occur during the request
      print('Error fetching user ID: $e');
      return null;
    }
  }
}

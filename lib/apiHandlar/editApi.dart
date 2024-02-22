import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wHRMS/View/home_screen.dart';
import 'package:wHRMS/apiHandlar/baseUrl.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Update Work Api Method
class UpdateWorkApi {
  static const String apiUrl = '${URLConstants.baseUrl}/api/work_experiences';

  static Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<List<Map<String, dynamic>>?> getUserWorkExperiences(
      String token) async {
    try {
      var headers = {
        'Authorization': 'token $token',
      };

      var response = await http.get(
        Uri.parse(apiUrl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return List<Map<String, dynamic>>.from(jsonResponse);
      } else {
        print(
            'Error fetching user work experiences. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching user work experiences: $e');
      return null;
    }
  }

  static Future<void> updateWorkData(
      Map<String, dynamic> updateWorkData, BuildContext context) async {
    try {
      String? token = await getAuthToken();

      if (token == null) {
        print('Token not found in shared preferences');
        return;
      }

      List<Map<String, dynamic>>? userWorkExperiences =
          await UpdateWorkApi.getUserWorkExperiences(token);

      if (userWorkExperiences != null && userWorkExperiences.isNotEmpty) {
        Map<String, dynamic> latestWorkExperience = userWorkExperiences.last;

        // Use 'table_id' as the field name
        String? workExperienceId = latestWorkExperience['id'].toString();

        if (workExperienceId.isEmpty) {
          print('Error: Work Experience ID is null or empty.');
          return;
        }

        String dynamicUrl = '$apiUrl';
        print('Dynamic URL: $dynamicUrl');

        var headers = {
          'Authorization': 'token $token',
          'Content-Type': 'application/json',
        };

        updateWorkData['id'] = workExperienceId;

        var response = await http.put(
          Uri.parse(dynamicUrl),
          headers: headers,
          body: json.encode(updateWorkData),
        );

        print('Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        print('Request Body: ${json.encode(updateWorkData)}');
        print('Token: $token');
        print('Id : $workExperienceId');

        if (response.statusCode == 200 || response.statusCode == 201) {
          print('Data updated successfully');

          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              content: Text('Work Experience Updated Successfully'),
              duration: Duration(seconds: 2),
            ),
          );
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        } else if (response.statusCode == 400) {
          // Bad request - Handle the specific error scenario
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text('Bad request. Please check your data.'),
            ),
          );
        } else if (response.statusCode == 401) {
          // Unauthorized - Handle the specific error scenario
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text('Unauthorized. Please log in again.'),
            ),
          );
        } else if (response.statusCode == 500) {
          // Internal server error - Handle the specific error scenario
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text('Internal server error. Please try again later.'),
            ),
          );
        } else {
          // Other errors - Handle any other error scenarios
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text('Failed to update Work Experience data.'),
            ),
          );
        }
      } else {
        // No Employee Education found - Handle the specific error scenario
        print('No Work Experience found.');
      }
    } catch (e) {
      print('Error Work Experience data: $e');
      // Show a generic error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error Work Experience data.'),
        ),
      );
    }
  }
}

// Education Update Method Handler
class UpdateEducationApi {
  static const String apiUrl = '${URLConstants.baseUrl}/api/education';

  static Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<List<Map<String, dynamic>>?> getEducation(String token) async {
    try {
      var headers = {
        'Authorization': 'token $token',
      };

      var response = await http.get(
        Uri.parse(apiUrl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return List<Map<String, dynamic>>.from(jsonResponse);
      } else {
        print(
            'Error fetching user Education Details. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching user Education Details: $e');
      return null;
    }
  }

  static Future<void> educationData(Map<String, dynamic> educationData,
      String educationId, BuildContext context) async {
    try {
      String? token = await getAuthToken();

      if (token == null) {
        print('Token not found in shared preferences');
        return;
      }

      String dynamicUrl = '$apiUrl';
      print('Dynamic URL: $dynamicUrl');

      var headers = {
        'Authorization': 'token $token',
        'Content-Type': 'application/json',
      };

      educationData['table_id'] = educationId;

      var response = await http.put(
        Uri.parse(dynamicUrl),
        headers: headers,
        body: json.encode(educationData),
      );

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('Request Body: ${json.encode(educationData)}');
      print('Token: $token');
      print('Id : $educationId');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Data updated successfully');

        // Show a Snackbar with a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Education Data Updated Successfully'),
            duration: Duration(seconds: 2),
          ),
        );
        // Navigate back to the home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      } else if (response.statusCode == 400) {
        // Bad request - Handle the specific error scenario
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Bad request. Please check your data.'),
          ),
        );
      } else if (response.statusCode == 401) {
        // Unauthorized - Handle the specific error scenario
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Unauthorized. Please log in again.'),
          ),
        );
      } else if (response.statusCode == 500) {
        // Internal server error - Handle the specific error scenario
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Internal server error. Please try again later.'),
          ),
        );
      } else {
        // Other errors - Handle any other error scenarios
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Failed to update education data.'),
          ),
        );
      }
    } catch (e) {
      print('Error updating Education data: $e');
      // Show a generic error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Error updating education data.'),
        ),
      );
    }
  }
}

//Personal Information Update Api Method
class PersonalApi {
  static const String apiUrl = '${URLConstants.baseUrl}/api/employee';

  static Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<List<Map<String, dynamic>>?> getPersonalInformation(
      String token) async {
    try {
      var headers = {
        'Authorization': 'token $token',
      };

      var response = await http.get(
        Uri.parse(apiUrl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return List<Map<String, dynamic>>.from(jsonResponse);
      } else {
        print(
            'Error fetching user Personal Information. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching user Personal Information: $e');
      return null;
    }
  }

  static Future<void> personalInformationData(
      Map<String, dynamic> personalInformationData,
      BuildContext context) async {
    try {
      String? token = await getAuthToken();

      if (token == null) {
        print('Token not found in shared preferences');
        return;
      }

      List<Map<String, dynamic>>? userPersonal =
          await getPersonalInformation(token);

      if (userPersonal != null && userPersonal.isNotEmpty) {
        Map<String, dynamic> personalWork = userPersonal.last;

        // Use 'table_id' as the field name
        String? personalId = personalWork['id'].toString();

        if (personalId.isEmpty) {
          print('Error: Personal Information ID is null or empty.');
          return;
        }

        String dynamicUrl = '$apiUrl';
        print('Dynamic URL: $dynamicUrl');

        var headers = {
          'Authorization': 'token $token',
          'Content-Type': 'application/json',
        };

        personalInformationData['table_id'] = personalId;

        var response = await http.put(
          Uri.parse(dynamicUrl),
          headers: headers,
          body: json.encode(personalInformationData),
        );

        print('Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        print('Request Body: ${json.encode(personalInformationData)}');
        print('Token: $token');
        print('Id : $personalId');

        if (response.statusCode == 200 || response.statusCode == 201) {
          print('Data updated successfully');

          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              content: Text('Personal Information Updated Successfully'),
              duration: Duration(seconds: 2),
            ),
          );
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
          print('Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        } else if (response.statusCode == 400) {
          // Bad request - Handle the specific error scenario
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text('Bad request. Please check your data.'),
            ),
          );
          print('Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        } else if (response.statusCode == 401) {
          // Unauthorized - Handle the specific error scenario
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text('Unauthorized. Please log in again.'),
            ),
          );
          print('Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        } else if (response.statusCode == 500) {
          // Internal server error - Handle the specific error scenario
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.blue,
              content: Text('Internal server error. Please try again later.'),
            ),
          );
          print('Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
        } else {
          // Other errors - Handle any other error scenarios
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text('Failed to update Personal Information data.'),
            ),
          );
        }
        print('Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      } else {
        // No Employee Education found - Handle the specific error scenario
        print('No Employee Personal Information found.');
      }
    } catch (e) {
      print('Error updating Personal Information data: $e');
      // Show a generic error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Error updating Personal Information data.'),
        ),
      );
    }
  }
}

//Profile Image Update Method

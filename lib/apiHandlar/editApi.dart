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
        // print(
        //     'Error fetching user work experiences. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // print('Error fetching user work experiences: $e');
      return null;
    }
  }

  static Future<void> updateWorkData(
      Map<String, dynamic> updateWorkData, BuildContext context) async {
    try {
      String? token = await getAuthToken();

      if (token == null) {
        // print('Token not found in shared preferences');
        return;
      }

      List<Map<String, dynamic>>? userWorkExperiences =
          await UpdateWorkApi.getUserWorkExperiences(token);

      if (userWorkExperiences != null && userWorkExperiences.isNotEmpty) {
        Map<String, dynamic> latestWorkExperience = userWorkExperiences.last;

        // Use 'table_id' as the field name
        String? workExperienceId = latestWorkExperience['id'].toString();

        if (workExperienceId.isEmpty) {
          // print('Error: Work Experience ID is null or empty.');
          return;
        }

        String dynamicUrl = '$apiUrl';
        // print('Dynamic URL: $dynamicUrl');

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

        // print('Status code: ${response.statusCode}');
        // print('Response body: ${response.body}');
        // print('Request Body: ${json.encode(updateWorkData)}');
        // print('Token: $token');
        // print('Id : $workExperienceId');

        if (response.statusCode == 200 || response.statusCode == 201) {
          // print('Data updated successfully');

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
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        } else if (response.statusCode == 400) {
          // Bad request - Handle the specific error scenario
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text('Bad request. Please check your data.'),
            ),
          );
        } else if (response.statusCode == 401) {
          // Unauthorized - Handle the specific error scenario
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text('Unauthorized. Please log in again.'),
            ),
          );
        } else if (response.statusCode == 500) {
          // Internal server error - Handle the specific error scenario
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text('Internal server error. Please try again later.'),
            ),
          );
        } else {
          // Other errors - Handle any other error scenarios
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text('Failed to update Work Experience data.'),
            ),
          );
        }
      } else {
        // No Employee Education found - Handle the specific error scenario
        // print('No Work Experience found.');
      }
    } catch (e) {
      // print('Error Work Experience data: $e');
      // Show a generic error message
      // ignore: use_build_context_synchronously
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
        // print(
        //     'Error fetching user Education Details. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // print('Error fetching user Education Details: $e');
      return null;
    }
  }

  static Future<void> educationData(Map<String, dynamic> educationData,
      String educationId, BuildContext context) async {
    try {
      String? token = await getAuthToken();

      if (token == null) {
        // print('Token not found in shared preferences');
        return;
      }

      String dynamicUrl = '$apiUrl';
      // print('Dynamic URL: $dynamicUrl');

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

      // print('Status code: ${response.statusCode}');
      // print('Response body: ${response.body}');
      // print('Request Body: ${json.encode(educationData)}');
      // print('Token: $token');
      // print('Id : $educationId');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // print('Data updated successfully');

        // Show a Snackbar with a success message
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Education Data Updated Successfully'),
            duration: Duration(seconds: 2),
          ),
        );
        // Navigate back to the home screen
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      } else if (response.statusCode == 400) {
        // Bad request - Handle the specific error scenario
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Bad request. Please check your data.'),
          ),
        );
      } else if (response.statusCode == 401) {
        // Unauthorized - Handle the specific error scenario
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Unauthorized. Please log in again.'),
          ),
        );
      } else if (response.statusCode == 500) {
        // Internal server error - Handle the specific error scenario
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Internal server error. Please try again later.'),
          ),
        );
      } else {
        // Other errors - Handle any other error scenarios
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Failed to update education data.'),
          ),
        );
      }
    } catch (e) {
      // print('Error updating Education data: $e');
      // Show a generic error message
      // ignore: use_build_context_synchronously
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
        // print(
        //     'Error fetching user Personal Information. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // print('Error fetching user Personal Information: $e');
      return null;
    }
  }

  static Future<void> personalInformationData(
      Map<String, dynamic> personalInformationData,
      BuildContext context) async {
    try {
      String? token = await getAuthToken();

      if (token == null) {
        // print('Token not found in shared preferences');
        return;
      }

      List<Map<String, dynamic>>? userPersonal =
          await getPersonalInformation(token);

      if (userPersonal != null && userPersonal.isNotEmpty) {
        Map<String, dynamic> personalWork = userPersonal.last;

        // Use 'table_id' as the field name
        String? personalId = personalWork['id'].toString();

        if (personalId.isEmpty) {
          // print('Error: Personal Information ID is null or empty.');
          return;
        }

        String dynamicUrl = '$apiUrl';
        // print('Dynamic URL: $dynamicUrl');

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

        // print('Status code: ${response.statusCode}');
        // print('Response body: ${response.body}');
        // print('Request Body: ${json.encode(personalInformationData)}');
        // print('Token: $token');
        // print('Id : $personalId');

        if (response.statusCode == 200 || response.statusCode == 201) {
          // print('Data updated successfully');

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
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
          // print('Status code: ${response.statusCode}');
          // print('Response body: ${response.body}');
        } else if (response.statusCode == 400) {
          // Bad request - Handle the specific error scenario
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text('Bad request. Please check your data.'),
            ),
          );
          // print('Status code: ${response.statusCode}');
          // print('Response body: ${response.body}');
        } else if (response.statusCode == 401) {
          // Unauthorized - Handle the specific error scenario
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text('Unauthorized. Please log in again.'),
            ),
          );
          // print('Status code: ${response.statusCode}');
          // print('Response body: ${response.body}');
        } else if (response.statusCode == 500) {
          // Internal server error - Handle the specific error scenario
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.blue,
              content: Text('Internal server error. Please try again later.'),
            ),
          );
          // print('Status code: ${response.statusCode}');
          // print('Response body: ${response.body}');
        } else {
          // Other errors - Handle any other error scenarios
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text('Failed to update Personal Information data.'),
            ),
          );
        }
        // print('Status code: ${response.statusCode}');
        // print('Response body: ${response.body}');
      } else {
        // No Employee Education found - Handle the specific error scenario
        // print('No Employee Personal Information found.');
      }
    } catch (e) {
      // print('Error updating Personal Information data: $e');
      // Show a generic error message
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Error updating Personal Information data.'),
        ),
      );
    }
  }
}

//Family Update Method
class FamilyApi {
  static const String familyapiUrl = '${URLConstants.baseUrl}/api/familyinfo';

  static Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<List<Map<String, dynamic>>?> getFamily(String token) async {
    try {
      var headers = {
        'Authorization': 'token $token',
      };

      var response = await http.get(
        Uri.parse(familyapiUrl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return List<Map<String, dynamic>>.from(jsonResponse);
      } else {
        // print(
        //     'Error fetching user Education Details. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // print('Error fetching user Education Details: $e');
      return null;
    }
  }

  static Future<void> familyData(
      Map<String, dynamic> familyData, BuildContext context) async {
    try {
      String? token = await getAuthToken();

      if (token == null) {
        // print('Token not found in shared preferences');
        return;
      }

      // Get the family data to retrieve the ID
      List<Map<String, dynamic>>? familyList = await getFamily(token);
      if (familyList == null || familyList.isEmpty) {
        // print('Error fetching family data or empty response');
        return;
      }

      // Assuming you want to update the first family in the list
      Map<String, dynamic> firstFamily = familyList.first;
      String familyId = firstFamily['id'].toString(); // Convert ID to string

      var headers = {
        'Authorization': 'token $token',
        'Content-Type': 'application/json',
      };

      familyData['table_id'] = familyId;

      var response = await http.put(
        Uri.parse(familyapiUrl),
        headers: headers,
        body: json.encode(familyData),
      );

      // print('Status code: ${response.statusCode}');
      // print('Response body: ${response.body}');
      // print('Request Body: ${json.encode(familyData)}');
      // print('Token: $token');
      // print('Id : $familyId');

      // Handle response based on status code
      if (response.statusCode == 200 || response.statusCode == 201) {
        // print('Data updated successfully');
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Family Information Data Updated Successfully'),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      } else if (response.statusCode == 400) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Bad request. Please check your data.'),
          ),
        );
      } else if (response.statusCode == 401) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Unauthorized. Please log in again.'),
          ),
        );
      } else if (response.statusCode == 500) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Internal server error. Please try again later.'),
          ),
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Failed to update Family Information data.'),
          ),
        );
      }
    } catch (e) {
      // print('Error updating Family Information data: $e');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Error updating Family Information data.'),
        ),
      );
    }
  }
}


// class CompanyPersonalApi {
//   static const String companyapiUrl = '${URLConstants.baseUrl}/api/user';

//   static Future<String?> getAuthToken() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('token');
//   }

//   static Future<Map<String, dynamic>?> getCompanyInformation(
//       String token) async {
//     try {
//       var headers = {
//         'Authorization': 'token $token',
//       };

//       var response = await http.get(
//         Uri.parse(companyapiUrl),
//         headers: headers,
//       );

//       if (response.statusCode == 200) {
//         return json.decode(response.body); // Return the map directly
//       } else {
//         print(
//             'Error fetching user Company Information. Status code: ${response.statusCode}');
//         print(
//             'Error fetching user Company Information. Response Body: ${response.body}');
//         return null;
//       }
//     } catch (e) {
//       print('Error fetching user Company Information: $e');
//       return null;
//     }
//   }

//   static Future<void> companyInformationData(
//       Map<String, dynamic> companyInformationData, BuildContext context) async {
//     try {
//       String? token = await getAuthToken();

//       if (token == null) {
//         print('Token not found in shared preferences');
//         return;
//       }

//       Map<String, dynamic>? companyPersonal =
//           await getCompanyInformation(token);

//       if (companyPersonal != null) {
//         String? companyId = companyPersonal['id'].toString();

//         if (companyId.isEmpty) {
//           print('Error: Company Information ID is null or empty.');
//           return;
//         }

//         String dynamicUrl = '$companyapiUrl';
//         print('Dynamic URL: $dynamicUrl');

//         var headers = {
//           'Authorization': 'token $token',
//           'Content-Type': 'application/json',
//         };

//         companyInformationData['table_id'] = companyId;

//         var response = await http.put(
//           Uri.parse(dynamicUrl),
//           headers: headers,
//           body: json.encode(companyInformationData),
//         );

//         print('Status code: ${response.statusCode}');
//         print('Response body: ${response.body}');
//         print('Request Body: ${json.encode(companyInformationData)}');
//         print('Token: $token');
//         print('Id : $companyId');

//         if (response.statusCode == 200 || response.statusCode == 201) {
//           print('Data updated successfully');

//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               backgroundColor: Colors.green,
//               content: Text('Company Information Updated Successfully'),
//               duration: Duration(seconds: 2),
//             ),
//           );

//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (context) => const HomeScreen(),
//             ),
//           );
//         } else if (response.statusCode == 400) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               backgroundColor: Colors.red,
//               content: Text('Bad request. Please check your data.'),
//             ),
//           );
//         } else if (response.statusCode == 401) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               backgroundColor: Colors.red,
//               content: Text('Unauthorized. Please log in again.'),
//             ),
//           );
//         } else if (response.statusCode == 500) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               backgroundColor: Colors.blue,
//               content: Text('Internal server error. Please try again later.'),
//             ),
//           );
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               backgroundColor: Colors.red,
//               content: Text('Failed to update Company Information data.'),
//             ),
//           );
//         }
//       } else {
//         print('No Employee Company Information found.');
//       }
//     } catch (e) {
//       print('Error updating Company Information data: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           backgroundColor: Colors.red,
//           content: Text('Error updating Company Information data.'),
//         ),
//       );
//     }
//   }
// }

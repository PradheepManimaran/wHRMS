import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wHRMS/View/home_screen.dart';
import 'package:wHRMS/apiHandlar/baseUrl.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Personal Api Post Method
class ApiHelper {
  static Future<void> postData(
      Map<String, dynamic> postData, BuildContext context) async {
    const String apiUrl = '${URLConstants.baseUrl}/api/employee';

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        // if (kDebugMode) {
        //   print('Token not found in shared preferences');
        // }
        return;
      }

      // Add token to headers
      var headers = {
        'Authorization': 'token $token',
        'Content-Type': 'application/json',
      };

      var response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: json.encode(postData),
      );

      if (response.statusCode == 201) {
        // if (kDebugMode) {
        //   print('Data posted successfully');
        // }
        // if (kDebugMode) {
        //   print('status code : ${response.statusCode}');
        // }
        // if (kDebugMode) {
        //   print('Response body: ${response.body}');
        // }
        // if (kDebugMode) {
        //   print('Token: $token');
        // }

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Employee Information Posted Successfully'),
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
        // Bad request - Invalid email format
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Bad Request: Error creating Employee.'),
          ),
        );
        // print('Test Response Employee: ${response.body}');
      } else if (response.statusCode == 401) {
        // Unauthorized - User not found
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Authorized Error: Please login again.'),
          ),
        );
      } else if (response.statusCode == 500) {
        // Internal server error
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.blue,
            content: Text('Internal server error. Please try again later.'),
          ),
        );
        // if (kDebugMode) {
        //   print('Employee Status code: ${response.statusCode}');
        // }
        // if (kDebugMode) {
        //   print('Employee body: ${response.body}');
        // }
      } else {
        // Other errors
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to Work Upload.'),
          ),
        );
      }
    } catch (e) {
      // if (kDebugMode) {
      //   print('Error sending Work Experience: $e');
      // }
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error sending Work Experience.'),
        ),
      );
    }
  }
}

//Work Experience Post Method

class WorkApi {
  static Future<void> workData(
      BuildContext context, Map<String, dynamic> workData, int userId) async {
    const String apiUrl = '${URLConstants.baseUrl}/api/work_experiences';

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        // if (kDebugMode) {
        //   print('Token not found in shared preferences');
        // }
        return;
      }

      // Add token to headers
      var headers = {
        'Authorization': 'token $token',
        'Content-Type': 'application/json',
      };

      // Add user ID to the workData map
      workData['user'] = userId;

      var response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: json.encode(workData),
      );

      if (response.statusCode == 201) {
        // if (kDebugMode) {
        //   print('Data posted successfully');
        // }
        // if (kDebugMode) {
        //   print('Status code: ${response.statusCode}');
        // }
        // if (kDebugMode) {
        //   print('Response body: ${response.body}');
        // }
        // if (kDebugMode) {
        //   print('Token: $token');
        // }
        // Handle successful response
      } else if (response.statusCode == 400) {
        // Bad request - Invalid email format
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Bad Request: Work Experience.'),
          ),
        );
      } else if (response.statusCode == 401) {
        // Unauthorized - User not found
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Authorized Error: Please login again.'),
          ),
        );
      } else if (response.statusCode == 500) {
        // Internal server error
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.blue,
            content: Text('Internal server error. Please try again later.'),
          ),
        );
      } else {
        // Other errors
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to Work Upload.'),
          ),
        );
      }
    } catch (e) {
      // if (kDebugMode) {
      //   print('Error sending Work Experience: $e');
      // }
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error sending Work Experience.'),
        ),
      );
    }
  }
}
// Education Post method

class EducationApi {
  static Future<void> educationData(BuildContext context,
      Map<String, dynamic> educationData, int educationId) async {
    const String apiUrl = '${URLConstants.baseUrl}/api/education';

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        // if (kDebugMode) {
        //   print('Token not found in shared preferences');
        // }
        return;
      }

      // Add token to headers
      var headers = {
        'Authorization': 'token $token',
        'Content-Type': 'application/json',
      };

      educationData['user'] = educationId;

      var response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: json.encode(educationData),
      );

      if (response.statusCode == 201) {
        // if (kDebugMode) {
        //   print('Data posted successfully');
        // }
        // if (kDebugMode) {
        //   print('status code : ${response.statusCode}');
        // }
        // if (kDebugMode) {
        //   print('Response body: ${response.body}');
        // }
        // if (kDebugMode) {
        //   print('Education user Table: $educationId');
        // }
        // if (kDebugMode) {
        //   print('Token: $token');
        // }
        // Handle successful response
      } else if (response.statusCode == 400) {
        // Bad request - Invalid email format
        // if (kDebugMode) {
        //   print('Education Response StatusCode: ${response.statusCode}');
        // }
        // if (kDebugMode) {
        //   print('Education Response Body: ${response.body}');
        // }
        // if (kDebugMode) {
        //   print('Education user Table: $educationId');
        // }
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Bad Request: Education Details.'),
          ),
        );
      } else if (response.statusCode == 401) {
        // Unauthorized - User not found
        // if (kDebugMode) {
        //   print('Education Response StatusCode: ${response.statusCode}');
        // }
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Authorized Error: Please login again.'),
          ),
        );
        // if (kDebugMode) {
        //   print('Education user Table: $educationId');
        // }
      } else if (response.statusCode == 500) {
        // Internal server error
        // if (kDebugMode) {
        //   print('Education Response StatusCode: ${response.statusCode}');
        // }
        // if (kDebugMode) {
        //   print('Education Response Body: ${response.body}');
        // }
        // if (kDebugMode) {
        //   print('Education user Table: $educationId');
        // }
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.blue,
            content: Text('Internal server error. Please try again later.'),
          ),
        );
      } else {
        // Other errors
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to Educatuon Upload.'),
          ),
        );
      }
    } catch (e) {
      // if (kDebugMode) {
      //   print('Error sending Work Experience: $e');
      // }
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error occured Education.'),
        ),
      );
    }
  }
}

// Image Upload Api Method
//Profile Image Upload Method
class ImageUpload {
  static const String apiUrl = '${URLConstants.baseUrl}/api/employee';

  static Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> uploadImages(
    File profilePictureImage,
  ) async {
    try {
      String? token = await getAuthToken();

      if (token == null) {
        // if (kDebugMode) {
        //   print('Token not found in shared preferences');
        // }
        return;
      }

      if (!await profilePictureImage.exists()) {
        // if (kDebugMode) {
        //   print('Error: Profile Picture selected files do not exist.');
        // }
        return;
      }

      // POST API method for image upload
      String dynamicUrl = '${URLConstants.baseUrl}/api/profileimg';
      // if (kDebugMode) {
      //   print('Dynamic URL: $dynamicUrl');
      // }

      var headers = {
        'Authorization': 'token $token',
      };

      var request = http.MultipartRequest('POST', Uri.parse(dynamicUrl))
        ..headers.addAll(headers);

      request.files.add(
        await http.MultipartFile.fromPath(
          'profile_picture',
          profilePictureImage.path,
        ),
      );

      var response = await request.send();

      // if (kDebugMode) {
      //   print('Status code: ${response.statusCode}');
      // }
      // if (kDebugMode) {
      //   print('Token: $token');
      // }
      // print('Id: $userEmployeeID');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // if (kDebugMode) {
        //   print('Data Profile Picture successfully');
        // }
      } else {
        // if (kDebugMode) {
        //   print('statusCode: ${response.statusCode}');
        // }
        // if (kDebugMode) {
        //   print('Error Profile Picture Upload data.');
        // }
      }
    } catch (e) {
      //   if (kDebugMode) {
      //     print('Error Profile Picture Upload data: $e');
      //   }
    }
  }
}

//AadharImage Upload
class AadharImage {
  static const String apiUrl = '${URLConstants.baseUrl}/api/employee';

  static Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> uploadAadharImages(
    File adharCardImage,
  ) async {
    try {
      String? token = await getAuthToken();

      if (token == null) {
        // if (kDebugMode) {
        //   print('Token not found in shared preferences');
        // }
        return;
      }

      if (!await adharCardImage.exists()) {
        // if (kDebugMode) {
        //   print('Error: Aadhar Image selected files do not exist.');
        // }
        return;
      }

      // POST API method for image upload
      String dynamicUrl = '${URLConstants.baseUrl}/api/adharimg';
      // if (kDebugMode) {
      //   print('Dynamic URL: $dynamicUrl');
      // }

      var headers = {
        'Authorization': 'token $token',
      };

      var request = http.MultipartRequest('POST', Uri.parse(dynamicUrl))
        ..headers.addAll(headers);

      request.files.add(
        await http.MultipartFile.fromPath('adhar_card', adharCardImage.path),
      );

      var response = await request.send();

      // if (kDebugMode) {
      //   print('Status code: ${response.statusCode}');
      // }
      // if (kDebugMode) {
      //   print('Token: $token');
      // }
      // print('Id: $userEmployeeID');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // if (kDebugMode) {
        //   print('Aadhar Image Upload successfully');
        // }
      } else {
        // if (kDebugMode) {
        //   print('statusCode: ${response.statusCode}');
        // }
        // if (kDebugMode) {
        //   print('Error Aadhar Upload data.');
        // }
      }
    } catch (e) {
      // if (kDebugMode) {
      //   print('Error Aadhar Upload data: $e');
      // }
    }
  }
}

//Update Image Method
// class ImageUpload {
//   static const String apiUrl = '${URLConstants.baseUrl}/api/employee';
//   static const String imgUrl = '${URLConstants.baseUrl}/api/profileimg';

//   static Future<String?> getAuthToken() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('token');
//   }

//   static Future<String?> getUserEmployeeID(String token) async {
//     try {
//       var response = await http.get(
//         Uri.parse('$apiUrl'),
//         headers: {'Authorization': 'token $token'},
//       );

//       if (response.statusCode == 200) {
//         List<dynamic> dataList = json.decode(response.body);

//         if (dataList.isNotEmpty) {
//           Map<String, dynamic> data = dataList[0];
//           String? employeeID = data['id']?.toString();

//           // Print the retrieved ID before checking if it's null or empty
//           print('Retrieved Employee ID: $employeeID');

//           if (employeeID == null || employeeID.isEmpty) {
//             print('Error: Employee ID is null or empty.');
//             return null;
//           }

//           return employeeID;
//         } else {
//           print('Error: Empty data list in the response.');
//           return null;
//         }
//       } else {
//         print('Error in GET User API. Status code: ${response.statusCode}');
//         print('Response body: ${response.body}');
//         return null;
//       }
//     } catch (e) {
//       print('Error in GET User API: $e');
//       return null;
//     }
//   }

//   static Future<String?> getProfileImgID(String token) async {
//     try {
//       var response = await http.get(
//         Uri.parse('$imgUrl'),
//         headers: {'Authorization': 'token $token'},
//       );

//       if (response.statusCode == 200) {
//         List<dynamic> dataList = json.decode(response.body);

//         if (dataList.isNotEmpty) {
//           Map<String, dynamic> data = dataList[0];
//           String? profileimgID = data['id']?.toString();

//           // Print the retrieved ID before checking if it's null or empty
//           print('Retrieved Profile Image ID: $profileimgID');

//           if (profileimgID == null || profileimgID.isEmpty) {
//             print('Error: Profile Image ID is null or empty.');
//             return null;
//           }

//           return profileimgID;
//         } else {
//           print('Error: Empty data list in the response.');
//           return null;
//         }
//       } else {
//         print('Error in GET User API. Status code: ${response.statusCode}');
//         print('Response body: ${response.body}');
//         return null;
//       }
//     } catch (e) {
//       print('Error in GET User API: $e');
//       return null;
//     }
//   }

//   static Future<void> uploadImages(
//     File adharCardImage,
//     File profilePictureImage,
//   ) async {
//     try {
//       String? token = await getAuthToken();

//       if (token == null) {
//         print('Token not found in shared preferences');
//         return;
//       }

//       String? userEmployeeID = await getUserEmployeeID(token);
//       String? profileImageID = await getProfileImgID(token);

//       if (userEmployeeID == null || profileImageID == null) {
//         print('Error: Employee ID not retrieved.');
//         print('Error: Profile image ID not retrieved.');
//         return;
//       }

//       // Check if the selected image files exist
//       if (!await adharCardImage.exists() ||
//           !await profilePictureImage.exists()) {
//         print('Error: One or both of the selected files do not exist.');
//         return;
//       }

//       // POST API method for image upload
//       String dynamicUrl =
//           '${URLConstants.baseUrl}/api/profileimg/$profileImageID';
//       print('Put method URL: $dynamicUrl');

//       var headers = {
//         'Authorization': 'token $token',
//       };

//       var request = http.MultipartRequest('PUT', Uri.parse(dynamicUrl))
//         ..headers.addAll(headers)
//         ..fields['employee'] = userEmployeeID;

//       request.files.add(
//         await http.MultipartFile.fromPath('adhar_card', adharCardImage.path),
//       );

//       request.files.add(
//         await http.MultipartFile.fromPath(
//           'profile_picture',
//           profilePictureImage.path,
//         ),
//       );

//       var response = await request.send();

//       print('Status code: ${response.statusCode}');
//       print('Token: $token');
//       print('Id: $userEmployeeID');

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         print('Data updated successfully');
//       } else {
//         print('statusCode: ${response.statusCode}');
//         print('Error updating data.');
//       }
//     } catch (e) {
//       print('Error updating data: $e');
//     }
//   }
// }

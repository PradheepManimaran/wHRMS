import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wHRMS/ThemeColor/theme.dart';
import 'package:wHRMS/View/home_screen.dart';
import 'package:wHRMS/apiHandlar/baseUrl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CertificateScreen extends StatefulWidget {
  const CertificateScreen({Key? key}) : super(key: key);

  @override
  State<CertificateScreen> createState() => _CertificateScreenState();
}

class _CertificateScreenState extends State<CertificateScreen> {
  TextEditingController sslcController = TextEditingController();
  TextEditingController hscController = TextEditingController();
  TextEditingController ugController = TextEditingController();
  TextEditingController pgController = TextEditingController();

  File? sslcCertificate;
  File? hscCertificate;
  File? ugCertificate;
  File? pgCertificate;

  Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> fetchCertificate() async {
    const apiUrl = '${URLConstants.baseUrl}/api/certificates';

    try {
      String? token = await getAuthToken();
      // userID['user'] = userID;
      if (token == null) {
        print('Token not found in Shared preferences');
        return;
      }
      final sslc = sslcCertificate;
      final hsc = hscCertificate;
      final ug = ugCertificate;
      final pg = pgCertificate;

      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.headers['Authorization'] = 'token $token';
      request.files.add(
          await http.MultipartFile.fromPath('sslc_certificate', sslc!.path));
      request.files
          .add(await http.MultipartFile.fromPath('hsc_certificate', hsc!.path));
      request.files
          .add(await http.MultipartFile.fromPath('ug_certificate', ug!.path));
      request.files
          .add(await http.MultipartFile.fromPath('pg_certificate', pg!.path));

      var response = await request.send();

      if (response.statusCode == 201) {
        print('Certificate verified successfully');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('File Successfully Upload.Thank You.'),
          ),
        );
      } else if (response.statusCode == 400) {
        print('Bad Request : ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Bad Request:File Not Upload.Thank You.'),
          ),
        );
        print('Bad Request : ${await response.stream.bytesToString()}');
      } else if (response.statusCode == 500) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
                'Internal Server Error. Please try again later.Thank You.'),
          ),
        );
        print('Server Error : ${await response.stream.bytesToString()}');
      }
    } catch (e) {
      // _handleError(e);
    }
  }

  void _pickFile(String fileType) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        PlatformFile file = result.files.first;

        String filePath = file.path!;
        String fileName = filePath.split('/').last;

        File pickedFile = File(filePath);

        switch (fileType) {
          case 'sslc':
            setState(() {
              sslcCertificate = pickedFile;
              sslcController.text = fileName;
            });
            break;
          case 'hsc':
            setState(() {
              hscCertificate = pickedFile;
              hscController.text = fileName;
            });
            break;
          case 'ug':
            setState(() {
              ugCertificate = pickedFile;
              ugController.text = fileName;
            });
            break;
          case 'pg':
            setState(() {
              pgCertificate = pickedFile;
              pgController.text = fileName;
            });
            break;
          default:
            print('Invalid file type');
        }
      } else {
        print('User canceled file picking');
      }
    } catch (e) {
      print('Error picking file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Certificate Screen',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: ThemeColor.app_bar,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
          child: Column(
            children: [
              _buildTextImage(
                controller: sslcController,
                hintText: 'SSLC Certificate',
                prefixIconData: Icons.file_copy,
                isButton: true,
                onTap: () => _pickFile('sslc'),
                showFileChooser: sslcCertificate == null,
              ),
              const SizedBox(height: 15),
              _buildTextImage(
                controller: hscController,
                hintText: 'HSC Certificate',
                prefixIconData: Icons.file_copy,
                isButton: true,
                onTap: () => _pickFile('hsc'),
                showFileChooser: hscCertificate == null,
              ),
              const SizedBox(height: 15),
              _buildTextImage(
                controller: ugController,
                hintText: 'UG Certificate',
                prefixIconData: Icons.file_copy,
                isButton: true,
                onTap: () => _pickFile('ug'),
                showFileChooser: ugCertificate == null,
              ),
              const SizedBox(height: 15),
              _buildTextImage(
                controller: pgController,
                hintText: 'PG Certificate',
                prefixIconData: Icons.file_copy,
                isButton: true,
                onTap: () => _pickFile('pg'),
                showFileChooser: pgCertificate == null,
              ),
              const SizedBox(height: 15),
              // ElevatedButton(
              //   onPressed: () => fetchCertificate(),
              //   child: const Text('Submit'),
              // ),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: double.infinity,
                  height: 60.0,
                  child: ElevatedButton(
                    onPressed: () => fetchCertificate(),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1.0),
                      ),
                      backgroundColor: ThemeColor.app_bar,
                    ),
                    child: const Text(
                      'SUBMIT',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextImage({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIconData,
    bool isButton = false,
    VoidCallback? onTap,
    bool showFileChooser = false,
  }) {
    if (showFileChooser) {
      return Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                prefixIcon: Icon(prefixIconData),
                border: const OutlineInputBorder(),
              ),
              readOnly: true,
            ),
          ),
          IconButton(
            onPressed: onTap,
            icon: const Icon(Icons.attach_file),
          ),
        ],
      );
    } else {
      return TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(prefixIconData),
          border: const OutlineInputBorder(),
        ),
        readOnly: true,
      );
    }
  }
}

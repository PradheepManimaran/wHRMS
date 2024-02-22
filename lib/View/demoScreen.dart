import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:wHRMS/apiHandlar/baseUrl.dart';
import 'package:wHRMS/objects/certificateObject.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CertificateScreens extends StatefulWidget {
  const CertificateScreens({Key? key}) : super(key: key);

  @override
  State<CertificateScreens> createState() => _CertificateScreenState();
}

class _CertificateScreenState extends State<CertificateScreens> {
  CertificateProfile? userProfile;

  @override
  void initState() {
    super.initState();
    _fetchFile();
  }

  Future<void> _fetchFile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse('${URLConstants.baseUrl}/api/certificates'),
        headers: {
          'Authorization': 'token $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> dataList = jsonDecode(response.body);

        print(
            'Received JSON response: $dataList'); // Add this line for debugging

        if (dataList.isNotEmpty) {
          final Map<String, dynamic> userData = dataList.first;
          setState(() {
            userProfile = CertificateProfile.fromJson(userData);
          });

          print('Fetched certificate data successfully.');
        } else {
          print('Empty response');
        }
      } else {
        print('Failed to load file data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading file data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Certificate Viewer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (userProfile != null && userProfile!.sslcCertificate.isNotEmpty)
              ElevatedButton(
                onPressed: () {
                  _viewCertificate(userProfile!.sslcCertificate);
                },
                child: Text('View SSLC Certificate'),
              ),
            // Add similar buttons for other certificate types
          ],
        ),
      ),
    );
  }

  Future<void> _viewCertificate(String pdfPath) async {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfViewerScreen(pdfPath: pdfPath),
        ),
      );
    } catch (e) {
      print('Error viewing certificate: $e');
    }
  }
}

class PdfViewerScreen extends StatelessWidget {
  final String pdfPath;

  const PdfViewerScreen({Key? key, required this.pdfPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: PDFView(
        filePath: pdfPath,
      ),
    );
  }
}

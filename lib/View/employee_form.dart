import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:wHRMS/View/task_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeForm extends StatefulWidget {
  const EmployeForm({Key? key}) : super(key: key);

  @override
  State<EmployeForm> createState() => _EmployeScreenState();

  void init() {}
}

List<String> keysToRetrieve = [
  'nameKey',
  'emailKey',
  'phoneKey',
  'aadharKey',
  'panKey',
  'univerKey',
  'degreeKey',
  'departmentKey',
  'percentageKey',
  'yearKey',
  'resumeKey',
  'photoKey',
];

class _EmployeScreenState extends State<EmployeForm> {
  late Future<SharedPreferences> _prefs;
  int continueButtonClicked = 0;
  Map<String, String?> selectedFiles = {};
  String? selectedFileName;

  @override
  void initState() {
    super.initState();
    _prefs = SharedPreferences.getInstance();
    displayStoredData();
  }

  Future<List<String>> displayStoredData() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String> dataList = [];

    for (String key in keysToRetrieve) {
      String value = preferences.getString(key) ?? 'Not set';
      dataList.add(value);
    }

    return dataList;
  }

  Widget customTextField({
    required String labelText,
    required String key,
    required SharedPreferences preferences,
    bool isFileUpload = false,
    int? maxSizeMB,
  }) {
    String? selectedFileName = preferences.getString(key);

    return SizedBox(
      height: 55,
      width: 300,
      child: isFileUpload
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 55,
                  width: 300,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black, // Border color
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: InkWell(
                    onTap: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles();
                      if (result != null && result.files.isNotEmpty) {
                        PlatformFile file = result.files.first;
                        if (file.size <= (maxSizeMB! * 1024 * 1024)) {
                          preferences.setString(key, file.name);
                          setState(() {
                            selectedFileName = file.name;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('File size exceeds $maxSizeMB MB.'),
                            ),
                          );
                        }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            selectedFileName ?? labelText,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          : TextField(
              decoration: InputDecoration(
                labelText: labelText,
                hintText: 'Enter $labelText',
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 3.0),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue,
                    width: 3.0,
                  ),
                ),
              ),
              onChanged: (value) {
                preferences.setString(key, value);
              },
            ),
    );
  }

  int activeStepIndex = 0;

  List<Step> stepList(SharedPreferences preferences) => [
        Step(
          state: activeStepIndex <= 0 ? StepState.indexed : StepState.complete,
          isActive: activeStepIndex >= 0,
          title: const Text(
            'Personal',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          content: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // const SizedBox(height: 20),
                const Text(
                  'Personal Information',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 30),
                customTextField(
                  labelText: 'Name',
                  key: 'nameKey',
                  preferences: preferences,
                ),
                const SizedBox(height: 20),
                customTextField(
                  labelText: 'Email',
                  key: 'emailKey',
                  preferences: preferences,
                ),
                const SizedBox(height: 20),
                customTextField(
                  labelText: 'Phone Number',
                  key: 'phoneKey',
                  preferences: preferences,
                ),
                const SizedBox(height: 20),
                customTextField(
                  labelText: 'Aadhar Number',
                  key: 'aadharKey',
                  preferences: preferences,
                ),
                const SizedBox(height: 20),
                customTextField(
                  labelText: 'Pan Number',
                  key: 'panKey',
                  preferences: preferences,
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
        Step(
          state: activeStepIndex <= 1 ? StepState.indexed : StepState.complete,
          isActive: activeStepIndex >= 1,
          title: const Text(
            'Education',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          content: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // const SizedBox(height: 20),
                const Text(
                  'Educational Information',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 30),
                customTextField(
                  labelText: 'University Name',
                  key: 'univerKey',
                  preferences: preferences,
                ),
                const SizedBox(height: 20),
                customTextField(
                  labelText: 'Degree',
                  key: 'degreeKey',
                  preferences: preferences,
                ),
                const SizedBox(height: 20),
                customTextField(
                  labelText: 'Department',
                  key: 'departmentKey',
                  preferences: preferences,
                ),
                const SizedBox(height: 20),
                customTextField(
                  labelText: 'Percentage',
                  key: 'percentageKey',
                  preferences: preferences,
                ),
                const SizedBox(height: 20),
                customTextField(
                  labelText: 'Year Of Graduation',
                  key: 'yearKey',
                  preferences: preferences,
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
        Step(
          state: StepState.complete,
          isActive: activeStepIndex >= 2,
          title: const Text(
            'Document',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          content: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // const SizedBox(height: 20),
                const Text(
                  'Document Information',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 30),
                customTextField(
                  labelText: 'Resume Upload',
                  key: 'resumeKey',
                  preferences: preferences,
                  isFileUpload: true,
                  maxSizeMB: 5,
                ),
                const SizedBox(height: 20),
                customTextField(
                  labelText: 'Photo Upload',
                  key: 'photoKey',
                  preferences: preferences,
                  isFileUpload: true,
                  maxSizeMB: 2,
                ),
                const SizedBox(height: 250),
              ],
            ),
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<SharedPreferences>(
        future: _prefs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          final SharedPreferences preferences = snapshot.data!;
          return Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 28.0, vertical: 8.0),
              child: Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(primary: Colors.blue),
                ),
                child: SizedBox(
                  height: 600,
                  width: 500,
                  child: Card(
                    child: Stepper(
                      type: StepperType.horizontal,
                      currentStep: activeStepIndex,
                      steps: stepList(preferences),
                      onStepTapped: (step) {
                        setState(() {
                          activeStepIndex = step;
                        });
                      },
                      controlsBuilder:
                          (BuildContext context, ControlsDetails details) {
                        return Row(
                          children: <Widget>[
                            const SizedBox(width: 5.0),
                            Container(
                              height: 40,
                              width: 100,
                              color: Colors.red,
                              child: TextButton(
                                onPressed: details.onStepCancel,
                                child: const Text(
                                  'PREVIOUS',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(width: 50.0),
                            Container(
                              color: Colors.blue,
                              height: 40,
                              width: 100,
                              child: TextButton(
                                onPressed: activeStepIndex ==
                                        stepList(preferences).length - 1
                                    ? () {
                                        details.onStepContinue!();
                                      }
                                    : details.onStepContinue,
                                child: Text(
                                  activeStepIndex ==
                                          stepList(preferences).length - 1
                                      ? 'SUBMIT'
                                      : 'CONTINUE',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      onStepContinue: () {
                        setState(() {
                          if (activeStepIndex <
                              stepList(preferences).length - 1) {
                            activeStepIndex += 1;
                          } else if (activeStepIndex ==
                              stepList(preferences).length - 1) {
                            if (continueButtonClicked == 0) {
                              continueButtonClicked++;
                              displayStoredData().then((dataList) {
                                for (int i = 0;
                                    i < keysToRetrieve.length;
                                    i++) {
                                  preferences.setString(
                                      keysToRetrieve[i], dataList[i]);
                                }
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        // DisplayDataScreen(dataList: dataList),
                                        const CalendarScreen(),
                                  ),
                                ).then((_) {
                                  setState(() {
                                    selectedFileName = null;
                                    continueButtonClicked = 0;
                                  });
                                });
                              });
                            }
                          }
                        });
                      },
                      onStepCancel: () {
                        if (activeStepIndex > 0) {
                          setState(() {
                            activeStepIndex -= 1;
                          });
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

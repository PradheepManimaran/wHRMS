// import 'package:flutter/material.dart';

// class DarkLightModeScreen extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();

//   static void setTheme(BuildContext context, ThemeData themeData) {
//     final _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
//     state?.setTheme(themeData);
//   }
// }

// class _MyAppState extends State<DarkLightModeScreen> {
//   bool isDarkModeEnabled = true;

//   void setTheme(ThemeData themeData) {
//     setState(() {
//       isDarkModeEnabled = themeData.brightness == Brightness.dark;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Theme Demo',
//       theme: isDarkModeEnabled ? darkTheme : lightTheme,
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Theme Demo'),
//         ),
//         body: Center(
//           child: Text(
//             'Switch themes using the toggle switch',
//             style: Theme.of(context).textTheme.headline6,
//           ),
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => ThemeSwitcher()),
//             );
//           },
//           child: Icon(Icons.settings),
//         ),
//       ),
//     );
//   }
// }

// // Light Mode Theme
// final lightTheme = ThemeData(
//   brightness: Brightness.light,
//   primaryColor: Colors.blue,
//   // Add more light mode specific configurations here
// );

// // Dark Mode Theme
// final darkTheme = ThemeData(
//   brightness: Brightness.dark,
//   primaryColor: Colors.indigo,
//   // Add more dark mode specific configurations here
// );

// // Theme Switcher Widget
// class ThemeSwitcher extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Theme Settings'),
//       ),
//       body: Center(
//         child: Switch(
//           value: Theme.of(context).brightness == Brightness.dark,
//           onChanged: (value) {
//             if (value) {
//               DarkLightModeScreen.setTheme(context, darkTheme);
//             } else {
//               DarkLightModeScreen.setTheme(context, lightTheme);
//             }
//           },
//         ),
//       ),
//     );
//   }
// }

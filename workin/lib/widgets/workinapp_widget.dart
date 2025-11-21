import 'package:flutter/material.dart';

import '../data/notifiers.dart';
import '../screens/home_screen.dart';

class WorkinApp extends StatelessWidget {
  const WorkinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkModeNotifier,
      builder: (ontext, isDarkMode, child) {
        return MaterialApp(
          title: 'Lifting Tracker',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.teal,
              brightness: isDarkMode ? Brightness.dark : Brightness.light,
            ),
          ),
          home: const HomeScreen(),
        );
      },
    );
  }
}

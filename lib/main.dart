import 'package:flutter/material.dart';
import 'theme/deodar_theme.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const DeodarPdfApp());
}

class DeodarPdfApp extends StatelessWidget {
  const DeodarPdfApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deodar PDF viewer',
      debugShowCheckedModeBanner: false,
      theme: deodarTheme(),
      home: const HomeScreen(),
    );
  }
}

import 'package:flutter/material.dart';
import 'core/theme/ocalm_theme.dart';
import 'features/auth/screens/splash_screen.dart';

void main() {
  runApp(const OcalmApp());
}

class OcalmApp extends StatelessWidget {
  const OcalmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OCALM',
      debugShowCheckedModeBanner: false,
      theme: OcalmTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}

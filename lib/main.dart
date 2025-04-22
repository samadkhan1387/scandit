import 'package:flutter/material.dart';
import 'Splash.dart';  // Import Splash screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Atk Scanner',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(
        isVibrateEnabled: false,  // Default value for vibration
        isBeepEnabled: false,     // Default value for beep
      ),
    );
  }
}

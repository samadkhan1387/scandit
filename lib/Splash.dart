import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../Home.dart'; // Ensure HomePage is in the correct path

class SplashScreen extends StatefulWidget {
  final bool isVibrateEnabled;
  final bool isBeepEnabled;

  const SplashScreen({super.key, required this.isVibrateEnabled, required this.isBeepEnabled});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delay for 3 seconds then navigate
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            isVibrateEnabled: widget.isVibrateEnabled,
            isBeepEnabled: widget.isBeepEnabled,
          ), // Pass the parameters to HomePage
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/scandit.gif', // Your gif asset
              fit: BoxFit.cover, // Ensure the gif covers the whole screen
              width: double.infinity, // Makes the gif take up the full width
              height: double.infinity, // Makes the gif take up the full height
            ),
          ),
        ],
      ),
    );
  }
}

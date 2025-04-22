import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';  // Import shared_preferences

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isVibrateEnabled = false; // Store vibration toggle state
  bool isBeepEnabled = false; // Store beep toggle state

  // Load saved preferences on page load
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // Load saved settings from SharedPreferences
  _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isVibrateEnabled = prefs.getBool('isVibrateEnabled') ?? false; // Default to false if no value is saved
      isBeepEnabled = prefs.getBool('isBeepEnabled') ?? false;  // Default to false if no value is saved
    });
  }

  // Save settings to SharedPreferences
  _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isVibrateEnabled', isVibrateEnabled);
    prefs.setBool('isBeepEnabled', isBeepEnabled);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF3A3A3A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 25),
          ),
        ),
        title: const Text(
          "Settings",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Settings",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF5cc079)),
            ),
            const SizedBox(height: 10),
            // Vibrate Toggle
            ModernSwitchCard(
              icon: Icons.vibration,
              title: "Vibrate",
              description: "Vibration when scan is done.",
              switchValue: isVibrateEnabled,
              onChanged: (value) {
                setState(() {
                  isVibrateEnabled = value;
                });
                _saveSettings(); // Save the setting whenever it's changed
              },
            ),
            const SizedBox(height: 10),
            // Beep Toggle
            ModernSwitchCard(
              icon: Icons.notifications_active,
              title: "Beep",
              description: "Beep when scan is done.",
              switchValue: isBeepEnabled,
              onChanged: (value) {
                setState(() {
                  isBeepEnabled = value;
                });
                _saveSettings(); // Save the setting whenever it's changed
              },
            ),
            const SizedBox(height: 20),
            // Support Section
            const Text(
              "Support",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5cc079),
              ),
            ),
            const SizedBox(height: 10),
            // Rate Us
            ModernSupportCard(
              icon: Icons.star,
              title: "Rate Us",
              description: "Your best reward to us.",
              onTap: () {
                // Handle Rate Us action
              },
            ),
            const SizedBox(height: 10),
            // Share
            ModernSupportCard(
              icon: Icons.share,
              title: "Share",
              description: "Share the app with others.",
              onTap: () {
                // Handle Share action
              },
            ),
            const SizedBox(height: 10),
            // Privacy Policy
            ModernSupportCard(
              icon: Icons.privacy_tip,
              title: "Privacy Policy",
              description: "Follow our policies that benefit you.",
              onTap: () {
                // Handle Privacy Policy action
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Modern Switch Card
class ModernSwitchCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool switchValue;
  final ValueChanged<bool> onChanged;

  const ModernSwitchCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
    required this.switchValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF3A3A3A),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF5cc079),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white, size: 25),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          Switch(
            value: switchValue,
            onChanged: onChanged,
            activeColor: const Color(0xFF5cc079),
            inactiveTrackColor: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }
}

// Modern Support Card
class ModernSupportCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const ModernSupportCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF3A3A3A),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF5cc079),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white, size: 25),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

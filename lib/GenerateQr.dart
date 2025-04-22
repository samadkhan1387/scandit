import 'package:flutter/material.dart';

import 'TextQr.dart';

class GenerateQRPage extends StatelessWidget {
  const GenerateQRPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E), // Dark background
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF333333),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 25),
          ),
        ),
        title: const Text(
          "Generate Qr",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3 items per row
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
          ),
          itemCount: qrItems.length,
          itemBuilder: (context, index) {
            final item = qrItems[index];
            return GestureDetector(
              onTap: () {
                // Handle navigation based on the item's label
                if (item.label == 'Text') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TextQRScreen(),
                    ),
                  );
                } else if (item.label == 'Website') {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const WebsiteQRScreen(),
                  //   ),
                  // );
                } else if (item.label == 'Wi-Fi') {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const WifiQRScreen(),
                  //   ),
                  // );
                }
                // Add more cases for other QR types
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Icon Container
                  Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      color: const Color(0xFF333333),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFF5cc079),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        item.icon,
                        size: 35,
                        color: const Color(0xFF5cc079),
                      ),
                    ),
                  ),
                  // Label Positioned
                  Positioned(
                    top: -10,
                    left: 5,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5cc079),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        item.label,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// Define the QR Items
class QRItem {
  final IconData icon;
  final String label;

  QRItem({required this.icon, required this.label});
}

// List of QR Items
final List<QRItem> qrItems = [
  QRItem(icon: Icons.text_fields, label: 'Text'),
  QRItem(icon: Icons.language, label: 'Website'),
  QRItem(icon: Icons.wifi, label: 'Wi-Fi'),
  QRItem(icon: Icons.event, label: 'Event'),
  QRItem(icon: Icons.contacts, label: 'Contact'),
  QRItem(icon: Icons.business, label: 'Business'),
  QRItem(icon: Icons.location_on, label: 'Location'),

  QRItem(icon: Icons.email, label: 'Email'),
  QRItem(icon: Icons.camera, label: 'Instagram'),
  QRItem(icon: Icons.phone, label: 'Telephone'),
];

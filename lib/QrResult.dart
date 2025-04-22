import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QRResultScreen extends StatelessWidget {
  final String data;

  const QRResultScreen({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2B2B2B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2B2B),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF3A3A3A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        title: const Text(
          "QR Code",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF3A3A3A),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                data.isNotEmpty ? data : "No data provided",
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            // QR Code
            PrettyQr(
              data: data.isNotEmpty ? data : "No data provided", // Validate data
              size: 200.0, // Size of the QR code
              roundEdges: true, // Optional: rounded edges for a modern look
              elementColor: Colors.white,

            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Share functionality
                  },
                  icon: const Icon(Icons.share, color: Colors.black),
                  label: const Text(
                    "Share",
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB200),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Save functionality
                  },
                  icon: const Icon(Icons.save, color: Colors.black),
                  label: const Text(
                    "Save",
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB200),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

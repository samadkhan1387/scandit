import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:vibration/vibration.dart';
import 'GenerateQr.dart';
import 'History.dart';
import 'Setting.dart';
import 'constants.dart';
import 'ParsedBarCodePage.dart';
import 'database_helper.dart';
import 'gs1_barcode_parser/barcode_parser.dart';

class HomePage extends StatefulWidget {
  final bool isVibrateEnabled;
  final bool isBeepEnabled;

  const HomePage(
      {super.key, required this.isVibrateEnabled, required this.isBeepEnabled});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late MobileScannerController cameraController;
  bool isScanning = false; // Flag to prevent multiple scans
  bool isTorchEnabled = false; // Flag for torch state
  final AudioPlayer _audioPlayer = AudioPlayer(); // Audio player for beep sound

  @override
  void initState() {
    super.initState();
    cameraController = MobileScannerController(
      torchEnabled: isTorchEnabled, // Initial torch state
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    cameraController =
        MobileScannerController(); // Ensures the camera is reset each time the page re-appears
  }

  // Method to play custom beep sound
  Future<void> _playBeepSound() async {
    await _audioPlayer
        .play(AssetSource('assets/beep.mp3')); // Play beep sound from assets
  }

  // Custom vibration pattern
  Future<void> _customVibration() async {
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(
        pattern: [
          500,
          200,
          500,
          200
        ], // Pattern: [duration, pause, duration, pause]
        intensities: [128, 255], // Vibration intensities (optional)
      );
    }
  }

  // Improved _onBarcodeScanned function with beep and vibration
  Future<void> _onBarcodeScanned(String barcode) async {
    if (isScanning) return;

    setState(() {
      isScanning = true;
    });

    final parser = GS1BarcodeParser.defaultParser();
    try {
      final parsedData = parser.parse(barcode);
      print("Parsed Data: $parsedData");

      Map<String, String> barcodeData = {};
      parsedData.elements.forEach((key, element) {
        barcodeData[key] = element.data.toString();
        barcodeData['rawBarcode'] = barcode;
      });

      String sanitizedBarcode = barcode.replaceAll(RegExp(r'[^\x00-\x7F]'), '');

      print("Sanitized Raw Barcode: $sanitizedBarcode");

      String parsedDataString = jsonEncode(barcodeData);

      Map<String, dynamic> row = {
        'rawBarcode': sanitizedBarcode,
        'parsedData': parsedDataString,
      };

      DatabaseHelper.instance.insert(row);

      // Check if Vibration is enabled and trigger it
      if (widget.isVibrateEnabled) {
        if (await Vibration.hasVibrator()) {
          Vibration.vibrate(); // Vibrate the phone
        } else {
          print("Device does not support vibration.");
        }
      }
      // Check if Beep is enabled and play beep sound
      if (widget.isBeepEnabled) {
        _audioPlayer.play('assets/beep.mp3' as Source); // Beep sound
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ParsedBarcodeScreen(
            parsedData: barcodeData,
            rawBarcode: sanitizedBarcode,
          ),
        ),
      );
    } catch (e) {
      _showscanDialog('Parsing Error', 'Failed to Parse Barcode');
      print("Error parsing barcode: $e");
    } finally {
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          isScanning = false;
        });
      });
    }
  }

  void _showscanDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF5cc079),
          title: Center(
            child: Text(
              title,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: RedColor),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/cross.png', height: 50, color: RedColor),
              const SizedBox(height: 20),
              Container(
                alignment: Alignment.center,
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: RedColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fixedSize: const Size(120, 45),
                ),
                child: const Text('Ok'),
              ),
            ),
          ],
        );
      },
    );
  }

  // Toggle Torch state
  void _toggleTorch(bool isOn) {
    setState(() {
      isTorchEnabled = isOn;
      cameraController.toggleTorch(); // Toggle the torch state
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/logo.png', // Replace with your logo path
              height: 25, // Adjust height as needed
            ),
            IconButton(
              icon: const Icon(
                Icons.menu_rounded,
                color: Color(0xFFca4a3c),
                size: 30,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // QR scanner area
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 0),
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 420,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: MobileScanner(
                          controller: cameraController,
                          onDetect: (barcodeCapture) {
                            final barcode = barcodeCapture.barcodes.first;
                            final String? code = barcode.rawValue;
                            if (code != null) {
                              _onBarcodeScanned(code);
                            }
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: GreenColor,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Torch toggle
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF3A3A3A),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Enable Torch',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Switch(
                      value: isTorchEnabled,
                      onChanged: _toggleTorch,
                      activeColor: GreenColor,
                      inactiveThumbColor: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // Bottom Navigation Bar
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: const BoxDecoration(
                color: Color(0xFF3A3A3A),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => const GenerateQRPage()),
                      // );
                    },
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.qr_code, color: Colors.white, size: 24),
                        SizedBox(height: 5),
                        Text(
                          'Generate',
                          style: TextStyle(fontSize: 13, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 50),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HistoryPage()),
                      );
                    },
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.history, color: Colors.white, size: 24),
                        SizedBox(height: 5),
                        Text(
                          'History',
                          style: TextStyle(fontSize: 13, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: -0,
              child: GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => ScanPage()),
                  // );
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF5cc079),
                  ),
                  child: Image.asset(
                    'assets/centericon.png',
                    width: 35,
                    height: 35,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

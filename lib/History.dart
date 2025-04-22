import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting
import 'ParsedBarCodePage.dart';
import 'database_helper.dart'; // Ensure the correct path for this import

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<Map<String, dynamic>>> parsedDataList; // Add a Future variable to fetch data

  @override
  void initState() {
    super.initState();
    parsedDataList = DatabaseHelper.instance.queryAll(); // Initialize the parsed data
  }

  // Method to refresh the list after deleting a record
  Future<void> _deleteRecord(int id) async {
    await DatabaseHelper.instance.delete(id); // Delete the record from the database
    setState(() {
      parsedDataList = DatabaseHelper.instance.queryAll(); // Refresh the list by querying the database again
    });
    _showCustomSnackbar(context, "Barcode Record Deleted", Colors.red, Icons.delete);
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
              color: const Color(0xFF333333),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 25),
          ),
        ),
        title: const Text(
          "History",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: parsedDataList, // Use the Future variable to fetch data
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF5cc079),));
          }

          final dataList = snapshot.data!;

          return ListView.builder(
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              var data = dataList[index];

              // Convert the 'parsedData' string back to a Map<String, String>
              Map<String, String> parsedData = {};
              try {
                if (data['parsedData'] != null && data['parsedData'] is String) {
                  parsedData = Map<String, String>.from(jsonDecode(data['parsedData']));
                  print('Parsed Data decoded: $parsedData');
                }
              } catch (e) {
                print('Error parsing parsedData: $e');
              }

              // Format the date and time properly
              String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());

              return Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 15),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ParsedBarcodeScreen(
                          parsedData: parsedData,  // Pass parsed data
                          rawBarcode: data['rawBarcode'],  // Pass raw barcode
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3A3A3A), Color(0xFF2E2E2E)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
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
                          child: Image.asset(
                            'assets/centericon.png', // Replace with your actual asset
                            width: 30,
                            height: 30,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['rawBarcode'],  // Show raw barcode
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Date: $formattedDate', // Display formatted date and time
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            // Delete the barcode record from the database and refresh the list
                            int id = data['_id']; // Get the ID of the record
                            await _deleteRecord(id); // Call the method to delete the record and refresh the list
                          },
                          child: const Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                            size: 25,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showCustomSnackbar(BuildContext context, String message, Color backgroundColor, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

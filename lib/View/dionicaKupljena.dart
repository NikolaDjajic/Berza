// dionica_detail_page.dart
import 'package:crypto/View/Baza/Dionica.dart';
import 'package:flutter/material.dart';

class DionicaDetailPage extends StatelessWidget {
  final Dionica dionica; // Replace 'Dionica' with your actual data class

  DionicaDetailPage({required this.dionica});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dionica Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Name: ${dionica.ime}'), // Display Dionica details as needed
            Text('Symbol: ${dionica.simbol}'),
            // Add more details here
          ],
        ),
      ),
    );
  }
}

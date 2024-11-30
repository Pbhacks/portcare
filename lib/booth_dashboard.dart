import 'package:flutter/material.dart';

class BoothDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Booth Staff Dashboard')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Scheduled Consultations', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Placeholder for assisting consultations
              },
              child: Text('Assist Consultation'),
            ),
          ],
        ),
      ),
    );
  }
}

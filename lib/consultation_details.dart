import 'package:flutter/material.dart';

class ConsultationDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Consultation Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Patient Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Name: John Doe\nAge: 45\nCondition: Hypertension'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Video Call Placeholder
              },
              child: Text('Start Video Call'),
            ),
          ],
        ),
      ),
    );
  }
}

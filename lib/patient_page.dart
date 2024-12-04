import 'package:flutter/material.dart';
import 'consult_page.dart'; // Import the consult page here

class PatientPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Portal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, Patient!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Navigate to the ConsultPage when the button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ConsultPage()),
                );
              },
              child: Text('Consult a Doctor'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to prescription check page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PrescriptionPage()),
                );
              },
              child: Text('Check Prescription'),
            ),
          ],
        ),
      ),
    );
  }
}

class PrescriptionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prescription History'),
      ),
      body: Center(
        child: Text('Prescription details go here'),
      ),
    );
  }
}

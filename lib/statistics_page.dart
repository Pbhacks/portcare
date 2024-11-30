import 'package:flutter/material.dart';

class StatisticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Statistics')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Consultations',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Container(
              height: 200,
              color: Colors.grey[300],
              alignment: Alignment.center,
              child: Text(
                'Chart Placeholder',
                style: TextStyle(color: Colors.grey[700], fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Other Statistics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Total Patients: 120'),
            Text('Revenue: \$15,000'),
            Text('Average Consultation Time: 15 mins'),
          ],
        ),
      ),
    );
  }
}

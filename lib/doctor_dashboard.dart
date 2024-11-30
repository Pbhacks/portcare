import 'package:flutter/material.dart';

import 'appointments_page.dart';
import 'patient_records_page.dart';
import 'availability_page.dart';
import 'statistics_page.dart';

class DoctorDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Doctor Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, Doctor!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _buildDashboardTile(
                    context,
                    'Appointments',
                    Icons.calendar_today,
                    Colors.teal,
                    AppointmentsPage(),
                  ),
                  _buildDashboardTile(
                    context,
                    'Patient Records',
                    Icons.folder_open,
                    Colors.blue,
                    PatientRecordsPage(),
                  ),
                  _buildDashboardTile(
                    context,
                    'Availability',
                    Icons.schedule,
                    Colors.purple,
                    AvailabilityPage(),
                  ),
                  _buildDashboardTile(
                    context,
                    'Statistics',
                    Icons.bar_chart,
                    Colors.orange,
                    StatisticsPage(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardTile(BuildContext context, String title, IconData icon,
      Color color, Widget page) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => page)),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            SizedBox(height: 8),
            Text(title,
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class AppointmentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Appointments')),
      body: Center(child: Text('List of appointments will be displayed here.')),
    );
  }
}

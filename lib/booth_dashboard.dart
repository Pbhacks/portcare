import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'consult_page.dart'; // Import the consult page to navigate back to consultation.

class BoothDashboard extends StatefulWidget {
  @override
  _BoothDashboardState createState() => _BoothDashboardState();
}

class _BoothDashboardState extends State<BoothDashboard> {
  List<Map<String, dynamic>> _patients = [];

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  // Load patient data from SharedPreferences
  Future<void> _loadPatients() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedData = prefs.getString('patients');
    if (savedData != null) {
      setState(() {
        _patients = List<Map<String, dynamic>>.from(jsonDecode(savedData));
      });
    }
  }

  // Save updated patient list to SharedPreferences
  Future<void> _savePatients() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('patients', jsonEncode(_patients));
  }

  // Mark the patient as under consultation
  void _assistConsultation(int index) {
    setState(() {
      _patients[index]['status'] = 'Under Consultation';
    });
    _savePatients();
  }

  // Mark the consultation as completed
  void _completeConsultation(int index) {
    setState(() {
      _patients[index]['status'] = 'Completed';
    });
    _savePatients();
  }

  // View patient details
  void _viewPatientDetails(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientDetailsPage(patient: _patients[index]),
      ),
    );
  }

  // Function to handle patient status toggle (active/passive)
  void _toggleStatus(int index) {
    setState(() {
      _patients[index]['status'] =
          _patients[index]['status'] == 'Active' ? 'Passive' : 'Active';
    });
    _savePatients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Booth Staff Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Scheduled Consultations',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _patients.isEmpty
                  ? Center(
                      child: Text('No patients available for consultation.'))
                  : ListView.builder(
                      itemCount: _patients.length,
                      itemBuilder: (context, index) {
                        final patient = _patients[index];
                        return Card(
                          child: ListTile(
                            title: Text(
                                '${patient['name']} (Age: ${patient['age']})'),
                            subtitle:
                                Text('Condition: ${patient['condition']}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(patient['status'],
                                    style: TextStyle(
                                        color: patient['status'] == 'Active'
                                            ? Colors.green
                                            : patient['status'] ==
                                                    'Under Consultation'
                                                ? Colors.blue
                                                : Colors.red)),
                                IconButton(
                                  icon: Icon(Icons.medical_services,
                                      color: Colors.blue),
                                  onPressed: () => _assistConsultation(index),
                                ),
                                IconButton(
                                  icon: Icon(Icons.check_circle,
                                      color: Colors.green),
                                  onPressed: () => _completeConsultation(index),
                                ),
                                IconButton(
                                  icon: Icon(Icons.toggle_off,
                                      color: Colors.orange),
                                  onPressed: () => _toggleStatus(index),
                                ),
                                IconButton(
                                  icon: Icon(Icons.info_outline,
                                      color: Colors.blue),
                                  onPressed: () => _viewPatientDetails(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ConsultPage()),
                );
              },
              child: Text('Add Patient'),
            ),
          ],
        ),
      ),
    );
  }
}

class PatientDetailsPage extends StatelessWidget {
  final Map<String, dynamic> patient;

  const PatientDetailsPage({Key? key, required this.patient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Patient Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Patient Name: ${patient['name']}',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text('Age: ${patient['age']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            Text('Condition: ${patient['condition']}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            Text('Status: ${patient['status']}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            Text('Symptoms: ${patient['symptoms']}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Go back to the dashboard
              },
              child: Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}

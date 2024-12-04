import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PatientRecordsPage extends StatefulWidget {
  @override
  _PatientRecordsPageState createState() => _PatientRecordsPageState();
}

class _PatientRecordsPageState extends State<PatientRecordsPage> {
  List<Map<String, dynamic>> _patients = [];

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  Future<void> _loadPatients() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedData = prefs.getString('patients');
    if (savedData != null) {
      setState(() {
        _patients = List<Map<String, dynamic>>.from(jsonDecode(savedData));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Patient Records')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _patients.isEmpty
            ? Center(child: Text('No patient records available.'))
            : ListView.builder(
                itemCount: _patients.length,
                itemBuilder: (context, index) {
                  final patient = _patients[index];
                  return Card(
                    child: ListTile(
                      title:
                          Text('${patient['name']} (Age: ${patient['age']})'),
                      subtitle: Text('Condition: ${patient['condition']}'),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Result: ${patient['result']}'),
                          Text('Comments: ${patient['comments']}'),
                          Text('Prescription: ${patient['prescription']}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

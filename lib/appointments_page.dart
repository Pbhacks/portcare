import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AppointmentsPage extends StatefulWidget {
  @override
  _AppointmentsPageState createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _conditionController = TextEditingController();
  final TextEditingController _resultController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _prescriptionController = TextEditingController();

  List<Map<String, dynamic>> _patients = [];
  String _result = 'Good'; // Default result to avoid null value.

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

  Future<void> _savePatients() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('patients', jsonEncode(_patients));
  }

  // Save completed consultation data to the patient's record
  void _saveConsultationResult(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _patients[index]['result'] = _result;
      _patients[index]['comments'] = _commentController.text;
      _patients[index]['prescription'] = _prescriptionController.text;
    });
    _savePatients();
    Navigator.pop(context); // Close the current page after saving
  }

  void _addPatient() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _patients.add({
          'name': _nameController.text,
          'age': int.parse(_ageController.text),
          'condition': _conditionController.text,
          'status': 'Active',
          'result': '', // Empty result initially
          'comments': '',
          'prescription': ''
        });
        _nameController.clear();
        _ageController.clear();
        _conditionController.clear();
      });
      _savePatients();
    }
  }

  void _toggleStatus(int index) {
    setState(() {
      _patients[index]['status'] =
          _patients[index]['status'] == 'Active' ? 'Passive' : 'Active';
    });
    _savePatients();
  }

  void _deletePatient(int index) {
    setState(() {
      _patients.removeAt(index);
    });
    _savePatients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Manage Appointments')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add Patient',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Patient Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _ageController,
                    decoration: InputDecoration(labelText: 'Age'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an age';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _conditionController,
                    decoration: InputDecoration(labelText: 'Condition'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a condition';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _addPatient,
                    child: Text('Add Patient'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text('Patient List',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Expanded(
              child: _patients.isEmpty
                  ? Center(child: Text('No patients added yet.'))
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
                                            : Colors.red)),
                                IconButton(
                                  icon: Icon(Icons.toggle_off,
                                      color: patient['status'] == 'Active'
                                          ? Colors.green
                                          : Colors.red),
                                  onPressed: () => _toggleStatus(index),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deletePatient(index),
                                ),
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    // Open a dialog to add results, comments, and prescription
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        // Ensure that the controllers have values
                                        _resultController.text =
                                            patient['result'] ?? 'Good';
                                        _commentController.text =
                                            patient['comments'] ?? '';
                                        _prescriptionController.text =
                                            patient['prescription'] ?? '';
                                        return AlertDialog(
                                          title: Text('Consultation Results'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              DropdownButton<String>(
                                                value: _resultController
                                                        .text.isEmpty
                                                    ? 'Good'
                                                    : _resultController.text,
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    _resultController.text =
                                                        newValue!;
                                                  });
                                                },
                                                items: <String>[
                                                  'Good',
                                                  'Bad'
                                                ].map<DropdownMenuItem<String>>(
                                                    (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                }).toList(),
                                              ),
                                              TextFormField(
                                                controller: _commentController,
                                                decoration: InputDecoration(
                                                    labelText: 'Comments'),
                                              ),
                                              TextFormField(
                                                controller:
                                                    _prescriptionController,
                                                decoration: InputDecoration(
                                                    labelText: 'Prescription'),
                                              ),
                                            ],
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                _saveConsultationResult(index);
                                              },
                                              child: Text('Save'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

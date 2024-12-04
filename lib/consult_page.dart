import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ConsultPage extends StatefulWidget {
  @override
  _ConsultPageState createState() => _ConsultPageState();
}

class _ConsultPageState extends State<ConsultPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _conditionController = TextEditingController();
  final TextEditingController _symptomsController = TextEditingController();
  String _status = 'Active';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Consultation')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Fill in your details for consultation',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
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
                  return null;
                },
              ),
              TextFormField(
                controller: _conditionController,
                decoration: InputDecoration(labelText: 'Condition'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the condition';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _symptomsController,
                decoration: InputDecoration(labelText: 'Symptoms'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter symptoms';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _submitConsultation();
                  }
                },
                child: Text('Submit Details'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Submit the patient details to shared preferences
  Future<void> _submitConsultation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Create a new patient record
    Map<String, dynamic> newPatient = {
      'name': _nameController.text,
      'age': _ageController.text,
      'condition': _conditionController.text,
      'symptoms': _symptomsController.text,
      'status': _status,
    };

    // Get the existing list of patients from SharedPreferences
    String? savedData = prefs.getString('patients');
    List<Map<String, dynamic>> patients = [];
    if (savedData != null) {
      patients = List<Map<String, dynamic>>.from(jsonDecode(savedData));
    }

    // Add the new patient to the list
    patients.add(newPatient);

    // Save the updated patient list to SharedPreferences
    await prefs.setString('patients', jsonEncode(patients));

    // Navigate back to the dashboard
    Navigator.pop(context);
  }
}

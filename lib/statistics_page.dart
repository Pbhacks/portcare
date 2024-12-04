import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StatisticsPage extends StatefulWidget {
  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  List<Map<String, dynamic>> _patients = [];
  int activePatientsCount = 0;
  int passivePatientsCount = 0;

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  // Load patients from SharedPreferences
  Future<void> _loadPatients() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedData = prefs.getString('patients');
    if (savedData != null) {
      setState(() {
        _patients = List<Map<String, dynamic>>.from(jsonDecode(savedData));
        activePatientsCount =
            _patients.where((patient) => patient['status'] == 'Active').length;
        passivePatientsCount =
            _patients.where((patient) => patient['status'] == 'Passive').length;
      });
    }
  }

  // Create the bar chart data for active and passive patients
  BarChartGroupData _buildBarChartData(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 25,
          borderRadius: BorderRadius.zero,
        ),
      ],
    );
  }

  // Generate the bar chart data
  List<BarChartGroupData> _buildBarChart() {
    return [
      _buildBarChartData(
          0, activePatientsCount.toDouble(), Colors.teal), // Active
      _buildBarChartData(
          1, passivePatientsCount.toDouble(), Colors.red), // Passive
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Patient Cases Statistics')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Patient Cases Statistics',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            // Display Active and Passive Patients Count
            Text(
              'Active Patients: $activePatientsCount',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Passive Patients: $passivePatientsCount',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            // Bar Chart for Active and Passive Patients
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  borderData: FlBorderData(show: false),
                  barGroups: _buildBarChart(),
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

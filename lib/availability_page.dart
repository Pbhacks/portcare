import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class AvailabilityPage extends StatefulWidget {
  const AvailabilityPage({Key? key}) : super(key: key);

  @override
  _AvailabilityPageState createState() => _AvailabilityPageState();
}

class _AvailabilityPageState extends State<AvailabilityPage> {
  List<Map<String, dynamic>> _availableSlots = [];
  late DateTime _selectedDate;
  final _timeController = TextEditingController();
  final _durationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _loadAvailableSlots();
  }

  @override
  void dispose() {
    _timeController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  // Load available slots from SharedPreferences
  Future<void> _loadAvailableSlots() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedData = prefs.getString('available_slots');

      if (savedData != null) {
        final List<dynamic> decodedData = jsonDecode(savedData);
        setState(() {
          _availableSlots = decodedData
              .map((item) => Map<String, dynamic>.from(item))
              .toList()
              .where((slot) {
            final slotDate = DateTime.parse(slot['date']);
            return _isSameDay(slotDate, _selectedDate);
          }).toList();
        });
      }
    } catch (e) {
      _showErrorDialog('Error loading slots: $e');
    }
  }

  // Save available slots to SharedPreferences
  Future<void> _saveAvailableSlots() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('available_slots', jsonEncode(_availableSlots));
    } catch (e) {
      _showErrorDialog('Error saving slots: $e');
    }
  }

  // Check if two dates are on the same day
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // Validate time format
  bool _isValidTimeFormat(String time) {
    final timeRegex = RegExp(r'^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$');
    return timeRegex.hasMatch(time);
  }

  // Add a time slot to the list of available slots
  void _addTimeSlot() {
    if (!_formKey.currentState!.validate()) return;

    final time = _timeController.text.trim();
    final durationText = _durationController.text.trim();

    if (!_isValidTimeFormat(time)) {
      _showErrorDialog('Invalid time format. Use HH:mm');
      return;
    }

    try {
      final duration = int.parse(durationText);

      if (duration <= 0) {
        _showErrorDialog('Duration must be a positive number');
        return;
      }

      setState(() {
        _availableSlots.add({
          'date': _selectedDate.toIso8601String(),
          'time': time,
          'duration': duration.toString(),
          'status': 'Available',
        });
        _timeController.clear();
        _durationController.clear();
      });
      _saveAvailableSlots();
    } catch (e) {
      _showErrorDialog('Invalid duration: $e');
    }
  }

  // Show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  // Toggle between Available and Unavailable status for a time slot
  void _toggleSlotStatus(int index) {
    setState(() {
      _availableSlots[index]['status'] =
          _availableSlots[index]['status'] == 'Available'
              ? 'Unavailable'
              : 'Available';
    });
    _saveAvailableSlots();
  }

  // Remove a time slot from the list
  void _removeSlot(int index) {
    setState(() {
      _availableSlots.removeAt(index);
    });
    _saveAvailableSlots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Doctor Availability')),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context)
              .unfocus(), // Dismiss keyboard on tap outside
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Date Selection Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Selected Date: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null && pickedDate != _selectedDate) {
                          setState(() {
                            _selectedDate = pickedDate;
                            _loadAvailableSlots();
                          });
                        }
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Input Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _timeController,
                        decoration: const InputDecoration(
                          labelText: 'Time (HH:mm)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.datetime,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a time';
                          }
                          if (!_isValidTimeFormat(value)) {
                            return 'Invalid time format (HH:mm)';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _durationController,
                        decoration: const InputDecoration(
                          labelText: 'Duration (in minutes)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a duration';
                          }
                          final duration = int.tryParse(value);
                          if (duration == null || duration <= 0) {
                            return 'Duration must be a positive number';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _addTimeSlot,
                  child: const Text('Add Time Slot'),
                ),

                const SizedBox(height: 20),

                // Available Slots List
                Expanded(
                  child: _availableSlots.isEmpty
                      ? const Center(
                          child: Text(
                            'No time slots added for this date.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: _availableSlots.length,
                          itemBuilder: (context, index) {
                            final slot = _availableSlots[index];
                            final isAvailable = slot['status'] == 'Available';

                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                title: Text(
                                  'Time: ${slot['time']} - Duration: ${slot['duration']} mins',
                                  style: TextStyle(
                                    color: isAvailable
                                        ? Colors.black
                                        : Colors.grey,
                                  ),
                                ),
                                subtitle: Text(
                                  'Date: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      slot['status'],
                                      style: TextStyle(
                                        color: isAvailable
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        isAvailable ? Icons.close : Icons.check,
                                        color: isAvailable
                                            ? Colors.red
                                            : Colors.green,
                                      ),
                                      onPressed: () => _toggleSlotStatus(index),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () => _removeSlot(index),
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
        ),
      ),
    );
  }
}

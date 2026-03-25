import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:bluetooth_sco/bluetooth_sco.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isScoActive = false;
  String _statusMessage = '';
  final _bluetoothScoPlugin = BluetoothSco();

  Future<void> _checkScoAvailability() async {
    try {
      final available = await _bluetoothScoPlugin.isBluetoothScoAvailable();
      setState(() {
        _statusMessage = available
            ? 'Bluetooth SCO is available'
            : 'Bluetooth SCO is not available';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error checking SCO: $e';
      });
    }
  }

  Future<void> _startSco() async {
    try {
      final started = await _bluetoothScoPlugin.startBluetoothSco();
      setState(() {
        _isScoActive = started;
        _statusMessage = started
            ? 'Bluetooth SCO started successfully'
            : 'Failed to start Bluetooth SCO';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error starting SCO: $e';
      });
    }
  }

  Future<void> _stopSco() async {
    try {
      await _bluetoothScoPlugin.stopBluetoothSco();
      setState(() {
        _isScoActive = false;
        _statusMessage = 'Bluetooth SCO stopped';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error stopping SCO: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Bluetooth SCO Example')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'SCO Status: ${_isScoActive ? "Active" : "Inactive"}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _isScoActive ? Colors.green : Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _checkScoAvailability,
                child: const Text('Check SCO Availability'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _isScoActive ? null : _startSco,
                child: const Text('Start Bluetooth SCO'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _isScoActive ? _stopSco : null,
                child: const Text('Stop Bluetooth SCO'),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _statusMessage.isEmpty ? 'No status' : _statusMessage,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
